#!/bin/bash

gnome-terminal --tab --title="minix_emulator" --command="qemu-system-x86_64 -curses -drive file=minix.img -enable-kvm -machine kernel_irqchip=off -rtc base=localtime -net user,hostfwd=tcp::10022-:22 -net nic,model=virtio -m 1024M"
