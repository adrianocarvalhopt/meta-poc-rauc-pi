FILESEXTRAPATHS_PERSISTDATAPARTITION_SUFFIX = ""
FILESEXTRAPATHS_PERSISTDATAPARTITION_SUFFIX:raspi-persist-data-partition = "-persist-data-partition"

SRC_URI:remove = "file://fstab"
FILESEXTRAPATHS:prepend := "${THISDIR}/files/rpi${FILESEXTRAPATHS_PERSISTDATAPARTITION_SUFFIX}:"
SRC_URI:append = " file://fstab.in"

do_configure:prepend () {
    sed -e "s/<RPI_DISK_NUMBER>/${RPI_DISK_NUMBER}/" "${UNPACKDIR}/fstab.in" > ${UNPACKDIR}/fstab
}
