#### post installation #####
 
# create snapper config
umount /.snapshots/
rm -r /.snapshots/
snapper -c root create-config /
sudo btrfs subvolume delete /.snapshots
mkdir /.snapshots
mount -a
chmod 750 /.snapshots


# allow permissions on snapper: add 'jamespll' in ALLOW_USERS="" and edit limits for timeline cleanup (hourly 5, daily 7)
# e.g: ALLOW_USERS="jamespll"
vim /etc/snapper/configs/root

# configure snapshots timeline and grub
sudo chmod a+rx /.snapshots/
sudo chown :jamespll /.snapshots
systemctl enable --now snapper-timeline.timer
systemctl enable --now snapper-cleanup.timer
systemctl enable --now grub-btrfs.path

# reboot
sudo reboot -h now

# create the first snapshot on the system
snapper -c root create -c timeline --description "After install"

# update and install pacman hook
sudo pacman -Syu
sudo pacman -S snap-pac

# install paru from the aur
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

# enable color in /etc/pacman.conf & BottomUp and filemanager in /etc/paru.conf
sudo vim /etc/pacman.conf
sudo vim /etc/paru.conf

# change current theme to breeze in sddm
sudo vim /usr/lib/sddm/sddm.conf.d/default.conf












