#!/bin/sh
echo
echo "####### Installing Ports #######"
pkg install -y git
git clone --depth 1 https://git.FreeBSD.org/ports.git /usr/ports
git -C /usr/ports pull