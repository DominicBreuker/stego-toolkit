#!/bin/bash

set -e

# enable i386 arch (required for 32bit windows)
dpkg --add-architecture i386 && apt-get update

# Install wine
apt-get install -y \
        wine \
        wine32 \
        wine64 \
        libwine \
        libwine:i386 \
        fonts-wine

# Configure 32 bit wineprefix (avoid bugs they say - breaks 64 bit only programs...)
WINEARCH=win32 WINEPREFIX=/root/.wine winecfg

# Download and install notepad++ (32 bit / 64 bit) for testing
wget -O /tmp/notepad32.7z https://notepad-plus-plus.org/repository/7.x/7.5.1/npp.7.5.1.bin.7z
wget -O /tmp/notepad64.7z https://notepad-plus-plus.org/repository/7.x/7.5.1/npp.7.5.1.bin.x64.7z
7z e -o/opt/notepad32 /tmp/notepad32.7z
7z e -o/opt/notepad64 /tmp/notepad64.7z
rm /tmp/notepad32.7z
rm /tmp/notepad64.7z

cat << EOF > /usr/bin/notepad++32
#!/bin/sh
wine /opt/notepad32/notepad++.exe \$@
EOF
chmod +x /usr/bin/notepad++32

cat << EOF > /usr/bin/notepad++64
#!/bin/sh
wine /opt/notepad64/notepad++.exe \$@
EOF
chmod +x /usr/bin/notepad++64
