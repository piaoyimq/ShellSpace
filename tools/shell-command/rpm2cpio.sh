#!/bin/bash -e
#set -x

FILE=$1
if [ "${1:0-4:4}" != ".rpm" ]
then
    echo "Not a rpm package"
    exit 76
fi

#mkdir ${1%.rpm}
BASE_NAME=`basename $1`
mkdir ${BASE_NAME%.rpm}

ABSOLUTE_PATH=`readlink -f $1`
cd ${BASE_NAME%.rpm}

rpm2cpio $ABSOLUTE_PATH | cpio -idv
