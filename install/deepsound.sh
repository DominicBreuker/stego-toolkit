#!/bin/bash

set -e

# Download
wget -O /tmp/deepsound.msi http://jpinsoft.net/DeepSound/Download.aspx?Download=LastVersion

# Install
cat << EOF > /usr/bin/deepsound
#!/bin/sh

DEEPSOUND_EXECUTABLE='/root/.wine/drive_c/Program Files/DeepSound 2.0/DeepSound.exe'

if [ -f "\$DEEPSOUND_EXECUTABLE" ]; then
  echo "DeepSound: installed already! Starting now..."
  echo 'IMPORTANT NOTE: MP3 currently not supported. Missing codec: https://msdn.microsoft.com/en-us/library/windows/desktop/ff819509(v=vs.85).aspx'
  wine explorer /desktop=foo,800x600 $DEEPSOUND_EXECUTABLE
else
  echo "DeepSound: not installed yet! Install now plz to default location (which is '\$DEEPSOUND_EXECUTABLE')!"
  wine msiexec /i /tmp/deepsound.msi
fi
EOF
chmod +x /usr/bin/deepsound
