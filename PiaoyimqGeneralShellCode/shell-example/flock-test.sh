#!/bin/bash
###test: ./flock-test.sh & ./flock-test.sh & ./flock-test.sh &

{
    flock -x 200 || exit 74
    echo "____$$ lock" 
    
    sleep 3
    echo "____$$ unlock"
} 200</var/tmp


