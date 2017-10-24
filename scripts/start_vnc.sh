#!/bin/bash

set -e

# Get IP
VNC_IP=$(hostname -i)

# Set config
DISPLAY=:1
VNC_PORT=5901
NO_VNC_PORT=6901
VNC_RESOLUTION=1024x768
VNC_COL_DEPTH=24

# Generate random password
PASSWORD=$(openssl rand -hex 12)

mkdir -p "$HOME/.vnc"
PASSWD_PATH="$HOME/.vnc/passwd"
echo "$PASSWORD" | vncpasswd -f >> $PASSWD_PATH
chmod 600 $PASSWD_PATH

# Start vnc server
/opt/novnc/utils/launch.sh --vnc $VNC_IP:$VNC_PORT --listen $NO_VNC_PORT &
vncserver -kill $DISPLAY || rm -rfv /tmp/.X*-lock /tmp/.X11-unix || echo "remove old vnc locks to be a reattachable container"
vncserver $DISPLAY -depth $VNC_COL_DEPTH -geometry $VNC_RESOLUTION
/root/xfce_startup.sh

## Display banner
echo -e "\n\n-------------------------------------------------"
echo -e "------------------ VNC started ------------------"
echo -e "-------------------------------------------------"
echo -e "\nVNCSERVER started on DISPLAY= $DISPLAY \n\t=> connect via VNC viewer with $VNC_IP:$VNC_PORT"
echo -e "\nnoVNC HTML client started:\n\t=> connect via http://localhost:$NO_VNC_PORT/?password=$PASSWORD\n"
