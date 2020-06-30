#!/bin/sh
set -ex
echo Installing Centos $CENTOS_RELEASE
dnf update
dnf install -y \
    systemd-sysv \
    vim \
    binutils \
    dialog \
    openssh-server \
    openssh-clients \
    sudo \
    curl \
    less \
    man-db \
    bind-utils \
    net-tools

# disable services we do not need
systemctl disable kdump systemd-resolved fstrim.timer fstrim
if [ ${CENTOS_RELEASE} = "8" ]; then
    # systemd does not seem to realize that /dev/null is NOT a terminal
    # under lx but when trying to chown it, it fails and thus the `User=`
    # directive does not work properly ... this little trick fixes the
    # behavior for the user@.service but obviously it has to be fixed in
    # lx :) ...
    touch /etc/systemd/null
    mkdir -p /etc/systemd/system/user@.service.d
    echo "[Service]\nStandardInput=file:/etc/systemd/null\n" > /etc/systemd/system/user@.service.d/override.conf
fi

# disable systemd faeatures not present in lx (namely cgroup support)
for S in systemd-hostnamed systemd-localed systemd-timedated systemd-logind systemd-initctl  systemd-journald; do
  O=/etc/systemd/system/${S}.service.d
  mkdir -p $O
  cp override.conf ${O}/override.conf  
done
 
cp locale.conf /etc/locale.conf
cp locale /etc/default/locale

# make sure we get fresh ssh keys on first boot
/bin/rm -f -v /etc/ssh/ssh_host_*_key*
cp regenerate_ssh_host_keys.service /etc/systemd/system
systemctl enable regenerate_ssh_host_keys

# some smf helper folders
mkdir -p /var/svc /var/db

# OS-XXXX lx boot script for redhat is looking for this file
touch /etc/rc.d/init.d/network
