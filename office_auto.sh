#!/bin/bash
#this script is used to automate repetitive task. just for fun <3.
nocolour="\033[00m"
success="\033[1;32m"  #Green
warning="\033[1;33m"  #Yellow
error="\033[1;31m"    #Red
info="\033[1;34m"     #Blue
custom_color="\033[1;35m"  #Purple

#check weather script as root/ or with sudo
if [ "$EUID" -ne 0 ];
then
	echo -e "${error}Please run as root.${nocolour}"
	exit 1
fi


#Function to create a user with a specified username and password
create_user() 
{
    local username="$1"
    local password="$2"

    if id "$username" &>/dev/null; 
    then
        echo -e "${warning}User '$username' already exists. Changing password...${nocolour}"
        echo "$username:$password" | chpasswd
    else
        useradd -m -p "$password" -s /bin/bash "$username"
        echo -e "${success}User '$username' created with password '$password'.${nocolour}"
    fi
}

#Function to create ansible user 
ansible_user()
{
	# Create ansible user with sudo permissions hide user in the login screan(create system user)
	sudo useradd -r -s /bin/bash -M ansible
	echo "ansible:ansible" | sudo chpasswd
	sudo usermod -aG sudo ansible
}

# Function to update and clean system the system
update_clean() 
{
    echo -e "${custom_color}Updating and cleaning the system...${nocolour}"
    apt autoremove -y
    apt install -f 
    apt update
    apt upgrade -y
    echo -e "${info}System updated and Cleaned......${nocolour}"
    apt clean all
}

#Function to install
install_ssh() 
{
    if ! dpkg -l | grep -i -q "openssh-server"; 
    then
        echo -e "${custom_color}Installing OpenSSH Server...${nocolour}"
        apt update
        apt install openssh-server -y
        systemctl enable --now ssh
         echo -e "${success}SSH installed and enabled..${nocolour}"
    else
        echo -e "${info}OpenSSH Server is already installed and enabled.${nocolour}"
    fi
}

#Function to install Brave Browser
install_brave()
{
	if ! dpkg -l | grep -i -q "brave-browser";
	then
		echo -e "${custom_color}Installing Brave-Browser...${nocolour}"
		apt install curl -y
		curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
		echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
		apt update -y
		apt install brave-browser -y
		 echo -e "${success}Brave Browser installed and ready to browse.${nocolour}"
	else
		echo -e "${info}Brave Browser already installed. ${nocolour}"
	fi
}

#Function to install VMware Workstation
install_vmware() 
{
    if ! dpkg -l | grep -i -q "vmware-workstation"; 
    then
        echo -e "${custom_color}Installing VMware Workstation...${nocolour}"
        wget --no-check-certificate -O /tmp/workstation.bundle https://download.synnefo.in/files/workstation.bundle
        chmod +x /tmp/workstation.bundle
        bash /tmp/workstation.bundle
        rm -rf /tmp/workstation.bundle
	echo -e "${success}Vmware Workstation installed.${nocolour}"

    else
        echo -e "${info} VMware Workstation is already installed. ${nocolour}"
    fi
}


install_virtualbox() 
{
    if ! command -v virtualbox > /dev/null; 
    then
        echo -e "${custom_color}VirtualBox is installing....${nocolour}"
        apt install virtualbox -y
        echo -e "${success}VirtualBox installed.${nocolour}"
    else
        echo -e "${info}VirtualBox is already installed.${nocolour}"
    fi
}


#Function to install vim
install_vim()
{
	if ! command -v vim &> /dev/null;
	then
		echo -e "${custom_color}Vim editor is installing....${nocolour}"
		apt install vim -y
		 echo -e "${success}VIM editor installed.${nocolour}"
		else
			echo -e "${info}Vim editor is already installed. ${nocolour}"
	fi
}

install_vscode() 
{
	if ! code -v code > /dev/null;
	then
        echo -e "${custom_color}Installing Visual Studio Code.....${nocolour}"
        sudo apt-get install wget gpg -y
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
        sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
        sudo apt-get update
        sudo apt-get install code -y
	 echo -e "${success}Visual Studio Code instlled.${nocolour}"
        rm -f packages.microsoft.gpg
    else
        echo -e "${info}Visual Studio Code is already installed.${nocolour}"
    fi
}

#Function to install RustDesk
install_rustdesk() 
{
    if ! dpkg -l | grep -i -q "rustdesk"; 
    then
        echo -e "${custom_color}Installing RustDesk...${nocolour}"
        wget --no-check-certificate -O /tmp/RustDesk.deb https://download.synnefo.in/files/RustDesk.deb
        dpkg -i /tmp/RustDesk.deb
        rm -rf /tmp/RustDesk.deb
	 echo -e "${success}Rustdesk installed.${nocolour}"
    else
        echo -e "${info}RustDesk is already installed. ${nocolour}"
    fi
}

#Function to install Cisco Packet Tracer
install_packettracer() 
{
    if ! dpkg -l | grep -i -q "packettracer"; 
    then
        echo "${custom_color}Installing Cisco Packet Tracer...${nocolour}"
        wget --no-check-certificate -O /tmp/packet-tracer.deb https://download.synnefo.in/files/packet-tracer.deb
        dpkg -i /tmp/packet-tracer.deb
        rm -rf /tmp/packet-tracer.deb
	 echo -e "${success}Packettracer installed.${nocolour}"
    else
        echo -e "${info}Cisco Packet Tracer is already installed.${nocolour}"
    fi
}

#Entered into main script
echo -e "${warning}WARNING: This script can perform two actions.. ${nocolour}"
echo ""
echo "1. Full script Execution! (user creation and package installation)"
echo "2. Package installation only (no user creation)"
echo "3. Update system only..."
read -p "Enter your choice (1/2/3): " choice

if [[ $choice == "1" ]]; 
then
    # Full script (User creation, SSH installation, and package installation)
    echo -e "${warning}WARNING: This will create users and install applications/packages.. ${nocolour}"
    read -p "Do you want to proceed? (y/n): " full_choice

    if [[ $full_choice == "y" || $full_choice == "Y" ]]; 
    then
        #Create users
        create_user "administrator"
	create_user "synnefo"
        create_user "software-7am"
        create_user "software-9am"
        create_user "software-11am"
        create_user "software-2pm"
        create_user "software-4pm"

        #Add "administrator" to the sudo group
        usermod -aG sudo administrator

        #Change comments
        usermod -c "Administrator" administrator
        usermod -c "Synnefo Solutions" synnefo
        usermod -c "Software-7am" software-7am
        usermod -c "Software-9am" software-9am
        usermod -c "Software-11am" software-11am
        usermod -c "Software-2pm" software-2pm
        usermod -c "Software-4pm" software-4pm

	#Set user's password
	echo -e "${info}Setting users password. ${nocolour}"
	echo "administrator:SyN@123" | chpasswd
	echo "synnefo:asd123." | chpasswd
	echo "software-7am:sw@7" | chpasswd
	echo "software-9am:sw@9" | chpasswd
	echo "software-11am:sw@11" | chpasswd
	echo "software-2pm:sw@2" | chpasswd
	echo "software-4pm:sw@4" | chpasswd
	echo ""

        #Set root password
        echo -e "${info}Setting root password to 'root'.${nocolour}"
        echo "root:root" | chpasswd
	echo ""
	apt update 

        #install ssh
        install_ssh

        #Install VMware Workstation
        install_vmware

	#install virtaubox
	install_virtualbox

        #Install RustDesk
        install_rustdesk

        #Install Cisco Packet Tracer
        install_packettracer

	#Install Brave Browser
	install_brave
	
	#install Vscode
	install_vscode

	#install vim 
	install_vim

	#adding ansible user
	ansible_user

	#update system
	update_clean

        echo -e "${success} User creation, SSH installation, and package installation completed. ${nocolour}"
    else
        echo -e "${info}No changes were made.${nocolour}"
    fi

elif [[ $choice == "2" ]]; 
then
    echo -e "${warning}WARNING: This will install applications/packages and update system.. ${nocolour}"
    read -p "Do you want to proceed? (y/n): " y_choice

    if [[ $y_choice == "y" || $y_choice == "Y" ]];
    then
    #Install SSH, VMware Workstation, RustDesk, and Cisco Packet Tracer only (no user creation)
    apt update 
    install_ssh
    install_vmware
    install_virtualbox
    install_rustdesk
    install_packettracer
    install_brave
    install_vim
    install_vscode
    ansible_user
    update_clean
    echo -e "${success} Installation of SSH, VMware, Virtualbox, RustDesk, and Cisco Packet Tracer completed. SYSTEM UPDATED...... ${nocolour}"
else
	echo -e "${info}No changes were made.${nocolour}"
    fi

elif [[ $choice == "3" ]];
then
	#update the system
	update_clean
else
    echo -e "${error}Invalid choice. No changes were made.${nocolour}"
fi

