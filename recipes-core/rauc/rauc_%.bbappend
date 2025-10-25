PERSISTDATA_SUFFIX:raspi-persist-data-partition = "-persist-data-partition"

FILESEXTRAPATHS:prepend:rpi := "${THISDIR}/files/rpi${PERSISTDATA_SUFFIX}:"
FILESEXTRAPATHS:prepend:qemu-raspi3b := "${THISDIR}/files/qemu-raspi3b${PERSISTDATA_SUFFIX}:"
FILESEXTRAPATHS:prepend:qemu-raspi4b := "${THISDIR}/files/qemu-raspi4b${PERSISTDATA_SUFFIX}:"
