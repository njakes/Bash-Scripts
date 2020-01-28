#!/bin/bash
set -e

## Find correct partition
#blkid
lsblk
read -p "Select the partition you want to mount: " part
PART_ID=$(blkid -o value -s UUID /dev/$part)
fs_type=$(blkid -o value -s TYPE /dev/$part)

# Prompt user for folder name
read -p "Enter desired folder name: " name
#name=DATA

################################################################################################
# Script to mount DATA drive and symlink folders
################################################################################################
echo Checking for DATA folder
if [ ! -d /mnt/$name ]; then
	mkdir /mnt/$name
fi
echo "---------done---------"

echo Mounting and taking ownership of DATA partition
if [[ $(findmnt -M /mnt/$name) ]]; then
	echo "Already mounted"
else
	mount /dev/$part /mnt/$name
	chown -R $USER: /mnt/$name
fi
echo "---------done---------"

echo "Removing default home folders"
if [ ! -d ~/Documents ]; then
	echo "Documents removed"
else
	rm -R ~/Documents
fi

if [ ! -d ~/Desktop ]; then
	echo "Documents removed"
else
	rm -R ~/Desktop
fi

if [ ! -d ~/Downloads ]; then
	echo "Downloads removed"
else
	rm -R ~/Downloads
fi

if [ ! -d ~/Music ]; then
	echo "Music removed"
else
	rm -R ~/Music
fi

if [ ! -d ~/Pictures ]; then
	echo "Pictures removed"
else
	rm -R ~/Pictures
fi

if [ ! -d ~/Videos ]; then
	echo "Videos removed"
else
	rm -R ~/Videos
fi
echo "---------done---------"

echo "Symlinking DATA folders"
if [ ! -d ~$HOME/Documents ]; then
	ln -s /mnt/$name/Documents $HOME/
fi

if [ ! -d /home/$USER/Desktop ]; then
	ln -s /mnt/$name/Desktop /home/$USER
fi

if [ ! -d /home/$USER/Downloads ]; then
	ln -s /mnt/$name/Downloads /home/$USER
fi

if [ ! -d /home/$USER/Games ]; then
	ln -s /mnt/$name/Games /home/$USER
fi

#if [ ! -d ~/MEGAsync ]; then
#	ln -s /mnt/$name/MEGAsync /home/$USER
#fi

if [ ! -d /home/$USER/Music ]; then
	ln -s /mnt/$name/Music /home/$USER
fi

if [ ! -d /home/$USER/Pictures ]; then
	ln -s /mnt/$name/Pictures /home/$USER
fi

if [ ! -d /home/$USER/Videos ]; then
	ln -s /mnt/$name/Videos /home/$USER
fi

echo "---------done---------"
###########################################################################################################
echo "adding DATA part UUID to fstab"
if grep -Fxq "UUID=$PART_ID /mnt/$name $fs_type defaults,noatime 0 2" /etc/fstab; then
	echo "Already in fstab"
else
	name=DATA
	echo "UUID=$PART_ID /mnt/$name $fs_type defaults,noatime 0 2" >> /etc/fstab
fi
echo "---------done---------"

echo "DATA successfully linked"
