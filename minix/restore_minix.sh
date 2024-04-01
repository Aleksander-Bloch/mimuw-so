#!/bin/bash

qemu-img create -f qcow2 -F raw -o backing_file=backup_minix.img minix.img
