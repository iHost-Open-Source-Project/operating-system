#!/bin/bash

set -e

BOARD_DIR="$(dirname $0)"
 
. ${BR2_EXTERNAL_LINUX_DISTRO_PATH}/scripts/common.sh
 
if [ -e "${BOARD_DIR}/meta" ];then
    source_meta ${BOARD_DIR}/meta
fi

# copy zboot.img to BINARIES_DIR temporary
cp ${BOARD_DIR}/zboot.img ${BINARIES_DIR}/zboot.img


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
