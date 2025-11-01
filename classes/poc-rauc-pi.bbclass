# Gather all PoC's non-optionals and non-configurables

# Enable u-boot
RPI_USE_U_BOOT = "1"

# Enable rauc
DISTRO_FEATURES:append = " rauc"

# Machine-specific settings
RPI_DISK_NUMBER = "0"
RPI_DISK_NUMBER:qemu-raspi4b = "1"

# rpi-uboot-scr settings
RAUCSLOT_A_PARTITION:pn-rpi-u-boot-scr = "2"
RAUCSLOT_B_PARTITION:pn-rpi-u-boot-scr = "3"
RAUCSLOT_A_PARTITION:pn-rpi-u-boot-scr:raspi-u-boot-is-updatable = "5"
RAUCSLOT_B_PARTITION:pn-rpi-u-boot-scr:raspi-u-boot-is-updatable = "6"

# Settings for meta-rauc-raspberry-pi
IMAGE_INSTALL:append = " rauc"
IMAGE_FSTYPES:append = " ext4"

# Settings for the WKS file
WKS_FILE_PERSISTDATAPARTITION_SUFFIX = ""
WKS_FILE_PERSISTDATAPARTITION_SUFFIX:raspi-persist-data-partition = "-persist-data-partition"
WKS_FILE = "poc-rauc-pi-sdimage-dual-raspberrypi${WKS_FILE_PERSISTDATAPARTITION_SUFFIX}.wks.in"

# (qemu-specific) Generate an uncompressed raw image that is directly
# compatible with qemu
IMAGE_FSTYPES:append:qemu-raspi = " wic"
# (qemu-specific) qemu require an image whose size is a power of 2
POW2_PADDED_WIC_REQUIRED:qemu-raspi = "1"
inherit ${@'pow2-padded-wic' if d.getVar('POW2_PADDED_WIC_REQUIRED', True, 1) else ''}

# (qemu-specific) These modules are needed to support the USB device used by
# qemu to provide network connectivity to the guest
CORE_IMAGE_EXTRA_INSTALL:append:qemu-raspi = " kernel-module-cdc-ether"
CORE_IMAGE_EXTRA_INSTALL:append:qemu-raspi = " kernel-module-rndis-host"
