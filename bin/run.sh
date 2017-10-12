#!/bin/bash

script="$0"
FOLDER="$(dirname $script)"

source $FOLDER/shared.sh
PROJECT_ROOT="$(abspath $FOLDER/..)"

echo "pushing image"
docker run -it \
           --rm \
           -v $PROJECT_ROOT/data:/data \
           $IMAGE_NAME \
           /bin/bash
