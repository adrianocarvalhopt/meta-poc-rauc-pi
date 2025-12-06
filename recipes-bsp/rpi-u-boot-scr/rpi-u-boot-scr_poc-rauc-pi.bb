PROVIDES += "u-boot-default-script"

SRC_URI:raspi-u-boot-is-updatable = "${SRC_URI_BASE} file://boot-x.cmd.in"

BOOTARGS:raspi-u-boot-is-updatable ?= ""

KERNEL_IMAGE_PATH:raspi-u-boot-is-updatable ?= "u-boot.bin"
KERNEL_BOOTCMD_LINE:raspi-u-boot-is-updatable ?= "setexpr forward_fdtaddr ${fileaddr} + ${filesize} ; fdt move ${fdtaddr} ${forward_fdtaddr} ; fdt resize 1 ; fdt set \/ raucslot ${raucslot} ; go ${DOLLAR}{kernel_addr_r}"

do_compile:raspi-u-boot-is-updatable:append() {
    do_compile_base
    sed \
        -e 's/@@BOOT_MEDIA@@/${BOOT_MEDIA}/' \
        -e 's/@@RPI_DISK_NUMBER@@/${RPI_DISK_NUMBER}/' \
        -e 's/@@RAUCSLOT_A_PARTITION@@/${RAUCSLOT_A_PARTITION}/' \
        -e 's/@@RAUCSLOT_B_PARTITION@@/${RAUCSLOT_B_PARTITION}/' \
        "${UNPACKDIR}/boot-x.cmd.in" > "${WORKDIR}/boot-x.cmd"
    mkimage -A ${UBOOT_ARCH} -T script -C none -n "Boot script" -d "${WORKDIR}/boot-x.cmd" boot-x.scr
}

do_deploy:raspi-u-boot-is-updatable:append() {
    do_deploy_base
    install -d ${DEPLOYDIR}
    install -m 0644 boot-x.scr ${DEPLOYDIR}
}

require rpi-u-boot-scr_poc-rauc-pi.inc