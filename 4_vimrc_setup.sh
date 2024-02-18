#!/bin/bash 

cp ~/unix_pkg_setup/vimrc ~/.
mv ~/vimrc ~/.vimrc
chmod 775 ~/.vimrc
gvim ~/.vimrc -c ":PlugInstall"
