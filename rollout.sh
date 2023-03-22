#!/usr/bin/env

sudo su

cd /tmp
curl -o /tmp/nixfiles.zip -L "https://github.com/TeeWallz/nixfiles/archive/refs/heads/master.zip"
unzip /tmp/nixfiles.zip
cd /tmp/nixfiles-master

export DISK='/dev/disk/by-id/ata-QEMU_HARDDISK_QM00003'
export INST_PARTSIZE_SWAP=4
./hosts/common/zfs-optin-persistence/zfs-optin-persistence.sh 

nixos-install --flake .#zamorak