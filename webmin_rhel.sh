#!/bin/bash

# Function to uninstall current Webmin and related files
uninstall_webmin() {
    echo "Uninstalling Webmin and related files..."

    # Remove Webmin and its related files
    sudo dnf remove webmin -y
    sudo rm -rf /etc/webmin
    sudo rm -rf /usr/local/webmin

    # Remove the firewall rule for Webmin port (10000/tcp)
    sudo firewall-cmd --remove-port=10000/tcp --zone=public --permanent
    sudo firewall-cmd --reload

    echo "Webmin has been uninstalled and firewall rule removed."
}

# Function to install Webmin
install_webmin() {
    echo "Installing Webmin..."

    # Install expect to handle automated prompts
    if ! command -v expect &> /dev/null; then
        echo "Expect is not installed. Installing expect..."
        sudo dnf install expect -y
    fi

    # Download the Webmin setup script
    curl -o setup-repos.sh https://raw.githubusercontent.com/webmin/webmin/master/setup-repos.sh

    # Use expect to automatically reply to the prompt
    sudo expect << EOF
    spawn sudo sh setup-repos.sh
    expect "Setup Webmin stable repository? (y/N)"
    send "y\r"
    expect eof
EOF

    # Install Webmin using dnf
    sudo dnf install webmin -y
    if [ $? -ne 0 ]; then
        echo "Failed to install Webmin. Exiting."
        exit 1
    fi

    # Enable and start Webmin service
    sudo systemctl enable webmin.service
    sudo systemctl start webmin.service
    if [ $? -ne 0 ]; then
        echo "Failed to start Webmin service. Exiting."
        exit 1
    fi

    # Open the Webmin port in firewall (10000/tcp)
    sudo systemctl is-active --quiet firewalld || sudo systemctl start firewalld
    sudo firewall-cmd --add-port=10000/tcp --zone=public --permanent
    sudo firewall-cmd --reload

    echo "Webmin has been installed and firewall port 10000 is open."
}

# Uninstall Webmin first (if it exists)
uninstall_webmin

# Install Webmin after uninstalling
install_webmin

# Get the IP address of the system
IP_ADDRESS=$(hostname -I | awk '{print $1}')

echo "======================================"
echo "Webmin installation complete!"
echo "You can access Webmin at: https://$IP_ADDRESS:10000"
# Display the installed Webmin version
sleep 3  # Wait a bit for Webmin to fully start
echo "Webmin version installed: $(sudo webmin --version)"
echo "======================================"

