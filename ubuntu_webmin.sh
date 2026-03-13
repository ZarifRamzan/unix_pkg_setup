#!/bin/bash

# Exit immediately if a command fails
set -e

echo "=== Webmin Installer for Ubuntu 24.x ==="

# Check for root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or with sudo"
  exit 1
fi

# Fetch the latest Webmin version number from GitHub releases
echo "Fetching latest Webmin version from GitHub..."
LATEST_VERSION=$(wget -qO- https://api.github.com/repos/webmin/webmin/releases/latest | jq -r .tag_name | sed 's/^v//')

if [ -z "$LATEST_VERSION" ]; then
  echo "Error: Could not fetch the latest version of Webmin. Exiting."
  exit 1
fi

echo "Latest Webmin version is: $LATEST_VERSION"

# Variables
WEBMIN_DEB="webmin_${LATEST_VERSION}_all.deb"
WEBMIN_URL="https://github.com/webmin/webmin/releases/download/${LATEST_VERSION}/${WEBMIN_DEB}"

# Cleanup any previous Webmin installations
echo "Cleaning up old Webmin installations (if any)..."
if dpkg -l | grep -q webmin; then
  echo "Removing existing Webmin installation..."
  sudo apt remove --purge -y webmin
  sudo apt autoremove -y
  sudo rm -rf /etc/webmin
  sudo rm -rf /usr/share/webmin
  sudo rm -rf /var/webmin
  sudo rm -rf /var/log/webmin
  echo "Old Webmin installation removed successfully."
else
  echo "No previous Webmin installation found."
fi

# Remove Webmin repository entry if it exists
echo "Cleaning up Webmin repository (if any)..."
if [ -f /etc/apt/sources.list.d/webmin.list ]; then
  sudo rm /etc/apt/sources.list.d/webmin.list
  echo "Removed Webmin repository entry."
else
  echo "No Webmin repository found."
fi

# Remove Webmin GPG key if it exists
echo "Removing Webmin GPG key (if any)..."
sudo rm -f /etc/apt/trusted.gpg.d/webmin.asc

# Update system
echo "Updating system..."
sudo apt update -y

# Install required dependencies
echo "Installing required dependencies..."
sudo apt install -y wget perl apt-transport-https software-properties-common jq

# Download Webmin
echo "Downloading Webmin ${LATEST_VERSION}..."
wget -q --show-progress "$WEBMIN_URL"

# Install Webmin
echo "Installing Webmin..."
sudo dpkg -i "$WEBMIN_DEB" || sudo apt --fix-broken install -y

# Enable and start Webmin service
echo "Enabling and starting Webmin..."
sudo systemctl enable webmin
sudo systemctl start webmin

# Clean up the downloaded .deb package
echo "Cleaning up..."
rm -f "$WEBMIN_DEB"

# Get the IP address of the system
IP_ADDRESS=$(hostname -I | awk '{print $1}')

echo "======================================"
echo "Webmin installation complete!"
echo "You can access Webmin at: https://$IP_ADDRESS:10000"
# Display the installed Webmin version in one line
echo "Webmin version installed: $(sudo webmin --version)"
echo "======================================"

