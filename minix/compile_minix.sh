#!bin/sh

mv ab417519.patch /
cd /
patch -t -p1 < ab417519.patch
cd /usr/src; make includes
cd /usr/src/minix/servers/vfs/; make clean && make && make install
cd /usr/src/releasetools; make do-hdboot
reboot
