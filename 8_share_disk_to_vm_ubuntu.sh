#!/bin/bash
export DIR=$(pwd)

# 1. Enabled VMware settings as below
# VM > Settings > Options > Shared Folders > Folder sharing > Always enabled > ADD

# vmware-hgfsclient
sudo rm /etc/fstab
sudo cp $DIR/fstab /etc/.
sudo mkdir -p /mnt/hgfs
sudo mount -a
cd /mnt/hgfs
