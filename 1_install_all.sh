#!/bin/bash 

export DIR=$(pwd)

chmod 775 $DIR/2_install_unix_packages.sh
./2_install_unix_packages.sh  

chmod 775 $DIR/3_bashrc_setup.sh
./3_bashrc_setup.sh 

chmod 775 $DIR/4_vimrc_setup.sh
./4_vimrc_setup.sh  

chmod 775 $DIR/5_install_nvim.sh
./5_install_nvim.sh

chmod 775 $DIR/6_wsl2_kali_kex.sh
./6_wsl2_kali_kex.sh

chmod 775 $DIR/7_inputrc_setup
./7_inputrc_setup
