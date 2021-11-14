# Check Network
ip link
ping archlinux.org
timedatectl set-ntp true

# DISK PARTITIONING
pacman -S --noconfirm gptfdisk
fdisk -l
lsblk
#

# cfdisk /dev/sdX
# For UEFI select GPT
# Create 550MB EFI partition
# Create 8GB Swap partition
# Create / partition with remaining space
# Create Filesystems:
# mkfs.fat -F32 /dev/sdX1
# mkswap /dev/sdX2
# swapon /dev/sdX2
# mkfs.ext4 /dev/sdX3

# Mount created partitions

mount /dev/sdX3 /mnt
swapon /dev/sdX2

# Now INSTALL ARCH
pacstrap /mnt base base-devel linux linux-firmware vim nano sudo archlinux-keyring wget libnewt --noconfirm --needed

# Create Fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Configure new install
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Australia/Melbourne /etc/localtime
hwclock --systohc
# nano /etc/locale.gen and uncomment en_US.UTF-8 UTF-8
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8
echo Archlinux > /etc/hostname
# edit nano /etc/hosts
# 127.0.0.1	localhost
# ::1	        localhost
# 127.0.0.1	Archlinux.localdomain	Archlinux
pacman -S networkmanager dhclient --noconfirm --needed
systemctl enable NetworkManager

# Set Root Password
passwd

# Install GRUB
pacman -S grub efibootmgr
mkdir /boot
mkdir /boot/efi
mount /dev/sdX1 /boot/efi
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg

# Install KDE
pacman -S xorg plasma plasma-wayland-session kde-applications 
systemctl enable sddm.service
systemctl enable NetworkManager.service