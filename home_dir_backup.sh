#!/bin/bash

#Promot the user to enter the user to enter the user name
read -p "Enter the user name whose home directory you want to backup: " input_username

#check the user exists
if id "$input_username" &> /dev/null;
then
user_home=$(eval echo "~$input_username")

#define the backupdir
backup_dir="/backup_home_dir"

#create the backup dir
mkdir -p "$backup_dir"

#generate time stamp
timestamp=$(date +"%Y%m%d_%H%M%S")

#define backup file name with time stamp
backup_filename="backup_${timestamp}.tar.gz"

#create tar for user home directory
tar -czf "${backup_dir}/${backup_filename}" "$user_home"

#check the backup is successful
if [ $? -eq 0 ];
then
echo "Backup of $user_home" completed successfully. Backup saved as $backup_filename in $backup_dir. "
else
echo "Backup Failed !"
fi

else 
echo "User '$input_username' does not exist."
fi