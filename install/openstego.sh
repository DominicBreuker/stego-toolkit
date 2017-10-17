#!/bin/bash

set -e

# Download
wget -O /tmp/openstego.deb https://github.com/syvaidya/openstego/releases/download/openstego-0.7.1/openstego_0.7.1-1_amd64.deb

# Install
dpkg -i /tmp/openstego.deb || apt-get install -f -y
rm /tmp/openstego.deb

cat << EOF > /usr/bin/openstego
#!/bin/sh
java -jar /usr/share/openstego/lib/openstego.jar \$@
EOF
chmod +x /usr/bin/openstego
