#!/bin/bash

#Prompt the user to enter the username
read -p "Enter the username whose home directory you want to backup: " input_username

#Check if the user exists
if id "$input_username" &>/dev/null; 
then
    #Define the user's home directory
    user_home=$(eval echo "~$input_username")

    #Define the backup directory
    backup_dir="/backup"

    #Create the backup directory if it doesn't exist
    mkdir -p "$backup_dir"

    #Generate timestamp
    timestamp=$(date +"%Y%m%d_%H%M%S")

    #Define backup filename with timestamp
    backup_filename="${input_username}_backup_${timestamp}.tar.gz"

    #Create a tarball of the user's home directory
    tar -czf "${backup_dir}/${backup_filename}" "$user_home"

    #Check if the backup was successful
    if [ $? -eq 0 ]; 
    then
        echo "Backup of $user_home completed successfully. Backup saved as $backup_filename in $backup_dir."
    else
        echo "Backup failed!"
    fi
else
    echo "User '$input_username' does not exist."
fi