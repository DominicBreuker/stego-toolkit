#!/bin/bash

set -e

# Download
wget -O /tmp/openpuff.zip http://embeddedsw.net/zip/OpenPuff_release.zip
unzip /tmp/openpuff.zip -d /opt/openpuff
rm /tmp/openpuff.zip

# Install
cat << EOF > /usr/bin/openpuff
#!/bin/sh
wine /opt/openpuff/OpenPuff_release/OpenPuff.exe \$@
EOF
chmod +x /usr/bin/openpuff
