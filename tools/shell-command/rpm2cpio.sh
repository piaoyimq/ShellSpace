#!/bin/bash -e
#set -x

FILE=$1
if [ "${1:0-4:4}" != ".rpm" ]
then
    echo "Not a rpm package"
    exit 76
fi

mkdir ${1%.rpm}

cd ${1%.rpm}
rpm2cpio ../$1 | cpio -idv
