#!/bin/bash 

export DIR=$(pwd)

cp ~/.bashrc ~/.bashrc.original
meld $DIR/bashrc ~/.bashrc &
