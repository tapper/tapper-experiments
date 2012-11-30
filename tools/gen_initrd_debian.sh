#!/bin/bash

cd /lib/modules
kern=0

# we only care about directories
for kernel in $(find . -maxdepth 1 -mindepth 1 -type d -printf %P\\n) ; do
    modules="ixgbe forcedeth r8169 libata sata-sil scsi-mod atiixp ide-disk"
    modules=$modules" ide-core 3c59x tg3 mii amd8111e e1000e bnx2 bnx2x ixgb"
    vmlinuz="/boot/vmlinuz-$kernel"
    initrd="/boot/initrd.img-$kernel"
    if [[ ! -f $initrd && -f $vmlinuz ]]; then
        echo depmod $kernel
        depmod $kernel
        if [[ -e $initrd ]]; then
            echo "deleting existing initrd for $kernel"
            echo "update-initramfs -d -k $kernel"
            update-initramfs -d -k $kernel
        fi
        echo update-initramfs -c -k $kernel
        update-initramfs -c -k $kernel
        # make sure we get the last installed kernel (2.6.3* is always bigger than 2.6.16)
    fi
    if [[ $kernel > $kern ]]; then
        kern=$kernel
    fi
done

cd /boot
ln -sf vmlinuz-$kern vmlinuz
ln -sf initrd.img-$kern initrd
