#!/bin/sh

set -e

mkdir -p /opt/f5

# F5 algorithm in Python
git clone https://github.com/jackfengji/f5-steganography.git /opt/f5/python
ln -s /opt/f5/python/utity.py /usr/local/bin/f5
# Usage:
# f5 -t e -i cover.jpg -o stego.jpg -d 'secret message'
# f5 -t x -i stego.jpg 1> secret.txt


# F5 alogrithm in Java TODO inserted as example, only python version works
#git clone https://github.com/matthewgao/F5-steganography.git /opt/f5/java
# Usage:
# cd /opt/f5/java && java -Djava.awt.headless=true Embed -e secret.txt cover.jpg stego.jpg

