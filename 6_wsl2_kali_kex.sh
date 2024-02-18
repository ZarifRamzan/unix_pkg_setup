#!/bin/bash

# Check if "Kali" appears in the PRETTY_NAME field of /etc/os-release
if grep -q "Kali" /etc/os-release; then
    # If "Kali" is found, install kali-win-kex
    sudo apt update
    sudo apt install -y kali-win-kex
else
    # If "Kali" is not found, print a message
    echo "Kali Linux not detected."
fi
