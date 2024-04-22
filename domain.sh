#!/bin/bash

if [[ $EUID -ne 0 ]];
then
	echo "Script must run as root !"
	exit 1;
fi

#Function to create user
create_user() 
{
    local username="$1"
    local password="$2"
    
    if id "$username" &>/dev/null; 
    then
        echo "User '$username' already exists."
    else
        # Create a new user with the provided username and set the password
        useradd -m "$username"
        echo "$username:$password" | chpasswd
        echo "User '$username' created."
    fi
}

#create website content directory and set permissions
create_website() 
{
    local domain="$1"
    local user="$2"
    local password="$3"
    local website_dir="/home/$user/public_html"
    
    #create web content and change ownership
    mkdir -p "$website_dir"
    chown -R "$user:$user" "$website_dir"
    chmod 755 "/home/$user"
    chmod 755 "$website_dir"
    
    #Create a simple index file
    echo "<html><body><h1>Welcome to $domain</h1></body></html>" > "$website_dir/index.html"
    echo "Website content directory created for '$domain' at '$website_dir'."
}

#Function to create Apache virtual host configuration
create_virtualhost() 
{
    local domain="$1"
    local user="$2"
    local website_dir="/home/$user/public_html"
    local virtualhost_conf="/etc/httpd/conf.d/$domain.conf"
    
    #Create virtual host configuration file
    cat << EOF > "$virtualhost_conf"
<VirtualHost *:80>
    ServerName $domain
    DocumentRoot $website_dir
    
    <Directory $website_dir>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>
</VirtualHost>
EOF

    #Enable virtual host
    #a2ensite "$domain.conf"
    echo "Virtual host configuration created for '$domain' at '$virtualhost_conf'."
}

read -p "Enter domain name: " domain
read -sp "Enter password for $domain: " password
echo ""
read -sp "Confirm password: " confirm_password
echo ""

if [[ "$password" != "$confirm_password" ]]; 
then
    echo "Passwords do not match. Exiting..."
    exit 1
fi

#Create a user with the domain and set password
create_user "$domain" "$password"

#Create website content directory
create_website "$domain" "$domain" "$password"

# Create Apache virtual host configuration
create_virtualhost "$domain" "$domain"

# Reload Apache to apply changes
systemctl restart httpd
echo "Website setup completed for '$domain'."

