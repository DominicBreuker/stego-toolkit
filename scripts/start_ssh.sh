#!/bin/bash

set -e

PASSWORD=$(openssl rand -hex 12)

echo "Changing root password to ${PASSWORD}"
echo "root:${PASSWORD}" | chpasswd

echo "Starting ssh server"
service ssh start

## Display banner
echo -e "\n\n-------------------------------------------------"
echo -e "------------------ SSH started ------------------"
echo -e "-------------------------------------------------"
echo -e "\nSSH server started and ready for X11 forwarding:"
echo -e "\t=> connect via 'ssh -X -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@localhost'"
echo -e "\t=> Password is: '${PASSWORD}'\n"
