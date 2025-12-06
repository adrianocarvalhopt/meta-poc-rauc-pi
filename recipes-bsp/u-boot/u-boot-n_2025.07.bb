RPI_SCRIPT_NAME ?= "boot-x.scr"
RPI_ENV_FILE ?= "uboot-n.env"

require recipes-bsp/u-boot/u-boot_2025.07.bb
require u-boot-poc-rauc-pi.inc

SUMMARY = "U-Boot N"

DEPENDS:append = " u-boot-n-default-script"
PROVIDES:remove = "virtual/bootloader"

SRC_URI:append = " file://9999-ensure-the-cache-is-disabled-before-enabling-the-cache.patch"
SRC_URI:append = " file://9999-fdt-setup-disable-config-of-board-path.patch"

deltask do_install
ALLOW_EMPTY:${PN} = "1"

DEPLOY_DIR_IMAGE:append = "/${PN}"

do_deploy:append() {
    install -m 644 ${B}/u-boot.bin ${DEPLOYDIR}/u-boot.bin
}
