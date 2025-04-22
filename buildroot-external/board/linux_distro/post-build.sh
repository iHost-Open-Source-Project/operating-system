#!/bin/bash

set -e

BOARD_DIR="$(dirname $0)"

. ${BR2_EXTERNAL_LINUX_DISTRO_PATH}/scripts/common.sh
 
if [ -e "${BOARD_DIR}/meta" ];then
    source_meta ${BOARD_DIR}/meta
fi
