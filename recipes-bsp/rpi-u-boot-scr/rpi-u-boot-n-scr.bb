PROVIDES:append = " u-boot-n-default-script"

BOOT_CMD_IN ?= "boot-n.cmd.in"

RPI_ROOTFS_PARTITION_A ?= "5"
RPI_ROOTFS_PARTITION_B ?= "6"

DEPLOY_DIR_IMAGE:append = "/u-boot-n"

require rpi-u-boot-scr_poc-rauc-pi.inc