#!/bin/bash

set -e

# Download
git clone https://github.com/livz/cloacked-pixel.git /opt/cloacked_pixel

# Install requirements
pip install numpy matplotlib
apt-get install -y python-tk

# Install
cat << EOF > /usr/bin/cloackedpixel
#!/bin/sh
python2 /opt/cloacked_pixel/lsb.py \$@
EOF
chmod +x /usr/bin/cloackedpixel

cat << EOF > /usr/bin/cloackedpixel-analyse
#!/bin/sh
python2 /opt/cloacked_pixel/lsb.py analyse \$@
EOF
chmod +x /usr/bin/cloackedpixel-analyse

