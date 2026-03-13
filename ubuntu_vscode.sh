# 1. Install code-server using the official script
curl -fsSL https://code-server.dev/install.sh | sh

# 2. Enable and start the service for your current user
sudo systemctl enable --now code-server@$USER

# 3. Wait for the config file to be generated
sleep 2

# 4. Update the config: Set password to '1234' and allow network access (0.0.0.0)
sed -i 's/^password: .*/password: 1234/' ~/.config/code-server/config.yaml
sed -i 's/127.0.0.1/0.0.0.0/g' ~/.config/code-server/config.yaml

# 5. Restart to apply the new password and network settings
sudo systemctl restart code-server@$USER

# 6. Final Summary
echo "-----------------------------------------------"
echo "INSTALLATION COMPLETE!"
echo "-----------------------------------------------"
echo "Access URL: http://$(hostname -I | awk '{print $1}'):8080"
echo "Password set to: 1234"
echo "-----------------------------------------------"
