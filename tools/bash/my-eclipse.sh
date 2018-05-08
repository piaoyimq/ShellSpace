#!/bin/bash
#set -x 
cd /home/azhweib/my-software/eclipse
#$1 is absolute path
nohup ./eclipse -data $1&
