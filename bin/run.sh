#!/bin/bash

script="$0"
FOLDER="$(dirname $script)"

source $FOLDER/shared.sh
PROJECT_ROOT="$(abspath $FOLDER/..)"

echo "Starting container now..."
docker run -it \
           --rm \
           -p 127.0.0.1:22:22 \
           -p 127.0.0.1:5901:5901 \
           -p 127.0.0.1:6901:6901 \
           -v $PROJECT_ROOT/data:/data \
           -v $PROJECT_ROOT/scripts:/opt/scripts \
           -v $PROJECT_ROOT/examples:/examples \
           -v $PROJECT_ROOT/install_dev:/install_dev \
           $IMAGE_NAME \
           /bin/bash
