#!/bin/bash

GENIMAGE_DIR="${BR2_EXTERNAL_LINUX_DISTRO_PATH}/genimage"

function gen_image() {
    # delete the image if it exists
    if [ -f "${BINARIES_DIR}/${IMAGE_NAME}.img" ]; then
        rm -f "${BINARIES_DIR}/${IMAGE_NAME}.img"
    fi
    if [ -f "${BINARIES_DIR}/${IMAGE_NAME}.img.xz" ]; then
        rm -f "${BINARIES_DIR}/${IMAGE_NAME}.img.xz"
    fi

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
        --config "${GENIMAGE_DIR}/genimage.cfg"

    # compress the image
    xz -T0 ${BINARIES_DIR}/${IMAGE_NAME}.img
}