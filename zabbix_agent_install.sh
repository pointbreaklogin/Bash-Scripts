#!/bin/bash
# Zabbix agent installation script for Debian/Ubuntu/Mint

# Check which package manager is installed
zabbixip='172.16.50.50'
if command -v apt-get >/dev/null 2>&1; 
then
    pkg="apt-get"
elif command -v dnf >/dev/null 2>&1; 
then
    pkg="dnf"
elif command -v pacman >/dev/null 2>&1; 
then
    pkg="pacman"
else
    echo "Error: No supported package manager found"
    exit 1
fi

# Check if the user is root or not
if [ "$(id -u)" != "0" ]; 
then
    echo "Error: This script must be run as root"
    exit 1
fi

# Install Zabbix agent using the appropriate package manager
if [ "$pkg" = "apt-get" ]; 
then
	echo "Installing Zabbix agent using apt-get"
	if ! $pkg update -y; 
	then
		echo "Error: apt-get update failed"
		exit 1
	fi
	if ! $pkg upgrade -y; 
	then
		echo "Error: apt-get upgrade failed"
		exit 1
	fi
	if ! $pkg install zabbix-agent -y; 
	then
		echo "Error: apt-get install failed"
		exit 1
	fi
	config_file="/etc/zabbix/zabbix_agentd.conf"
elif [ "$pkg" = "pacman" ]; 
then
	echo "Installing Zabbix agent using pacman"
	if ! $pkg -Syu; 
	then
		echo "Error: pacman -Syu failed"
		exit 1
    fi
    if ! $pkg -Syy; 
    then
	    echo "Error: pacman -Syy failed"
	    exit 1
    fi
    if ! $pkg -Syu zabbix-agent --noconfirm; 
    then
	    echo "Error: pacman -Syu zabbix-agent failed"
	    exit 1
    fi
    config_file="/etc/zabbix/zabbix_agentd.conf"
elif [ "$pkg" = "dnf" ]; 
then
	echo "Installing Zabbix agent using dnf"
    if ! $pkg update -y; 
    then
	    echo "Error: dnf update failed"
	    exit 1
    fi
    if ! $pkg upgrade -y; 
    then
	    echo "Error: dnf upgrade failed"
	    exit 1
    fi
    if ! $pkg install zabbix-agent -y; 
    then
	    echo "Error: dnf install failed"
	    exit 1
    fi
    config_file="/etc/zabbix_agentd.conf"
else
	echo "Error: Unsupported package manager"
	exit 1
fi


# Update the Zabbix agent configuration file with the server IP address
sed -i "s/Server=127.0.0.1/Server=$zabbixip/" "$config_file"

# Restart the Zabbix agent service to apply the configuration changes
systemctl enable --now zabbix-agent
systemctl restart zabbix-agent

echo "_______________________________________________________________________________________________"
echo "_______________________________________________________________________________________________"

echo "Zabbix agent installation and configuration complete ! "
