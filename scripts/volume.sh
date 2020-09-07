#!/usr/bin/env bash

if [[ $(cat /etc/fstab | grep "/docker") ]]
then
  echo "Nothing to do: volume already mounted"
else
  parted /dev/sdb mklabel msdos
  parted /dev/sdb mkpart primary 512 100%
  mkfs.xfs /dev/sdb1
  mkdir -p /docker
  echo `blkid /dev/sdb1 | awk '{print$2}' | sed -e 's/"//g'`  /docker   xfs   defaults   0   0 >> /etc/fstab
  mount /docker
fi
