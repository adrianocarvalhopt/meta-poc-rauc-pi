RAUCSLOT_A_PARTITION ?= "2"
RAUCSLOT_B_PARTITION ?= "3"
RAUCSLOT_A_PARTITION:raspi-u-boot-is-updatable ?= "5"
RAUCSLOT_B_PARTITION:raspi-u-boot-is-updatable ?= "6"

RAUCSLOT_A_BOOTLOADER_PARTITION:raspi-u-boot-is-updatable ?= "2"
RAUCSLOT_B_BOOTLOADER_PARTITION:raspi-u-boot-is-updatable ?= "3"

SYSTEM_CONF_IN ?= "system.conf.in"
SYSTEM_CONF_IN:raspi-u-boot-is-updatable ?= "system-u-boot-is-updatable.conf.in"

SRC_URI:remove = "file://system.conf"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = " file://${SYSTEM_CONF_IN}"

do_configure:prepend () {
    sed \
        -e "s/@@RPI_DISK_NUMBER@@/${RPI_DISK_NUMBER}/" \
        -e "s/@@RAUCSLOT_A_PARTITION@@/${RAUCSLOT_A_PARTITION}/" \
        -e "s/@@RAUCSLOT_B_PARTITION@@/${RAUCSLOT_B_PARTITION}/" \
        -e "s/@@RAUCSLOT_A_BOOTLOADER_PARTITION@@/${RAUCSLOT_A_BOOTLOADER_PARTITION}/" \
        -e "s/@@RAUCSLOT_B_BOOTLOADER_PARTITION@@/${RAUCSLOT_B_BOOTLOADER_PARTITION}/" \
        "${UNPACKDIR}/${SYSTEM_CONF_IN}" > ${UNPACKDIR}/system.conf 
}
