#!/bin/bash
#This shell only could be ran under currently, use './env-setup.sh'
#


BASE_PATH=$(cd $(cd "$(dirname "$0")"; pwd)/..; pwd)
BIN_PATH=$HOME/bin
echo BASE_PATH:$BASE_PATH
#git

set -x
#echo "[alias]
#	hist = log --graph --pretty=format:'%Cred%h%Creset %s -%C(yellow)%d%Creset% Cgreen[%an]%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative" >> .git/config


#git config --global color.status auto
#git config --global color.add auto


#shell

if [ ! -d $BIN_PATH ] 
then
    mkdir $BIN_PATH 
    cd $BIN_PATH
    ln -s $BASE_PATH/ShellSpace/PiaoyimqGeneralShellCode/shell-test/vim.sh vim.sh 
    ln -s $BASE_PATH/ShellSpace/PiaoyimqGeneralShellCode/shell-test/vimdiff.sh vimdiff.sh 
else
    cd $BIN_PATH
    ln -s $BASE_PATH/ShellSpace/PiaoyimqGeneralShellCode/shell-test/vim.sh vim.sh 
    ln -s $BASE_PATH/ShellSpace/PiaoyimqGeneralShellCode/shell-test/vimdiff.sh vimdiff.sh 
fi 
