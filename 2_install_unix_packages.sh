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
sudo apt-get install aptitude -y
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get autoremove -y
sudo aptitude full-upgrade -y

# Install packages with error handling
install_package "vim" #Editor
install_package "vim-gtk3" #Editor Gui
install_package "konsole" #Konsole Terminal
install_package "git" #Version Control system (VCS)
install_package "git-gui" #VCS Gui
install_package "htop" #Reources Monitoring
install_package "meld" #Files Comparison
install_package "kdiff3" #Files Comparison
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
install_package "tree"
install_package "openssh-server"
install_package "fzf" #Fuzzy Finder
install_package "stacer" #Resorces Monitoring
install_package "x11vnc" #VNC Server

# Display errors, if any
if [ -s "$LOG_FILE" ]; then
    echo -e "\nPackages that could not be completely installed:"
    cat "$LOG_FILE"
fi
