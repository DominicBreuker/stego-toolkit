#!/bin/bash

set -e

wget -O /opt/Stegsolve.jar http://www.caesum.com/handbook/Stegsolve.jar

cat << EOF > /usr/bin/stegsolve
#!/bin/sh
java -jar /opt/Stegsolve.jar \$@
EOF
chmod +x /usr/bin/stegsolve
