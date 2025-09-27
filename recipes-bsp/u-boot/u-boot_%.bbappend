FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:qemu-raspi = " file://preboot_empty.cfg"
SRC_URI:append:qemu-raspi4b = " file://env_fat_device_and_part_1_1.cfg"
