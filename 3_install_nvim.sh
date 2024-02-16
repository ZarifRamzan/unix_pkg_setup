# Install Neovim from githubi
sudo rm /usr/bin/nvim 
cd ~
wget https://github.com/neovim/neovim/releases/download/v0.9.5/nvim.appimage
chmod +x nvim.appimage
mv nvim.appimage nvim
sudo cp nvim /usr/bin/
rm ~/nvim

# Setup Personalised Dev Env
rm -rf ~/.config/nvim
mkdir -p ~/.config/nvim
cd ~/.config/nvim
#wget https://raw.githubusercontent.com/nvim-lua/kickstart.nvim/master/init.lua
cp init.lua ~/.config/nvim/.
/usr/bin/nvim
