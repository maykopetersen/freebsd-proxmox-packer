#!/bin/sh      
echo
echo "####### Installing and configuring vim #######"
pkg install -y vim
curl https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim --output /usr/local/share/vim/vim91/colors/molokai.vim
curl https://raw.githubusercontent.com/maykopetersen/utilities/main/vimrc --output /root/.vimrc
cp /root/.vimrc /usr/share/skel