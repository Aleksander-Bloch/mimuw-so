#!/bin/sh

echo "Sector's are indexed from 0."
echo "Disk's sector 0: bootloader code"
dd bs=512 count=1 if=/dev/c0d0 | od -Ax -tx1 -v

echo "Disk's sector 63: start of the 1st partition"
dd bs=512 skip=63 count=1 if=/dev/c0d0 | od -Ax -tx1 -v

echo "Sector 0 of the 1st partition (same as above)"
dd bs=512 count=1 if=/dev/c0d0p0 | od -Ax -tx1 -v

echo "Disk's sector 1: all zeroes"
dd bs=512 skip=1 count=1 if=/dev/c0d0 | od -Ax -tx1 -v

echo "Disk's sector 62: all zeroes"
dd bs=512 skip=62 count=1 if=/dev/c0d0 | od -Ax -tx1 -v
