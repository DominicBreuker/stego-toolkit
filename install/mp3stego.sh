#!/bin/bash

set -e

# Download
wget -O /tmp/mp3stego.zip http://www.petitcolas.net/fabien/software/MP3Stego_1_1_18.zip

# Extract
unzip /tmp/mp3stego.zip -d /opt/mp3stego
rm /tmp/mp3stego.zip

# Install
cat << EOF > /usr/bin/mp3stego-decode
#!/bin/sh
# move here since Decoder searches for files relative to working dir
cd /opt/mp3stego/MP3Stego_1_1_18/MP3Stego/

wine /opt/mp3stego/MP3Stego_1_1_18/MP3Stego/Decode.exe \$@

echo "WARNING: if you used relative paths, you find your results relative to \"/opt/mp3stego/MP3Stego_1_1_18/MP3Stego/\""
# TODO: write proper wrapper! tool will output files to "/opt/mp3stego/MP3Stego_1_1_18/MP3Stego/" if relative paths are used...
EOF
chmod +x /usr/bin/mp3stego-decode

cat << EOF > /usr/bin/mp3stego-encode
#!/bin/sh
wine /opt/mp3stego/MP3Stego_1_1_18/MP3Stego/Encode.exe \$@
EOF
chmod +x /usr/bin/mp3stego-encode
