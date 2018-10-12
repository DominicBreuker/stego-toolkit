#!/bin/bash

set -e

# Download
git clone https://github.com/cedricbonhomme/Stegano.git /opt/Stegano
cd /opt/Stegano
git checkout v0.8.2

# Install
pip3 install -r /opt/Stegano/requirements.txt
cp /opt/Stegano/bin/* /opt/Stegano/

cat << EOF > /usr/bin/stegano-lsb
#!/bin/sh
python3 /opt/Stegano/stegano-lsb \$@
EOF
chmod +x /usr/bin/stegano-lsb

cat << EOF > /usr/bin/stegano-lsb-set
#!/bin/sh
python3 /opt/Stegano/stegano-lsb-set \$@
EOF
chmod +x /usr/bin/stegano-lsb-set

cat << EOF > /usr/bin/stegano-red
#!/bin/sh
python3 /opt/Stegano/stegano-red \$@
EOF
chmod +x /usr/bin/stegano-red

cat << EOF > /usr/bin/stegano-steganalysis-parity
#!/bin/sh
python3 /opt/Stegano/stegano-steganalysis-parity \$@
EOF
chmod +x /usr/bin/stegano-steganalysis-parity

cat << EOF > /usr/bin/stegano-steganalysis-statistics
#!/bin/sh
python3 /opt/Stegano/stegano-steganalysis-statistics \$@
EOF
chmod +x /usr/bin/stegano-steganalysis-statistics
