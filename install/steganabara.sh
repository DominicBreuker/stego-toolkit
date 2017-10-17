#!/bin/bash

set -e

# Download
wget -O /tmp/steganabara.tar.gz http://www.caesum.com/handbook/steganabara-1.1.1.tar.gz

# Extract
mkdir -p /opt/steganabara
tar -xf /tmp/steganabara.tar.gz -C /opt/steganabara
rm /tmp/steganabara.tar.gz

# Install
cat <<END > /usr/bin/steganabara
#!/bin/bash -e
java -cp /opt/steganabara/Steganabara/bin steganabara.Steganabara
END
chmod 755 /usr/bin/steganabara
