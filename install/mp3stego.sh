#!/bin/bash

set -e

# Download
wget -O /tmp/mp3stego.zip http://www.petitcolas.net/fabien/software/MP3Stego_1_1_18.zip

# Extract
unzip /tmp/mp3stego.zip -d /opt/mp3stego

# Install
cat << EOF > /usr/bin/mp3stego-decode
#!/bin/sh
wine /opt/mp3stego/MP3Stego_1_1_18/MP3Stego/Decode.exe \$@
EOF
chmod +x /usr/bin/mp3stego-decode

cat << EOF > /usr/bin/mp3stego-encode
#!/bin/sh
wine /opt/mp3stego/MP3Stego_1_1_18/MP3Stego/Encode.exe \$@
EOF
chmod +x /usr/bin/mp3stego-encode
