#!/bin/bash

set -e

# Download
wget -O /tmp/stegdetect.deb http://old-releases.ubuntu.com/ubuntu/pool/universe/s/stegdetect/stegdetect_0.6-6_amd64.deb

# Install
dpkg -i /tmp/stegdetect.deb || apt-get install -f -y
rm /tmp/stegdetect.deb
