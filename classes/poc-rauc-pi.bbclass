# Gather all PoC's non-optionals and non-configurables

# Enable u-boot
RPI_USE_U_BOOT = "1"

# Enable rauc
DISTRO_FEATURES:append = " rauc"

# Settings for meta-rauc-raspberry-pi
IMAGE_INSTALL:append = " rauc"
IMAGE_FSTYPES:append = " ext4"
WKS_FILE = "sdimage-dual-raspberrypi.wks.in"
WKS_FILE:qemu-raspi3b = "qemu-raspbi3b-sdimage-dual-raspberrypi.wks.in"
WKS_FILE:qemu-raspi4b = "qemu-raspbi4b-sdimage-dual-raspberrypi.wks.in"

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
