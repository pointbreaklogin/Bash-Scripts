#!/bin/bash

#function to display error message and exit with non zero status

die()
{
    echo "$*" >&2
    exit 1
}

#dir backup function
p_backup()
{
    local source_dir="$1"
    local destination_dir="$2"
    local retention_days="$3"

    #validate source directory
    [ -d "$source_dir" ] || die "Error: Source directory '$source_dir' not found or invalid."

    #create timestamp
    backup_timestamp=$(date +"%Y%m%d_%H%M")
    backup_dir="$destination_dir/backup_$backup_timestamp"

    #create backup directory
    mkdir -p "$backup_dir" || die "Error: Failed to create backup directory '$backup_dir'."

    #perform backup using tar with gzip compression
     tar czf "$backup_dir/backup.tar.gz" "$source_dir" || die "Error: Backup process failed."

    #Cleanup old backups older than retention period
     find "$destination_dir" -type d -name "backup_*" -mtime +$retention_days -exec rm -rf {} \;

     echo "Backup completed successfully. Backup directory: $backup_dir"
}

# Main script

#Prompt user for input
read -p "Enter source directory to backup: " source_directory
read -p "Enter destination directory for backups: " destination_directory
read -p "Enter retention period (in days) for old backups: " retention_period

# Validate retention period is a positive integer
if ! [[ "$retention_period" =~ ^[1-9][0-9]*$ ]]; 
then
    die "Error: Retention period must be a positive integer."
fi

# Perform backup with specified parameters
p_backup "$source_directory" "$destination_directory" "$retention_period"