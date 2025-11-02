SRC_URI:remove = "file://raspberrypi-rauc.rules"
FILESEXTRAPATHS:prepend := "${THISDIR}/files/rpi:"
SRC_URI:append = " file://raspberrypi-rauc.rules.in"

do_configure:prepend () {
    sed -e "s/<RPI_DISK_NUMBER>/${RPI_DISK_NUMBER}/" "${UNPACKDIR}/raspberrypi-rauc.rules.in" > ${UNPACKDIR}/raspberrypi-rauc.rules
}
