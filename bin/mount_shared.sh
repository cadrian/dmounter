#!/bin/bash

MOUNT_ROOT=$(dirname $(dirname $(readlink -f $0)))
MAP=$MOUNT_ROOT/.map

do_mount() {
    share="$1"
    point="$2"
    type="$3"
    mountpoint="$MOUNT_ROOT/mnt/$point"
    if test -d "$mountpoint" && { mount | grep -q '^'"$share"' on '"$mountpoint"; } then
        notify-send -u low "$share already mounted!"
    else
        mkdir -p "$mountpoint"
        . $MOUNT_ROOT/bin/_mount_"$type"
    fi
    echo "$mountpoint"
}

if [ -n "$1" ]; then
    share=$(cat $MAP | grep " $1 " | awk '{print $1}')
    type=$(cat $MAP | grep " $1 " | awk '{print $3}')
    do_mount "$share" "$1" "$type"
else
    cat $MAP | while read share point type; do
        do_mount "$share" "$point" "$type"
    done
fi
