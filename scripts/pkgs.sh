#!/bin/sh      
echo
echo "####### Installing other packages and configuring them #######"
set -- bash bash-completion bash-completion-freebsd curl python3 sudo
for package in "$@"
do	
    echo
    echo "####### Installing $package #######"
    pkg install -y "$package"
done