#!/bin/bash

set -e

BOARD_DIR="$(dirname $0)"
 
. ${BR2_EXTERNAL_LINUX_DISTRO_PATH}/scripts/common.sh
. ${BR2_EXTERNAL_LINUX_DISTRO_PATH}/scripts/fitimage.sh
. ${BR2_EXTERNAL_LINUX_DISTRO_PATH}/genimage/genimage.sh
. ${BR2_EXTERNAL_LINUX_DISTRO_PATH}/ota/ota.sh

if [ -e "${BOARD_DIR}/meta" ];then
    source_meta ${BOARD_DIR}/meta
fi

# compile kernel zboot.img
cp ${BUILD_DIR}/rockchip-rkbin-b4558da0860ca48bf1a571dd33ccba580b9abe23/tools/mkimage ${BINARIES_DIR}/
fitimage "${BINARIES_DIR}/zboot.img" "${BOARD_DIR}/boot.its" "${BINARIES_DIR}/zImage" "${BINARIES_DIR}/rv1109-sonoff-ihost.dtb"

# # generate image
gen_image

# # generate bundle
gen_bundle