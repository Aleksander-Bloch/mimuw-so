#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <path_to_file>"
    exit 1
fi

if [ ! -f $1 ]; then
    echo "File $1 does not exist"
    exit 1
fi

scp -P 10022 $1 root@localhost:/root

