#!/bin/bash

# Clean up log file
rm -f "$HOME/.unix_packages.log"

# Log file for errors
LOG_FILE="$HOME/.unix_packages.log"

# Function to install packages with error handling
install_package() {
    sudo apt-get install "$1" -y 2>> "$LOG_FILE"
    if [ $? -ne 0 ]; then
        echo "Error installing $1. Check $LOG_FILE for details."
    fi
}

# Update package information
sudo apt-get update -y
sudo apt-get upgrade -y

# Install packages with error handling
install_package "vim"
install_package "vim-gtk3"
install_package "konsole"
install_package "git"
install_package "git-gui"
install_package "htop"
install_package "meld"
install_package "wget"
install_package "zip"
install_package "ranger"
install_package "trash-cli"
install_package "autojump"
install_package "python3-dev"
install_package "python3-pip"
install_package "python3-setuptools"
install_package "nodejs"
install_package "npm"
install_package "mc"
install_package "tilix"
install_package "net-tools"
install_package "traceroute"
install_package "tightvncserver"
install_package "xrdp"
install_package "curl" 

# Display errors, if any
if [ -s "$LOG_FILE" ]; then
    echo -e "\nPackages that could not be completely installed:"
    cat "$LOG_FILE"
fi
