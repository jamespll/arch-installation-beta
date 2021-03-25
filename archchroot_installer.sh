#!/bin/bash

ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc
echo -e "\nen_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

echo "jamespll-arch" >> /etc/hostname
echo -e "\n127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\tjamespll-arch.localdomain\tjamespll-arch" >> /etc/hosts

passwd

pacman -S grub grub-btrfs efibootmgr networkmanager network-manager-applet wireless_tools wpa_supplicant dialog os-prober mtools dosfstools base-devel linux-headers reflector xorg gdm xf86-video-qxl xf86-video-intel gnome gnome-extra firefox xdg-utils

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager

useradd -mG wheel jamespll
passwd jamespll
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

systemctl enable gdm

umount /.snapshots/
rm -rf /.snapshots/
snapper -c root create-config /
