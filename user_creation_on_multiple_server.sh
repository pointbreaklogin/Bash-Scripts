#!/bin/bash

#automating user creation with bash script
#must enable ssh key based login 
#create a text file that includes all the server IP addresses where you wish to add the user on.

servers=$(cat /home/synnefo/server_ip.txt)
#server_ip.txt file contain all the remote server ip address
echo "Enter the name of the new user:"
read user
echo "Enter the user id for new user: "
read uid

for i in $servers ;
do
        echo $i
        ssh $i "sudo useradd -m -u $uid $user"
        #automate the password entry using sshpass
        #sshpass -p 'your_server_pass' ssh $i "useradd -m -u $userid $user"
        if [ $? -eq 0 ];
        then
                echo "User $user added on $i"
        else
                echo "Error on $i"
        fi
done
