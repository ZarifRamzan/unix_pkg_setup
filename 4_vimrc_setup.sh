#!/bin/bash 

export DIR=$(pwd)

cp $DIR/vimrc ~/.
mv ~/vimrc ~/.vimrc
chmod 775 ~/.vimrc
gvim ~/.vimrc -c ":PlugInstall"
