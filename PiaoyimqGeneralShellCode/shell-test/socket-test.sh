#!/bin/bash
 
sendmsg()
{
    msg=$1;
    echo  "$1">&8;
    readmsg;
}
 
readmsg()
{   
    while read -u 8 -d $'\r' name; 
    do 
        if [ "${name}" == "END"  -o "${name}" == "ERROR" ];then
            break;
        fi;
        echo $name;
    done
}

 
create_socket()
{
    exec 8<>/dev/tcp/${host}/${port};
     
    if [ "$?" != "0" ];then
        echo "open $host  $port fail!";
        exit 1;
    fi 
} 

close_socket()
{ 
    exec 8<&-;
    exec 8>&-;
}

if [ $# -lt 2 ];then
    echo "usage:$0 host port [command]";
    exit 1;
fi;
 
[[ $# -gt 2 ]]&&command=$3;
 
command="${command=stats}";
host="$1";
port="$2";

create_socket $host $port 
sendmsg "$command";
 
 
sendmsg "quit";
 
close_socket

 
exit 0;