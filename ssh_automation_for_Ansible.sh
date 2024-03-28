#!/bin/bash
#office automation - testing
#This script is designed to automate the setup and configuration of SSH on a Linux machine.

success="\033[1;32m"
#green
warning="\033[1;33m"
#yellow
error="\033[1;31m"
#red
nocolour="\033[00m"
#nocolour

#finding current user
cur_user=$(echo $SUDO_USER)
#Check if you are root or not
if [ "$EUID" -ne 0 ];
then
    echo -e  " $error Please run as root..... $nocolour ";
    exit
fi

#Create the .ssh directory if it doesn't exist
mkdir -p /root/.ssh

#Check if the known_hosts file exists, if nt create an empty file
touch /root/.ssh/known_hosts

#Function to install packages using apt
install_packages_apt()
{
    apt update
    apt install -y openssh-server sshpass
}

#Function to install packages using dnf
install_packages_dnf()
{
    dnf install -y openssh-server sshpass
}

#Check the package manager and install accordingly
if command -v apt &> /dev/null;
then
    echo "Detected APT package manager..."
    install_packages_apt
elif command -v dnf &> /dev/null;
then
    echo "Detected DNF package manager..."
    install_packages_dnf
else
    echo -e " $error Unsupported package manager. Exiting... $nocolour ";
    exit 1
fi

#Enable and start the SSH service
if command -v systemctl &> /dev/null;
then
    systemctl enable --now sshd

elif command -v service &> /dev/null;
then
    service ssh start

else
    echo -e " $error Unable to start SSH service. Exiting... $nocolour ";
    exit 1
fi

#Set root password non-interactively
echo "root:root" | chpasswd

#Update sshd_config to allow root login
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

#Restart the SSH service
if command -v systemctl &> /dev/null;
then
    systemctl restart sshd

elif command -v service &> /dev/null;
then
    service ssh restart
fi

#Retrieve and add SSH fingerprint non-interactively
ssh-keyscan -H 172.16.50.20 >> /root/.ssh/known_hosts

#Get the IP address of the machine
ip_address=$(hostname -I | awk '{print $1}')

#Create a file with the IP address
echo "hostname = $(hostname)  :  ip = $ip_address" > "/home/$cur_user/$(hostname).txt"

#Use sshpass to provide the password non-interactively and copy the file
sshpass -p "asd123." scp "/home/$cur_user/$(hostname).txt" synnefo@172.16.50.20:/home/synnefo/

echo -e  "$success Execution completed $nocolour ";
