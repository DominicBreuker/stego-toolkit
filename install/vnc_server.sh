#!/bin/bash

set -e

# Install xfce desktop
apt-get install -y --no-install-recommends keyboard-configuration
apt-get install -y xfce4 xterm
apt-get purge -y pm-utils xscreensaver*

# Install tigervnc
wget -qO- https://dl.bintray.com/tigervnc/stable/tigervnc-1.8.0.x86_64.tar.gz | tar xz --strip 1 -C /


# Install noVNC
mkdir -p /opt/novnc/utils/websockify
wget -qO- https://github.com/kanaka/noVNC/archive/v0.6.1.tar.gz | tar xz --strip 1 -C /opt/novnc
wget -qO- https://github.com/kanaka/websockify/archive/v0.8.0.tar.gz | tar xz --strip 1 -C /opt/novnc/utils/websockify
chmod +x -v /opt/novnc/utils/*.sh
## create index.html to forward automatically to `vnc_auto.html`
ln -s /opt/novnc/vnc_auto.html /opt/novnc/index.html

cat << EOF > /root/xfce_startup.sh
#!/usr/bin/env bash

set -e

echo -e "\n------------------ startup of Xfce4 window manager ------------------"

### disable screensaver and power management
xset -dpms &
xset s noblank &
xset s off &

/usr/bin/startxfce4 --replace > $HOME/wm.log &
sleep 1
cat $HOME/wm.log
EOF
chmod +x /root/xfce_startup.sh
