#!/bin/bash

set -e

BOARD_DIR="$(dirname $0)"
 
. ${BR2_EXTERNAL_LINUX_DISTRO_PATH}/scripts/common.sh
. ${BR2_EXTERNAL_LINUX_DISTRO_PATH}/scripts/fitimage.sh
 
if [ -e "${BOARD_DIR}/meta" ];then
    source_meta ${BOARD_DIR}/meta
fi

# compile kernel zboot.img
cp ${BUILD_DIR}/rockchip-rkbin-b4558da0860ca48bf1a571dd33ccba580b9abe23/tools/mkimage ${BINARIES_DIR}/
fitimage "${BINARIES_DIR}/zboot.img" "${BOARD_DIR}/boot.its" "${BINARIES_DIR}/zImage" "${BINARIES_DIR}/rv1126-ihost.dtb"

trap 'rm -rf "${ROOTPATH_TMP}"' EXIT
ROOTPATH_TMP="$(mktemp -d)"

GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

rm -rf "${GENIMAGE_TMP}"

# generate image
genimage \
	--configdump - \
	--rootpath "${ROOTPATH_TMP}"   \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${BOARD_DIR}/${GENIMAGE_CFG}"
