#!/bin/bash
set -x
if [[ $1 == "" ]]
then
    echo "Usage:
          ./read_parameter_with_line break.sh \"keywords1\\nkeywords2\\n...\""
    exit 74
fi




#echo  "$1" |while read line
echo  -e "$1" |while read line
do
    echo "$line==="
done


