#!/bin/bash

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

export PATH=~/.local/bin:/app/zephyr-sdk-0.16.8/aarch64-zephyr-elf/bin:$PATH
export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
export ZEPHYR_SDK_INSTALL_DIR=/app/zephyr-sdk-0.13.1


cd /app/zephyrproject/zephyr

FINAL_DIR=/app/BUILD/final
rm -rf $FINAL_DIR
mkdir -p $FINAL_DIR/zephyr

# build sample
for i in 1 2 4 8; do
    BUILD_DIR=/app/BUILD/build-x$i
    west build -b avp64/avp64/x$i /app/project -d $BUILD_DIR -- -DSOC_ROOT=/app/config -DBOARD_ROOT=/app/config

    cp $BUILD_DIR/zephyr/zephyr.bin $FINAL_DIR/zephyr/zephyr-x$i.bin
    cp $BUILD_DIR/zephyr/zephyr.elf $FINAL_DIR/zephyr/zephyr-x$i.elf
done

# copy output
cp /app/vp_config/zephyr-x*.cfg $FINAL_DIR/
cp /app/vp_config/zephyr.cfg $FINAL_DIR/zephyr/

cd $FINAL_DIR
tar -cvzf /app/images/zephyr.tar.gz ./
