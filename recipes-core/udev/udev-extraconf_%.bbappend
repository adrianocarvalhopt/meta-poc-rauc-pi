FILESEXTRAPATHS_U_BOOT_IS_UPDATABLE_SUFFIX = ""
FILESEXTRAPATHS_U_BOOT_IS_UPDATABLE_SUFFIX:raspi-u-boot-is-updatable = "-u-boot-is-updatable"

SRC_URI:remove = "file://raspberrypi-rauc.rules"
FILESEXTRAPATHS:prepend := "${THISDIR}/files/rpi${FILESEXTRAPATHS_U_BOOT_IS_UPDATABLE_SUFFIX}:"
SRC_URI:append = " file://raspberrypi-rauc.rules.in"

do_configure:prepend () {
    sed -e "s/<RPI_DISK_NUMBER>/${RPI_DISK_NUMBER}/" "${UNPACKDIR}/raspberrypi-rauc.rules.in" > ${UNPACKDIR}/raspberrypi-rauc.rules
}
