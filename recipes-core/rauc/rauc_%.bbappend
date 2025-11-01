RPI_DATA_PARTITIONS = "4 6"
RPI_DATA_PARTITIONS:raspi-persist-data-partition = "4"

SRC_URI:remove = "file://rauc-grow-data-partition.service"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = " file://rauc-grow-data-partition.service.in"

do_configure:prepend () {
    EXECSTART=
    for p in ${RPI_DATA_PARTITIONS} ; do
        EXECSTART="$EXECSTART\nExecStart=/usr/sbin/parted --script /dev/mmcblk${RPI_DISK_NUMBER} resizepart $p 100%"
    done

    sed -e "s|@@EXECSTART@@|$EXECSTART|" "${UNPACKDIR}/rauc-grow-data-partition.service.in" > ${UNPACKDIR}/rauc-grow-data-partition.service
}
