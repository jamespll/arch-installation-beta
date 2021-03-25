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

genfstab -U /mnt 	>> /mnt/etc/fstab
arch-chroot /mnt --

ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc

echo "jamespll-arch" >> /etc/hostname
echo -e "\n127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\tjamespll-arch.localdomain\tjamespll-arch" >> /etc/hosts

passwd

pacman -S grub grub-btrfs efibootmgr networkmanager network-manager-applet wireless_tools wpa_supplicant dialog os-prober mtools dosfstools base-devel linux-headers reflector xorg gdm xf86-video-qxl xf86-video-intel gnome firefox xdg-utils

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

echo "Installation complete!"
