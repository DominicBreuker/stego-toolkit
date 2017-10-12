#!/bin/bash

script="$0"
FOLDER="$(dirname $script)"

source $FOLDER/shared.sh
PROJECT_ROOT="$(abspath $FOLDER/..)"

echo "building Docker image in folder $PROJECT_ROOT"

docker build -f $PROJECT_ROOT/Dockerfile \
             -t $IMAGE_NAME \
             $PROJECT_ROOT
