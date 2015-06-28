#!/bin/bash


if [[ ! -z $(grep 'swap' /etc/fstab) ]]; then
	echo "Swap space already configured in /etc/fstab: $(grep 'swap' /etc/fstab)"
	exit 1;
fi

swapFile='/swapfile'

memSize=$(free -m | grep "Mem:" | awk '{print $2}')

echo "Creating ${memSize}MB swap file..."
sudo fallocate -l ${memSize}M $swapFile
sudo chmod 600 /swapfile

ls -lh $swapFile

sudo mkswap $swapFile

sudo swapon $swapFile

sudo bash -c 'echo "'$swapFile'	none	swap	sw	0	0" >> /etc/fstab'
