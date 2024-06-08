#!/bin/bash 
export DIR=$(pwd)

sudo apt-get -y update
sudo apt-get -y upgrade

chmod 775 $DIR/3_bashrc_setup.sh
./3_bashrc_setup.sh 

chmod 775 $DIR/4_vimrc_setup.sh
./4_vimrc_setup.sh  

chmod 775 $DIR/7_inputrc_setup.sh
./7_inputrc_setup.sh
