#!/bin/bash

script="$0"
FOLDER="$(dirname $script)"

source $FOLDER/shared.sh
PROJECT_ROOT="$(abspath $FOLDER/..)"

echo "pushing image"
docker run -it \
           --rm \
           -v $PROJECT_ROOT/data:/data \
           -v $PROJECT_ROOT/scripts:/opt/scripts \
           -v $PROJECT_ROOT/examples:/examples \
           $IMAGE_NAME \
           /bin/bash
