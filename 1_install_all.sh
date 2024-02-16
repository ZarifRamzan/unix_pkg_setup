#!/bin/bash 

chmod 775 2_install_unix_packages.sh
./2_install_unix_packages.sh  

cp ~/.bashrc ~/.bashrc.original
meld .bashrc ~/.bashrc &

cp .vimrc ~/.
gvim ~/.vimrc -c ":PlugInstall"

chmod 775 3_install_nvim.sh
./3_install_nvim.sh 

