#!/bin/bash

set -e

apt-get install -y xvfb winbind

# Install winetricks
wget -O /usr/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod +x /usr/bin/winetricks
xvfb-run -a winetricks --self-update

# Install dotnet framework 4.0
xvfb-run -a winetricks -q dotnet40
