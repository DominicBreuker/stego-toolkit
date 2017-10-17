#!/bin/bash

set -e

echo "Starting socat..."
socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &
echo `ps aux | grep 'socat TCP-LISTEN:6000' | grep -v grep`
echo ""

echo "Starting Xquartz..."
open -a Xquartz
echo ""

HOST_IP=`ifconfig en0 inet | grep -v flags | cut -d ' ' -f2`
echo "run 'export DISPLAY=$HOST_IP:0' inside container"
