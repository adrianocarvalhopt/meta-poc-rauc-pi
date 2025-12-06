SUMMARY = "U-boot boot scripts for Raspberry Pi"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
COMPATIBLE_MACHINE = "^rpi$"

inherit kernel-arch deploy nopackages

DOLLAR = "$"

DEPENDS = "u-boot-mkimage-native"

INHIBIT_DEFAULT_DEPS = "1"

BOOT_CMD_IN ?= "boot.cmd.in"

SRC_URI_BASE ?= "file://${BOOT_CMD_IN}"
SRC_URI = "${SRC_URI_BASE}"

S = "${UNPACKDIR}"

RPI_BOOTARGS_EXTRA ?= "root=${DOLLAR}{bootpart} rauc.slot=${DOLLAR}{raucslot} rootfstype=ext4 rootdelay=1 fsck.repair=yes net.ifnames=0"
BOOTARGS ?= "fdt get value bootargs \/chosen bootargs ; setenv bootargs ${DOLLAR}{bootargs} ${RPI_BOOTARGS_EXTRA}"

KERNEL_IMAGE_PATH ?= "boot\/${KERNEL_IMAGETYPE}"
KERNEL_BOOTCMD_LINE ?= "${KERNEL_BOOTCMD} ${DOLLAR}{kernel_addr_r} - ${DOLLAR}{fdtaddr}"

BOOT_MEDIA ?= "mmc"

RPI_DISK_NUMBER ?= "0"

RAUCSLOT_A_PARTITION ?= "2"
RAUCSLOT_B_PARTITION ?= "3"

do_compile_base() {
    sed \
        -e 's/@@BOOTARGS@@/${BOOTARGS}/' \
        -e 's/@@KERNEL_IMAGE_PATH@@/${KERNEL_IMAGE_PATH}/' \
        -e 's/@@KERNEL_BOOTCMD_LINE@@/${KERNEL_BOOTCMD_LINE}/' \
        -e 's/@@BOOT_MEDIA@@/${BOOT_MEDIA}/' \
        -e 's/@@RPI_DISK_NUMBER@@/${RPI_DISK_NUMBER}/' \
        -e 's/@@RAUCSLOT_A_PARTITION@@/${RAUCSLOT_A_PARTITION}/' \
        -e 's/@@RAUCSLOT_B_PARTITION@@/${RAUCSLOT_B_PARTITION}/' \
        -e 's/@@RPI_ROOTFS_PARTITION_A@@/${RPI_ROOTFS_PARTITION_A}/' \
        -e 's/@@RPI_ROOTFS_PARTITION_B@@/${RPI_ROOTFS_PARTITION_B}/' \
        "${UNPACKDIR}/${BOOT_CMD_IN}" > "${WORKDIR}/boot.cmd"
    mkimage -A ${UBOOT_ARCH} -T script -C none -n "Boot script" -d "${WORKDIR}/boot.cmd" boot.scr
}

do_compile() {
    do_compile_base
}

do_deploy_base() {
    install -d ${DEPLOYDIR}
    install -m 0644 boot.scr ${DEPLOYDIR}
}

do_deploy() {
    do_deploy_base
}

addtask do_deploy after do_compile before do_build
