#!/bin/bash 

rm ~/.vimrc
cp ~/unix_pkg_setup/vimrc ~/.
mv ~/unix_pkg_setup/vimrc ~/unix_pkg_setup/.vimrc 
chmod 775 ~/.vimrc
gvim ~/.vimrc -c ":PlugInstall"
