#!/bin/sh

set -e

wget -O /tmp/hexyl.dev https://github.com/sharkdp/hexyl/releases/download/v0.4.0/hexyl_0.4.0_amd64.deb
dpkg -i /tmp/hexyl
