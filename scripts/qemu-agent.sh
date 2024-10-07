#!/bin/sh
echo "####### Installing Proxmox agent #######"
pkg install -y qemu-guest-agent
sysrc qemu_guest_agent_enable=YES
service qemu-guest-agent start
sysrc qemu_guest_agent_flags="-d -v -l /var/log/qemu-ga.log"