#!/bin/bash 

rm ~/.vimrc 
cp .vimrc ~/.
chmod 775 ~/.vimrc
gvim ~/.vimrc -c ":PlugInstall"
