FILESEXTRAPATHS_PERSISTDATAPARTITION_SUFFIX = ""
FILESEXTRAPATHS_PERSISTDATAPARTITION_SUFFIX:raspi-persist-data-partition = "-persist-data-partition"
FILESEXTRAPATHS_U_BOOT_IS_UPDATABLE_SUFFIX = ""
FILESEXTRAPATHS_U_BOOT_IS_UPDATABLE_SUFFIX:raspi-u-boot-is-updatable = "-u-boot-is-updatable"

SRC_URI:remove = "file://fstab"
FILESEXTRAPATHS:prepend := "${THISDIR}/files/rpi${FILESEXTRAPATHS_PERSISTDATAPARTITION_SUFFIX}${FILESEXTRAPATHS_U_BOOT_IS_UPDATABLE_SUFFIX}:"
SRC_URI:append = " file://fstab.in"

do_configure:prepend () {
    sed -e "s/<RPI_DISK_NUMBER>/${RPI_DISK_NUMBER}/" "${UNPACKDIR}/fstab.in" > ${UNPACKDIR}/fstab
}
