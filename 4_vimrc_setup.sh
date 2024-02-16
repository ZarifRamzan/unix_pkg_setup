#!/bin/bash 

rm ~/.vimrc 
cp .vimrc ~/.
gvim ~/.vimrc -c ":PlugInstall"
