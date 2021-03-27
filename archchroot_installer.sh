#!/bin/bash

ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc
echo -e "\nen_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

echo "jamespll-arch" >> /etc/hostname
echo -e "\n127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\tjamespll-arch.localdomain\tjamespll-arch" >> /etc/hosts

passwd

pacman -S grub grub-btrfs efibootmgr networkmanager wireless_tools wpa_supplicant dialog os-prober mtools dosfstools base-devel linux-headers reflector xorg xf86-video-qxl mesa xdg-utils firefox bat ranger curl wget plasma sddm konsole dolphin okular gwenview

#intel: xf86-video-intel libgl
#amd: xf86-video-amdgpu
#virtualbox: virtualbox-guest-utils

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager

useradd -mG wheel jamespll
passwd jamespll
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

systemctl enable sddm
