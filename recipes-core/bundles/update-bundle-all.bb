DESCRIPTION = "RAUC bundle generator (U-Boot N + rootfs)"

inherit bundle

RAUC_BUNDLE_COMPATIBLE = "${MACHINE}"
RAUC_BUNDLE_VERSION = "v20200703"
RAUC_BUNDLE_DESCRIPTION = "RAUC Demo Bundle (U-Boot N + rootfs)"

RAUC_BUNDLE_FORMAT = "verity"

RAUC_BUNDLE_SLOTS = "uboot rootfs"

RAUC_SLOT_uboot = "u-boot-n-image"
RAUC_SLOT_uboot[type] = "file"
RAUC_SLOT_uboot[file] = "u-boot-n-image.vfat"
RAUC_SLOT_uboot[fstype] = "vfat"

RAUC_SLOT_rootfs = "core-image-minimal"
RAUC_SLOT_rootfs[fstype] = "ext4"
