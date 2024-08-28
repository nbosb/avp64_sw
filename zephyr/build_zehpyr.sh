#!/bin/bash
##############################################################################
#                                                                            #
# Copyright 2024  Nils Bosbach                                               #
#                                                                            #
# This software is licensed under the Apache license.                        #
# A copy of the license can be found in the LICENSE file at the root         #
# of the source tree.                                                        #
#                                                                            #
##############################################################################

set -euo pipefail

# Get directory of script itself
SOURCE="${BASH_SOURCE[0]}"
# resolve $SOURCE until the file is no longer a symlink
while [ -h "$SOURCE" ]; do 
    DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    # if $SOURCE was a relative symlink, we need to resolve it relative to the
    # path where the symlink file was located
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

DOCKER_EXECUTABLE="docker"
if [ "$#" -eq 1 ]; then
    DOCKER_EXECUTABLE=$1
fi

BUILD_DIR="$DIR/BUILD"
IMAGES_DIR="$DIR/../images"
CONFIG_DIR="$DIR/files/zephyr"
VP_CONFIG_DIR="$DIR/config"

mkdir -p $BUILD_DIR
mkdir -p $IMAGES_DIR

# Build image
$DOCKER_EXECUTABLE build --tag avp64_zephyr "$DIR/scripts"

$DOCKER_EXECUTABLE run \
    -v "$BUILD_DIR":/app/BUILD:Z \
    -v "$DIR/scripts/docker_entrypoint.sh":/app/docker_entrypoint.sh:ro,Z \
    -v "$CONFIG_DIR":/app/config:ro,Z \
    -v "$DIR/project":/app/project:ro,Z \
    -v "$VP_CONFIG_DIR":/app/vp_config:ro,Z \
    -v "$IMAGES_DIR":/app/images:Z \
    -t avp64_zephyr
