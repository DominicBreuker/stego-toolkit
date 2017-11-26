#!/bin/bash

set -e

# Download
git clone https://github.com/RobinDavid/LSB-Steganography.git /opt/LSBSteg

# Install requirements
apt-get install -y python-opencv
pip install docopt

# Install
cat << EOF > /usr/bin/LSBSteg
#!/bin/sh
python2 /opt/LSBSteg/LSBSteg.py \$@
EOF
chmod +x /usr/bin/LSBSteg

