#!/bin/bash

cd /lib/modules
kern=0

# we only care about directories
for kernel in $(find . -maxdepth 1 -mindepth 1 -type d -printf %P\\n) ; do
    modules="ixgbe forcedeth r8169 libata sata-sil scsi-mod atiixp ide-disk"
    modules=$modules" ide-core 3c59x tg3 mii amd8111e e1000e bnx2 bnx2x ixgb"
    vmlinuz="/boot/vmlinuz-$kernel"
    initrd="/boot/initrd-$kernel"
    if [[ ! -f $initrd && -f $vmlinuz ]]; then
        echo depmod $kernel
        depmod $kernel
        echo mkinitrd $vmlinuz
        mkinitrd -k $vmlinuz -i $initrd -m "$modules"
        # make sure we get the last installed kernel (2.6.3* is always bigger than 2.6.16)
        if [[ $kernel > $kern ]]; then
            kern=$kernel
        fi
    fi
done

cd /boot
ln -sf vmlinuz-$kern vmlinuz
ln -sf initrd-$kern initrd
