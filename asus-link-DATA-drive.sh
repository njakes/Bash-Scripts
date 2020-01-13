#!/bin/bash
set -e
################################################################################################
# Script to mount DATA drive and symlink folders
################################################################################################
echo Checking for DATA folder
if [ ! -d /mnt/DATA ]; then   ### Modify DATA to whatever you want to call the mounted folder.
	sudo mkdir /mnt/DATA
fi
echo "---------done---------"

echo Mounting and taking ownership of DATA partition
if [[ $(findmnt -M /mnt/DATA) ]]; then   ### Modify DATA to whatever you want to call the mounted folder.
	echo "Already mounted"
else
	sudo mount /dev/sda4 /mnt/DATA ######## Modify with the drive that you are trying to mount. Use lsblk and blkid to find the correct one.
	sudo chown -R jakes: /mnt/DATA ######## Replace jakes with your username.
fi
echo "---------done---------"

echo "Removing default home folders"
if [ ! -d /home/jakes/Documents ]; then
	echo "Documents removed"
else
	sudo rm -R /home/jakes/Documents
fi

if [ ! -d /home/jakes/Desktop ]; then
	echo "Documents removed"
else
	sudo rm -R /home/jakes/Desktop
fi

if [ ! -d /home/jakes/Downloads ]; then
	echo "Downloads removed"
else
	sudo rm -R /home/jakes/Downloads
fi

if [ ! -d /home/jakes/Music ]; then
	echo "Music removed"
else
	sudo rm -R /home/jakes/Music
fi

if [ ! -d /home/jakes/Pictures ]; then
	echo "Pictures removed"
else
	sudo rm -R /home/jakes/Pictures
fi

if [ ! -d /home/jakes/Videos ]; then
	echo "Videos removed"
else
	sudo rm -R /home/jakes/Videos
fi
echo "---------done---------"

echo "Symlinking DATA folders"
if [ ! -d /home/jakes/Documents ]; then
	ln -s /mnt/DATA/Documents /home/jakes
fi

if [ ! -d /home/jakes/Desktop ]; then
	ln -s /mnt/DATA/Desktop /home/jakes
fi

if [ ! -d /home/jakes/Downloads ]; then
	ln -s /mnt/DATA/Downloads /home/jakes
fi

if [ ! -d /home/jakes/Games ]; then
	ln -s /mnt/DATA/Games /home/jakes
fi

#if [ ! -d /home/jakes/MEGAsync ]; then
#	ln -s /mnt/DATA/MEGAsync /home/jakes
#fi

if [ ! -d /home/jakes/Music ]; then
	ln -s /mnt/DATA/Music /home/jakes
fi

if [ ! -d /home/jakes/Pictures ]; then
	ln -s /mnt/DATA/Pictures /home/jakes
fi

if [ ! -d /home/jakes/Videos ]; then
	ln -s /mnt/DATA/Videos /home/jakes
fi

echo "---------done---------"
###########################################################################################################
# Replace the UUID below with the one for the drive you are trying to mount.  Use a partition program or 'sudo blkid'
###########################################################################################################
echo "adding DATA part UUID to fstab"
if grep -Fxq "UUID=a08477fd-ee75-4675-8371-03019f4e0d6a /mnt/DATA ext4 defaults,noatime 0 2" /etc/fstab; then
	echo "Already in fstab"
else
	sudo echo 'UUID=a08477fd-ee75-4675-8371-03019f4e0d6a /mnt/DATA ext4 defaults,noatime 0 2' >> /etc/fstab
fi
echo "---------done---------"

echo "DATA successfully linked"
