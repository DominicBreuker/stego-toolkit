#!/bin/bash

set -e

# Download
wget -O /usr/bin/jsteg https://github.com/lukechampine/jsteg/releases/download/v0.1.0/jsteg-linux-amd64
chmod +x /usr/bin/jsteg

wget -O /usr/bin/slink https://github.com/lukechampine/jsteg/releases/download/v0.2.0/slink-linux-amd64
chmod +x /usr/bin/slink
