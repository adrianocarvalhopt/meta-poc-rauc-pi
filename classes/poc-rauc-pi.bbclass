# Gather all PoC's non-optionals and non-configurables

# Machine-specific settings
RPI_DISK_NUMBER = "0"
RPI_DISK_NUMBER:qemu-raspi4b = "1"

# Enable u-boot
RPI_USE_U_BOOT = "1"

# Enable rauc
DISTRO_FEATURES:append = " rauc"

# A/B u-boot
CORE_IMAGE_EXTRA_INSTALL:append:raspi-u-boot-is-updatable = " u-boot-n"

# Settings for meta-rauc-raspberry-pi
IMAGE_INSTALL:append = " rauc"
IMAGE_FSTYPES:append = " ext4"

# Settings for the WKS file
WKS_FILE_PERSISTDATAPARTITION_SUFFIX = ""
WKS_FILE_PERSISTDATAPARTITION_SUFFIX:raspi-persist-data-partition = "-persist-data-partition"
WKS_FILE_U_BOOT_IS_UPDATABLE_SUFFIX = ""
WKS_FILE_U_BOOT_IS_UPDATABLE_SUFFIX:raspi-u-boot-is-updatable = "-u-boot-is-updatable"
WKS_FILE = "poc-rauc-pi-sdimage-dual-raspberrypi${WKS_FILE_PERSISTDATAPARTITION_SUFFIX}${WKS_FILE_U_BOOT_IS_UPDATABLE_SUFFIX}.wks.in"
RPI_EXTRA_IMAGE_BOOT_FILES:raspi-u-boot-is-updatable = "u-boot.bin;kernel8.img boot.scr boot-x.scr"
IMAGE_BOOT_FILES_u-boot-n = "${IMAGE_BOOT_FILES} u-boot-n/u-boot.bin;u-boot.bin u-boot-n/boot.scr;boot.scr"
IMAGE_BOOT_FILES_u-boot-n:remove = "bootfiles/*"
IMAGE_BOOT_FILES_u-boot-n:remove = "u-boot.bin;kernel8.img"
IMAGE_BOOT_FILES_u-boot-n:remove = "boot.scr"
IMAGE_BOOT_FILES_u-boot-n:remove = "boot-x.scr"
WICVARS:append:raspi-u-boot-is-updatable = " IMAGE_BOOT_FILES_u-boot-n"

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
