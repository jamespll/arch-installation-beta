#!/bin/bash

pacman -Syyy
pacman -S reflector
reflector -c Brazil -a 6 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syyy
timedatectl set-ntp true

parted /dev/sda mklabel gpt
parted /dev/sda mkpart P1 fat32 1MiB 261MiB 
parted /dev/sda	set 1 esp on
parted /dev/sda mkpart P2 linux-swap 261MiB 2309MiB 
parted /dev/sda mkpart P3 btrfs 2309MiB 100%

mkfs.fat -F32 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mkfs.btrfs /dev/sda3

mount /dev/sda3 /mnt

btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@var
btrfs su cr /mnt/@snapshots

umount /mnt

mount -o noatime,compress=lzo,space_cache,subvol=@ /dev/sda3 /mnt
mkdir -p /mnt/{boot,home,var,.snapshots}
mount -o noatime,compress=lzo,space_cache,subvol=@home /dev/sda3 /mnt/home
mount -o noatime,compress=lzo,space_cache,subvol=@var /dev/sda3 /mnt/var
mount -o noatime,compress=lzo,space_cache,subvol=@snapshots /dev/sda3 /mnt/.snapshots

mount /dev/sda1 /mnt/boot

pacstrap /mnt base linux linux-firmware vim snapper

chmod +x install_chroot.sh
cp install_chroot.sh /mnt/install_chroot.sh
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt ./install_chroot.sh
