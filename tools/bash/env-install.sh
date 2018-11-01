#!/bin/bash
#set -x
unalias -a

VERSION=0.1.0

NFS_SERVER="192.168.1.1"
SERVER_DEPLOY_ENV_PATH="/home/qa/gss-nfs-server/env" #only read
SERVER_DEPLOY_PUB_PATH="/home/qa/gss-nfs-server/pub" #read/write

#TODO: ALLOWED_CLIENT should obtain info from nfs server /etc/exports, and need to support multiple ip
ALLOWED_CLIENT=("10.150.*.*" "192.153.110.7")  #Only support ip pattern endwith "*"

CLIENT_ENV_MOUNT_POINT="/proj/development-env"  #Always don't change it(it will impact client mount when power on)

CLIENT_PUB_MOUNT_POINT="/proj/public"  #Always don't change it(it will impact client mount when power on)

PASSWORD=""
 
SCRIPTS_FULL_NAME="$0"
#TODO: client hang up, when use df cmd in nfs server shutdown time.

SERVER_DEPLOY_ENV_SPECIFIC_PATH=""

err_exit()
{
    echo -e "\033[31mError: $2\nAborting...\033[0m" >&2
    exit $1
}


warning()
{
#If you need no '\n', set the 2nd paramter is true
    if [ 2 -eq $# ]
    then
        echo -ne "\033[32m$1\033[0m"
    else
        echo -e "\033[33m$1\033[0m"
    fi
}


info()
{
#If you need no '\n', set the 2nd paramter is true
    if [ 2 -eq $# ]
    then
        echo -ne "\033[32m$1\033[0m"
    else
        echo -e "\033[32m$1\033[0m"
    fi
}


show_mount_info()
{
    local depth=2
    local timeout_sec=5
    which tree >& /dev/null
    if [ $? -eq 0 ]
    then
        which timeout >& /dev/null
        if [ $? -eq 0 ]
        then
            timeout $timeout_sec tree $CLIENT_ENV_MOUNT_POINT -L $depth 2>/dev/null || err_exit 74 "Timeout: maybe NFS server($NFS_SERVER) stoped"
            timeout $timeout_sec tree $CLIENT_PUB_MOUNT_POINT -L $depth 2>/dev/null || err_exit 74 "Timeout: maybe NFS server($NFS_SERVER) stoped"        
        else
            echo -e "$CLIENT_ENV_MOUNT_POINT\n$CLIENT_PUB_MOUNT_POINT"
        fi
    else
        which timeout >& /dev/null
        if [ $? -eq 0 ]
        then
            timeout $timeout_sec find $CLIENT_ENV_MOUNT_POINT -type d  -maxdepth $depth 2> /dev/null || err_eixt 74 "timeout: maybe NFS server($NFS_SERVER) stoped"
            timeout $timeout_sec find $CLIENT_ENV_MOUNT_POINT -type d  -maxdepth $depth 2> /dev/null || err_eixt 74 "timeout: maybe NFS server($NFS_SERVER) stoped"
        else
            echo -e "$CLIENT_ENV_MOUNT_POINT\n$CLIENT_PUB_MOUNT_POINT"
        fi            
    fi
    
    info "After excuting 'source ~/.bashrc' or opening a new terminal, and run 'gss-env', then you can use gss environment"
}


excute_cmd()
{
     ret=$(eval "$1" 2>&1) || err_exit 74 "$ret"
}


excute_cmd_with_root()
{
    if [[ 0 -ne "$UID" && ! $PASSWORD ]]
    then
        info "Entrer root password:" true
        read -s PASSWORD
        echo ""
    elif [ 0 -eq "$UID" ]
    then  
        eval "$1" || err_exit 74 "Excute \"$1\" failed"
        return 
    fi

    which expect >& /dev/null
    if [ $? -ne 0 ]
    then
su root >& /dev/null <<EOF
$PASSWORD
#set -x
$1
EOF
    
    else
    
/usr/bin/expect <<EOF
log_user 0
spawn su root

expect "Password:"
send "$PASSWORD\r"

expect {
*#* {}
eof  {exit 47;}
}


send {$1; echo "exit_code:\$?"}
send "\r"

expect {
"exit_code:\[1-9\]" {exit 49}
"exit_code:0" {exit 0}
eof {exit 0}
}

EOF
    #echo "____exit:$?" #debug if expect scripts run successfully
    fi  
}


setup_gss_env()
{
    if [ ! -e "/usr/bin/gss-env" ]
    then
        cmd_create_link="ln -s /proj/development-env/bin/gss-env-init.sh /usr/bin/gss-env"
        excute_cmd_with_root "$cmd_create_link" || err_exit 74 "Excute $cmd_create_link failed"
    fi 
}


logging_mount_history()
{
###logging format: 
###date, ip, hostname, linux_version, arch, username, mount_point, mount_status
    local current_time=`date "+%Y-%m-%d %H:%M:%S%:z"`
    local client_ip=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|grep -v 192.168.* |awk '{print $2}'|tr -d "addr:"|sed -n "1p"`
    local hostname=`hostname`
    local version=`cat /etc/redhat-release|grep -o "release .*"`
    local arch=`uname -p`
    local user=`whoami`
    
    excute_cmd_with_root "echo \"$current_time, $client_ip, $hostname, $version, $arch, $user, $1, $2\" >> $CLIENT_PUB_MOUNT_POINT/users/.mount-history.log"
}


update_myself()
{
    local scripts_name=`basename $SCRIPTS_FULL_NAME`
    local scripts_path=`dirname $SCRIPTS_FULL_NAME`
    local download_file="$scripts_name.new"
    local download_enable=true

    if [ $1 ]
    then
        download_enable=false
    fi

    if $download_enable
    then
        local dir_path=`dirname $SERVER_DEPLOY_ENV_PATH`
        excute_cmd "wget ftp://10.150.10.178:21/$dir_path/tools/install/$scripts_name --ftp-user=qa --ftp-password=qa -q -O ${scripts_path}/$download_file"

        diff $SCRIPTS_FULL_NAME $scripts_path/$download_file >& /dev/null
        if [ $? -ne 0 ]
        then
            local version=`cat $scripts_path/$download_file |grep -P "VERSION=\d.\d.\d"`
            info "Already update to latest $version, please run again."
            excute_cmd "chmod 775 $scripts_path/$download_file"

#TODO:check the following 2 lines code if every time run successfully
            excute_cmd "mv $scripts_path/$download_file $SCRIPTS_FULL_NAME"
            excute_cmd "rm -rf $scripts_path/$download_file"
            exit 0
        else
            excute_cmd "rm -rf $scripts_path/$download_file"
        fi
    fi
}


###@return:
###0: pub and env already mounted
###1: pub not mounted
###2: env not mounted
###3: both pub and env not mounted
check_if_mounted()
{
    cat /proc/mounts|grep `echo ${CLIENT_ENV_MOUNT_POINT}` >& /dev/null
    local env_code=$?
     
    cat /proc/mounts|grep `echo ${CLIENT_PUB_MOUNT_POINT}` >& /dev/null
    local pub_code=$?
    
    if [[ $env_code -eq 0 && $pub_code -eq 0 ]]
    then
        setup_gss_env

        warning "Remote storage already mounted: "
        show_mount_info
        exit 0
    fi

    local i=0
    local ip_characters=""
    for ip in ${ALLOWED_CLIENT[@]}
    do
        local ip_pattern=$(echo $ip |sed -e "s/\*/\[0-9\]\{1,\}/g" -e "s/\./\\\./g")
        /sbin/ifconfig |grep -P "$ip_pattern" >& /dev/null && break
        
        i=`expr $i + 1`
        ip_characters="$ip_characters $ip "
        if [ $i -eq ${#ALLOWED_CLIENT[@]} ] 
        then
            err_exit 74 "Only allow $ip_characters client to mount."
        fi
    done
    
    
    if [[ $env_code -ne 0  && $pub_code -ne 0 ]]
    then
        return 3
    elif [ $env_code -ne 0 ]
    then
        return 2
    elif [ $pub_code -ne 0 ]
    then
        return 1        
    fi
}


set_env_nfs_specific_path()
{ 
    local redhat_version=$(cat /etc/redhat-release|grep -o "release [0-9]")

    local arch=$(uname -p)
    
    if [[ "release 7" = "$redhat_version" && "x86_64" = "$arch" ]]
    then
        SERVER_DEPLOY_ENV_SPECIFIC_PATH="$SERVER_DEPLOY_ENV_PATH/redhat-7.2-x86_64/"
    elif [[ "release 5" = "$redhat_version" && "x86_64" = "$arch" ]]
    then
        SERVER_DEPLOY_ENV_SPECIFIC_PATH="$SERVER_DEPLOY_ENV_PATH/redhat-5.8-x86_64/"
    elif  [[ "release 3" = "$redhat_version" && ("i686" = "$arch" || "i386" = "$arch") ]]
    then
        SERVER_DEPLOY_ENV_SPECIFIC_PATH="$SERVER_DEPLOY_ENV_PATH/redhat-3.2-i386"
    else
        err_exit 74 "Unkonw redhat version(${redhat_version}, ${arch}), only support: redhat-3.2-i386, redhat-5.8-x86_64, redhat-7.2-x86_64"
    fi
}

    
set_power_on_mount()
{
    local fstab_file="/etc/fstab"
    
    local power_on_mount_env_config="$NFS_SERVER:$SERVER_DEPLOY_ENV_SPECIFIC_PATH    $CLIENT_ENV_MOUNT_POINT    nfs    defaults    0 0"
    if [ "$(cat $fstab_file |grep $CLIENT_ENV_MOUNT_POINT)" != "$power_on_mount_env_config" ];
    then
        local escape_characters=$(echo "$power_on_mount_env_config"| sed -e 's/\./\\\./g' -e 's/\//\\\//g')

        local cmd_delete_env_line="sed -i '/^[0-9].*\/proj\/development-env.*[0-9]$/d' $fstab_file"
        excute_cmd_with_root "$cmd_delete_env_line" || err_exit 74 "Incorrect password or Excute \"$cmd_delete_env_line\" failed"

        local last_line='$a'
        local cmd_insert_env_line="sed -i \"\\$last_line $escape_characters\" $fstab_file"
        excute_cmd_with_root "$cmd_insert_env_line" || err_exit 74 "Incorrect password or Excute \"$cmd_insert_env_line\" failed"
    fi
    
    
    local power_on_mount_pub_config="$NFS_SERVER:$SERVER_DEPLOY_PUB_PATH    $CLIENT_PUB_MOUNT_POINT    nfs    defaults    0 0"
    if [ "$(cat $fstab_file |grep $CLIENT_PUB_MOUNT_POINT)" != "$power_on_mount_pub_config" ];
    then
        local escape_characters=$(echo "$power_on_mount_pub_config"| sed -e 's/\./\\\./g' -e 's/\//\\\//g')

        local cmd_delete_pub_line="sed -i '/^[0-9].*\/proj\/public.*[0-9]$/d' $fstab_file"
        excute_cmd_with_root "$cmd_delete_pub_line" || err_exit 74 "Incorrect password or Excute \"$cmd_delete_pub_line\" failed"

        local last_line='$a'
        local cmd_insert_pub_line="sed -i \"\\$last_line $escape_characters\" $fstab_file"
        excute_cmd_with_root "$cmd_insert_pub_line" || err_exit 74 "Incorrect password or Excute \"$cmd_insert_pub_line\" failed"
    fi
}


mount_env()
{
    local cmd_mkdir_env="[ -e $CLIENT_ENV_MOUNT_POINT ] || mkdir -p $CLIENT_ENV_MOUNT_POINT"
    excute_cmd_with_root  "$cmd_mkdir_env" || err_exit 74 "Incorrect password or Excute \"$cmd_mkdir_env\" failed" 

    local cmd_mount_env="mount -t nfs -o soft,timeo=30,retry=3 $NFS_SERVER:${SERVER_DEPLOY_ENV_SPECIFIC_PATH} ${CLIENT_ENV_MOUNT_POINT}"
    excute_cmd_with_root  "$cmd_mount_env" || err_exit 74 "Incorrect password or Excute \"$cmd_mount_env\" failed"
    
    logging_mount_history "$CLIENT_ENV_MOUNT_POINT" "success"
}


mount_pub()
{
    local cmd_mkdir_pub="[ -e $CLIENT_PUB_MOUNT_POINT ] || mkdir -p $CLIENT_PUB_MOUNT_POINT"
    excute_cmd_with_root  "$cmd_mkdir_pub" || err_exit 74 "Incorrect password or Excute \"$cmd_mkdir_pub\" failed"
    
    local cmd_mount_pub="mount -t nfs -o soft,timeo=30,retry=3 $NFS_SERVER:${SERVER_DEPLOY_PUB_PATH} ${CLIENT_PUB_MOUNT_POINT}"
    excute_cmd_with_root  "$cmd_mount_pub" || err_exit 74 "Incorrect password or Excute \"$cmd_mount_pub\" failed"
    
    logging_mount_history "$CLIENT_PUB_MOUNT_POINT" "success"
}


mount_nfs()
{
    if [ $1 -eq 3 ]
    then
        mount_pub
        mount_env
    elif [ $1 -eq 2 ]
    then
        mount_env
    elif [ $1 -eq 1 ]
    then
        mount_pub
    fi

    setup_gss_env
    
    info "\nMount successfully:"
    show_mount_info
    
}

update_myself $1
check_if_mounted
mount_status=$?
set_env_nfs_specific_path

set_power_on_mount 

mount_nfs $mount_status

exit 0

