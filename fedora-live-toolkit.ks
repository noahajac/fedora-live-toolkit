%include ../fedora-live-workstation.ks

clearpart --none

part /boot/efi --fstype=efi --size=300 --onpart=/dev/sda1
part biosboot --fstype=biosboot --size=1 --onpart=/dev/sda2
part / --fstype=ext4 --size=10713 --onpart=/dev/sda3
part /mnt/fedora-live-toolkit_data --fstype=ext4 --size=1024 --onpart=/dev/sda4 --fsoptions="x-gvfs-show,nofail,x-systemd-device-timeout=1ms"

bootloader --location=mbr --append="rd.live.image"

repo --name=google-chrome --baseurl=https://dl.google.com/linux/chrome/rpm/stable/x86_64

%packages
ark
chntpw
google-chrome-stable
gparted
%end

%pre

sgdisk -Z /dev/sda

sgdisk /dev/sda -n 1:2048:616447
sgdisk /dev/sda -t 1:EF00
sgdisk /dev/sda -c 1:"EFI System Partition"
sgdisk /dev/sda -n 2:616448:618495
sgdisk /dev/sda -t 2:EF02
sgdisk /dev/sda -n 3:618496:22558719
sgdisk /dev/sda -n 4:22558720:24655871

%end

%post

cat > /etc/fstab << EOF
PARTUUID=b04805e3-54b1-4575-b958-4f1895c1a256 /boot/efi vfat ro,defaults,uid=0,gid=0,umask=077,shortname=winnt 0 2
PARTUUID=16f10834-6578-4fc4-af4d-2cfac6f9b75b /mnt/fedora-live-toolkit_data auto    x-gvfs-show,nofail,x-systemd-device-timeout=1ms 0 2
vartmp   /var/tmp    tmpfs   defaults   0  0
EOF

cat > /var/lib/livesys/livesys-session-extra << EOF
#!/usr/bin/env bash

if [ -f /usr/share/applications/anaconda.desktop ]; then
  sed -i -e 's/NoDisplay=false/NoDisplay=true/' /usr/share/applications/anaconda.desktop
  sed -i -e "s/favorite-apps=.*/favorite-apps=['org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop', 'google-chrome.desktop']/" /usr/share/glib-2.0/schemas/org.gnome.shell.gschema.override
  if [ -f ~liveuser/.config/autostart/org.fedoraproject.welcome-screen.desktop ]; then
    rm /usr/share/applications/org.fedoraproject.welcome-screen.desktop
    rm ~liveuser/.config/autostart/org.fedoraproject.welcome-screen.desktop
  fi
fi

glib-compile-schemas /usr/share/glib-2.0/schemas

hostnamectl set-hostname "fedora-live-toolkit"

EOF

sed -E -i 's/(^VERSION="[[:digit:]]* \()Workstation Edition(\)"$)/\1Live Toolkit\2/' /etc/os-release
sed -E -i 's/(^PRETTY_NAME="Fedora Linux [[:digit:]]* \()Workstation Edition(\)"$)/\1Live Toolkit\2/' /etc/os-release

grub2-install --target i386-pc /dev/sda

kernel-install add $(ls -AU /lib/modules | head -1) /lib/modules/$(ls -AU /lib/modules | head -1)/vmlinuz 

%end
