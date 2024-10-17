#!/bin/bash

#check weather script as root/ or with sudo
if [ "$EUID" -ne 0 ];
then
	echo -e "${error}Please run as root.${nocolour}"
	exit 1
fi

#Set variables
SOURCE="/home/abhiram"
DESTINATION="/user_home_backups"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_NAME="backup_abhiram_$TIMESTAMP.tar.gz"

check_install_pv() {
    if ! command -v pv &> /dev/null; then
        echo "pv is not installed. Installing now..."
        sudo apt-get update
        sudo apt-get install -y pv
    else
        echo "pv is already installed."
    fi
}

check_install_pv


#Create the backup and show progress
echo "Starting backup of $SOURCE to $DESTINATION/$BACKUP_NAME..."
tar --exclude="$SOURCE/.cache" --exclude="$SOURCE/.config" -czf - -C "$SOURCE" . | pv -s $(du -sb "$SOURCE" | awk '{print $1}') > "$DESTINATION/$BACKUP_NAME"

#Remove backups older than 3 days
find "$DESTINATION" -type f -name "backup_abhiram_*.tar.gz" -mtime +3 -exec rm {} \;

#Completion message
echo "Backup completed successfully! File: $DESTINATION/$BACKUP_NAME"

