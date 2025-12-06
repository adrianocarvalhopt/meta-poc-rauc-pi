DESCRIPTION = "Generate U-Boot N partition image for RAUC"
LICENSE = "MIT"

DEPENDS += "u-boot-n dosfstools-native mtools-native"

BOOT_SIZE_MB = "100"

IMG = "${WORKDIR}/u-boot-n-image.vfat"

do_deploy() {
    dd if=/dev/zero of=${IMG} bs=1M count=${BOOT_SIZE_MB}
    mkfs.vfat -n u-boot-n ${IMG}
    mcopy -i ${IMG} -s ${DEPLOY_DIR_IMAGE}/u-boot-n/* ::/
    cp ${IMG} ${DEPLOY_DIR_IMAGE}/
}

do_deploy[depends] += "u-boot-n:do_deploy"
addtask do_deploy after do_compile
