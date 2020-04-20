#!/bin/bash
set -e
[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"
## Find correct partition
#blkid
lsblk -fs
read -p "Select the partition you want to mount: " part
PART_ID=$(blkid -o value -s UUID /dev/$part)
fs_type=$(blkid -o value -s TYPE /dev/$part)

# Prompt user for folder name
read -p "Enter desired folder name: " name
#name=DATA

read -p "Enter owner/user name: " user_name
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
	sudo chown -R $user_name: /mnt/$name
fi
echo "---------done---------"

echo "Removing default home folders"
if [ ! -d /home/$user_name/Documents ]; then
	echo "Documents removed"
else
	rm -R /home/$user_name/Documents
fi

if [ ! -d /home/$user_name/Desktop ]; then
	echo "Documents removed"
else
	rm -R /home/$user_name/Desktop
fi

if [ ! -d /home/$user_name/Downloads ]; then
	echo "Downloads removed"
else
	rm -R /home/$user_name/Downloads
fi

if [ ! -d /home/$user_nameMusic ]; then
	echo "Music removed"
else
	rm -R /home/$user_name/Music
fi

if [ ! -d /home/$user_name/Pictures ]; then
	echo "Pictures removed"
else
	rm -R /home/$user_name/Pictures
fi

if [ ! -d /home/$user_name/Videos ]; then
	echo "Videos removed"
else
	rm -R /home/$user_name/Videos
fi
echo "---------done---------"

echo "Symlinking DATA folders"
if [ ! -d /home/$user_name/Documents ]; then
	ln -s /mnt/$name/Documents /home/$user_name
fi

if [ ! -d /home/$user_name/Desktop ]; then
	ln -s /mnt/$name/Desktop /home/$user_name
fi

if [ ! -d /home/$user_name/Downloads ]; then
	ln -s /mnt/$name/Downloads /home/$user_name
fi

if [ ! -d /home/$user_name/Games ]; then
	ln -s /mnt/$name/Games /home/$user_name
fi

if [ ! -d /home/$user_name/GameShortcuts ]; then
	ln -s /mnt/$name/GameShortcuts /home/$user_name
fi

#if [ ! -d ~/MEGAsync ]; then
#	ln -s /mnt/$name/MEGAsync /home/$USER
#fi

if [ ! -d /home/$user_name/Music ]; then
	ln -s /mnt/$name/Music /home/$user_name
fi

if [ ! -d /home/$user_name/Pictures ]; then
	ln -s /mnt/$name/Pictures /home/$user_name
fi

if [ ! -d /home/$user_name/Videos ]; then
	ln -s /mnt/$name/Videos /home/$user_name
fi

if [ ! -d /home/$user_name/git ]; then
	ln -s /mnt/$name/git /home/$user_name
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
