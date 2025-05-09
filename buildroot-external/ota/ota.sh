#!/bin/bash

OTA_DIR="${BR2_EXTERNAL_LINUX_DISTRO_PATH}/ota"

function fillup_rauc_system_conf() {
    if [[ ! -e ${OTA_DIR}/rauc.system.conf ]]; then
        echo "${OTA_DIR}/rauc.system.conf is not exist"
        exit 1;
    fi
    export ROOTFS_TYPE=${ROOTFS_IMAGE##*.}
    if [[ -z $ROOTFS_TYPE ]];then
        echo "ROOTFS_TYPE is empty";
        exit 1;
    fi
    mkdir -p ${TARGET_DIR}/etc/rauc/
    cp ${OTA_DIR}/rauc.system.conf ${TARGET_DIR}/etc/rauc/system.conf
     # write rootfs_type
    if [[ $ROOTFS_TYPE = "squashfs" ]];then
        sed -i "s/ROOTFS_TYPE/raw/g" ${TARGET_DIR}/etc/rauc/system.conf
    else
        sed -i "s/ROOTFS_TYPE/ext4/g" ${TARGET_DIR}/etc/rauc/system.conf
    fi
}

function install_cert() {
    if [[ ! -e ${OTA_DIR}/cert.pem ]]; then
        echo "${OTA_DIR}/cert.pem is not exist"
        exit 1;
    fi
    mkdir -p ${TARGET_DIR}/etc/rauc/
    cp ${OTA_DIR}/cert.pem ${TARGET_DIR}/etc/rauc/keyring.pem
}

function gen_bundle() {
    export RAUC_MANIFEST=$(cat ${OTA_DIR}/manifest)
    trap 'rm -rf "${ROOTPATH_TMP}"' EXIT
    ROOTPATH_TMP="$(mktemp -d)"

    GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

    rm -rf "${GENIMAGE_TMP}"

    # generate bundle
    genimage \
        --configdump - \
        --rootpath "${ROOTPATH_TMP}"   \
        --tmppath "${GENIMAGE_TMP}"    \
        --inputpath "${BINARIES_DIR}"  \
        --outputpath "${BINARIES_DIR}" \
        --config "${OTA_DIR}/bundle.cfg"
}