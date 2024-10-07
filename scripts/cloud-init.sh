#!/bin/sh
echo
echo "####### Install Cloud-Init Package #######"
pkg install -y py311-cloud-init
sysrc cloudinit_enable="YES"