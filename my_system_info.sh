#!/bin/bash

#Get the current user and full name
username=$(whoami)
full_name=$(getent passwd "$username" | cut -d ':' -f5 | cut -d ',' -f1)

#Get system information
hostname=$(hostname)
cpu_model=$(lscpu | grep 'Model name' | sed 's/Model name:[ \t]*//')
cpu_cores=$(nproc)
memory=$(free -m | awk '/^Mem:/{print $2}')
os=$(lsb_release -d | cut -f2)
storage=$(df -h / | awk 'NR==2 {print $2}')
uptime=$(uptime -p | cut -d ' ' -f2-)
users=$(who | wc -l)
disk_used=$(df -h / | awk 'NR==2 {print $3}')
ip_address=$(hostname -I | awk '{print $1}')

#Output the report
echo ""
echo "System Information Report"
echo "========================="
printf "1. %-17s %s\n" "My Name:" "$full_name"
printf "2. %-17s %s\n" "System Name:" "$hostname"
printf "3. %-17s %s\n" "CPU Info:" "$cpu_model"
printf "   %-17s %s\n" "" "Total CPUs: $cpu_cores"
printf "4. %-17s %s MB\n" "Memory:" "$memory"
printf "5. %-17s %s\n" "OS:" "$os"
printf "6. %-17s %s\n" "Storage:" "$storage"
printf "7. %-17s %s\n" "Uptime:" "$uptime"
printf "8. %-17s %s\n" "Logged-in Users:" "$users"
printf "9. %-17s %s used\n" "Disk Usage:" "$disk_used"
printf "10. %-16s %s\n" "Network:" "$ip_address"
echo "11. Top Processes:"
printf "    %-6s %-15s %s\n" "PID" "COMMAND" "%CPU"
ps -eo pid,comm,%cpu --sort=-%cpu | awk 'NR>1 && NR<=6 {printf "    %-6s %-15s %s\n", $1, $2, $3}'

