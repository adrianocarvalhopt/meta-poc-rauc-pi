DOLLAR = "$"

# ugly hack
FILESEXTRAPATHS:prepend := "${THISDIR}/../../../poky/meta/recipes-bsp/u-boot/files:"
FILESEXTRAPATHS:prepend := "${THISDIR}/../../../meta-raspberrypi/recipes-bsp/u-boot/files:"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:raspberrypi4 = " file://maxsize.cfg"
SRC_URI:append:qemu-raspi = " file://preboot_empty.cfg"

RPI_DISK_NUMBER ?= "0"
RPI_SCRIPT_PARTITION ?= "1"
RPI_SCRIPT_NAME ?= "boot.scr"
RPI_ENV_FILE ?= "uboot.env"

RPI_BOOTCOMMAND ?= "fatload mmc ${RPI_DISK_NUMBER}:${RPI_SCRIPT_PARTITION} ${DOLLAR}{scriptaddr} ${RPI_SCRIPT_NAME} ; source ${DOLLAR}{scriptaddr}"

EXTRA_CFGS:append = " ${UNPACKDIR}/env_fat_device_and_part.cfg"
EXTRA_CFGS:append = " ${UNPACKDIR}/env_fat_file.cfg"
EXTRA_CFGS:append = " ${UNPACKDIR}/bootcommand.cfg"

do_configure:prepend() {
    echo 'CONFIG_BOOTCOMMAND="${RPI_BOOTCOMMAND}"' \
        > ${UNPACKDIR}/bootcommand.cfg

    echo 'CONFIG_ENV_FAT_DEVICE_AND_PART="${RPI_DISK_NUMBER}:${RPI_SCRIPT_PARTITION}"' \
        > ${UNPACKDIR}/env_fat_device_and_part.cfg

    echo 'CONFIG_ENV_FAT_FILE="${RPI_ENV_FILE}"' \
        > ${UNPACKDIR}/env_fat_file.cfg
}

# Override uboot_configure_config and uboot_configure to enable dynamic generation of *.cfg files

uboot_configure_config () {
    config=$1
    type=$2

    oe_runmake -C ${S} O=${B}/${config} ${config}
    if [ -n "${@' '.join(find_cfgs(d))}" ]; then
        merge_config.sh -m -O ${B}/${config} ${B}/${config}/.config ${@" ".join(find_cfgs(d))} ${EXTRA_CFGS}
        oe_runmake -C ${S} O=${B}/${config} oldconfig
    fi
}

uboot_configure () {
    if [ -n "${UBOOT_MACHINE}" ]; then
        oe_runmake -C ${S} O=${B} ${UBOOT_MACHINE}
    else
        oe_runmake -C ${S} O=${B} oldconfig
    fi
    merge_config.sh -m .config ${@" ".join(find_cfgs(d))} ${EXTRA_CFGS}
    cml1_do_configure
}
