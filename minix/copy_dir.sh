#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <path_to_dir>"
    exit 1
fi

if [ ! -d $1 ]; then
    echo "Directory $1 does not exist"
    exit 1
fi

scp -P 10022 -r $1 root@localhost:/root

