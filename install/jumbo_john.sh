#!/bin/bash

set -e

# Install some openssl headers
apt-get install -y libssl1.0-dev \
                   zlib1g-dev

# Download
wget -q -O /tmp/jumbo-john.tar.gz http://openwall.com/john/j/john-1.8.0-jumbo-1.tar.gz

# Extract
mkdir -p /opt/jumbo-john
tar -xzf /tmp/jumbo-john.tar.gz -C /opt/jumbo-john
rm /tmp/jumbo-john.tar.gz

# compile
# fix code with sed: https://blackcatsoftware.us/john-the-ripper-jumbo-1-8-0-compilemake-fails-in-fedora-25-gcc5/
sed -i "482s/.*/\/\/#ifdef __x86_64__/" /opt/jumbo-john/john-1.8.0-jumbo-1/src/MD5_std.c
sed -i "483s/.*/\/\/#define MAYBE_INLINE_BODY MAYBE_INLINE/" /opt/jumbo-john/john-1.8.0-jumbo-1/src/MD5_std.c
sed -i "484s/.*/\/\/#else/" /opt/jumbo-john/john-1.8.0-jumbo-1/src/MD5_std.c
sed -i "486s/.*/\/\/#endif/" /opt/jumbo-john/john-1.8.0-jumbo-1/src/MD5_std.c

cd /opt/jumbo-john/john-1.8.0-jumbo-1/src/ && ./configure && make -s clean && make -sj4 


# install
echo 'export JOHN=/opt/jumbo-john/john-1.8.0-jumbo-1/run' >> ~/.bashrc

cat << EOF > /usr/bin/john
#!/bin/sh
echo "executing john in folder '\$JOHN' - use absolute paths to avoid confusion"
cd \$JOHN
./john \$@
EOF
chmod +x /usr/bin/john
