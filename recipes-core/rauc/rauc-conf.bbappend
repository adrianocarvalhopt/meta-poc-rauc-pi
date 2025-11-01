RAUCSLOT_A_PARTITION ?= "2"
RAUCSLOT_B_PARTITION ?= "3"

SRC_URI:remove = "file://system.conf"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = " file://system.conf.in"

do_configure:prepend () {
    sed \
        -e "s/@@RPI_DISK_NUMBER@@/${RPI_DISK_NUMBER}/" \
        -e "s/@@RAUCSLOT_A_PARTITION@@/${RAUCSLOT_A_PARTITION}/" \
        -e "s/@@RAUCSLOT_B_PARTITION@@/${RAUCSLOT_B_PARTITION}/" \
        "${UNPACKDIR}/system.conf.in" > ${UNPACKDIR}/system.conf 
}
