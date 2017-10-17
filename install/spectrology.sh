#!/bin/bash

set -e

# Download
git clone https://github.com/solusipse/spectrology.git /opt/spectrology

# Install
ln -s /opt/spectrology/spectrology.py /usr/bin/spectrology
