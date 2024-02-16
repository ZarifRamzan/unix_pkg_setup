#!/bin/bash 

chmod 775 2_install_unix_packages.sh
./2_install_unix_packages.sh  

chmod 775 3_install_nvim.sh
./3_install_nvim.sh 

cd ~
cp ~/.bashrc ~/.bashrc.original
meld .bashrc ~/.bashrc &

cp .vimrc ~/.
nvim ~/.vimrc -c ":PlugInstall | :qa"

