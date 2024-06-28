#!/bin/bash

# Set the directory to the current working directory
export DIR=$(pwd)

# Install x11vnc if it's not already installed
sudo apt-get install -y x11vnc

# Create the .vnc directory if it does not exist
install -D /dev/null "$DIR/.vnc/passwd"
chmod +w "$DIR/.vnc/passwd"

# Store the password in each existing file in the .vnc directory
for file in "$DIR/.vnc/"*; 
do
    # Ensure we are dealing with a file
    if [ -f "$file" ]; then
        #!!!Change password here!!!
        echo "1234" | x11vnc -storepasswd -f "$file"
        #chmod 600 "$file"
        echo "Password has been stored in $file"
    fi
done

cp -rf $DIR/.vnc $DIR/../

echo "x11vnc password has been stored in all files within $DIR/.vnc/"
