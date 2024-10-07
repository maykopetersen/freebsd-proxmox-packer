#!/bin/sh
sed -i '' -e 's/PermitRootLogin yes/#PermitRootLogin prohibit-password/' /etc/ssh/sshd_config