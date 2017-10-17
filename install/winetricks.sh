#!/bin/bash

set -e

apt-get install -y xvfb

# Install winetricks
wget -O /usr/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod +x /usr/bin/winetricks
xvfb-run -a winetricks --self-update

# Install dotnet framework 4.6.1
xvfb-run -a winetricks -q dotnet461
