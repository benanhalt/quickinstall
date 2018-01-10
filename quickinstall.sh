#!/bin/bash
# Copyright 2016, jgamblin, released under the MIT License
# See https://github.com/jgamblin/quickinstall/blob/master/LICENSE for the
# complete license text
# Source code at https://github.com/jgamblin/quickinstall

echo  "\nAdding emacs ppa...\n"
add-apt-repository -y ppa:ubuntu-elisp/ppa

# Upgrade installed packages to latest
echo  "\nRunning a package upgrade...\n"
apt-get -qq update && apt-get -qq -y -o Dpkg::Options::=--force-confnew dist-upgrade


# Install stuff I use all the time
echo  "\nInstalling default packages...\n"
apt-get -qq install fail2ban git unattended-upgrades ufw emacs-snapshot

# Adjust unattended-upgrades settings
echo  "\nUnattended-Upgrade::Remove-Unused-Dependencies \"true\";\n" >> /etc/apt/apt.conf.d/50unattended-upgrades
echo  "\nUnattended-Upgrade::Automatic-Reboot \"true\";\n" >> /etc/apt/apt.conf.d/50unattended-upgrades


#Install and configure firewall
echo  "\nConfiguring firewall...\n"
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw --force enable

# set timezone to UTC
echo  "\nUpdating Timezone to UTC...\n"
sudo timedatectl set-timezone UTC

#Install Ruby
#echo  "\nInstalling Ruby...\n"
#curl -L https://get.rvm.io | bash -s stable --ruby

#PCAP Everything
#echo  "\nRunning docker: pcap...\n"
#docker run -v ~/pcap:/pcap --net=host -d jgamblin/tcpdump

echo  "\nAdding regular user...\n"
adduser --disabled-password --gecos "" ben
su -c 'mkdir -p -m700 /home/ben/.ssh && touch /home/ben/.ssh/authorized_keys' ben
cat /root/.ssh/authorized_keys >> /home/ben/.ssh/authorized_keys
