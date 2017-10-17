#!/bin/bash

set -e

# Download
apt-get install -y cmake \
                   libboost-all-dev

# Compile
git clone https://github.com/danielcardeenas/AudioStego.git /tmp/audio_stego
mkdir -p /tmp/audio_stego/build
cd /tmp/audio_stego/build && cmake .. && make

# Install
mv /tmp/audio_stego/build/hideme /usr/bin/hideme

# Clean up
rm -rf /tmp/audio_stego
