FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:qemu-raspi4b = " file://0001-arm-dts-enable-usb-7e980000-by-default.patch"

CMDLINE:remove:rauc-integration:qemu-raspi3b = "root=/dev/mmcblk0p2"
CMDLINE:remove:rauc-integration:qemu-raspi4b = "root=/dev/mmcblk1p2"
