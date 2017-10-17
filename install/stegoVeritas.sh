#!/bin/bash

set -e

# Downdload
git clone https://github.com/bannsec/stegoVeritas /opt/stegoVeritas

# Configure
sed -i 's/#!\/usr\/bin\/env python/#!\/usr\/bin\/env python3/' /opt/stegoVeritas/stegoveritas.py

# Install
ln -s /opt/stegoVeritas/stegoveritas.py /usr/bin/stegoveritas.py

# Hotfix outdir for image transforms...
sed -i 's/fileName = f.filename/fileName = os.path.splitext(os.path.basename(f.filename))[0]/' /opt/stegoVeritas/modules/image/imageFilters.py
