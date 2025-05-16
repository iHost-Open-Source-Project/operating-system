#!/bin/bash

GENIMAGE_DIR="${BR2_EXTERNAL_LINUX_DISTRO_PATH}/genimage"

function gen_image() {
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
}