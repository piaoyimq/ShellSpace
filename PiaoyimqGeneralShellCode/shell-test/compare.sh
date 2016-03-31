#!/bin/bash

find . -type f -name $1 -ok vimdiff {} /workspace/git/ezhweib/epg-3/{} \;
find . -type f -name $1 -exec vimdiff {} /workspace/git/ezhweib/epg-3/{} \;
#find . -type f -name $1 -exec vim {} \;
