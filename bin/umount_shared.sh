#!/bin/bash

MOUNT_ROOT=$(dirname $(dirname $(readlink -f $0)))
MAP=$MOUNT_ROOT/.map

do_umount() {
    point="$1"
    mountpoint="$MOUNT_ROOT/mnt/$point"
    if [ -d "$mountpoint" ]; then
        sudo umount "$mountpoint"
        rmdir "$mountpoint"
        notify-send -u low "$point unmounted."
    fi
}

if [ -n "$1" ]; then
    do_umount "$1"
else
    cat $MAP | while read share point type; do
        do_umount "$point"
    done
fi
