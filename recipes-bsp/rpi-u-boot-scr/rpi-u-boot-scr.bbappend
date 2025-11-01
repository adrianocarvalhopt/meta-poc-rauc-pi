FILESEXTRAPATHS:prepend:rauc-integration:qemu-raspi := "${THISDIR}/files:"

RPI_DISK_NUMBER ?= "0"

RAUCSLOT_A_PARTITION ?= "2"
RAUCSLOT_B_PARTITION ?= "3"

DOLLAR = "$"
RPI_BOOT_ARGS:qemu-raspi = "rw earlyprintk loglevel=8 console=ttyAMA1,115200 console=tty1 coherent_pool=1M 8250.nr_uarts=0 snd_bcm2835.enable_headphones=1 snd_bcm2835.enable_hdmi=1 bcm2708_fb.fbwidth=720 bcm2708_fb.fbheight=480 bcm2708_fb.fbdepth=16 bcm2708_fb.fbswap=1 vc_mem.mem_base=0x3f000000 vc_mem.mem_size=0x3f600000 dwc_otg.lpm_enable=0 root=${DOLLAR}{bootpart} rauc.slot=${DOLLAR}{raucslot} rootfstype=ext4 rootdelay=1 fsck.repair=yes verbosity=2 net.ifnames=0"

do_compile:rauc-integration:qemu-raspi() {
    sed -e 's/@@KERNEL_IMAGETYPE@@/${KERNEL_IMAGETYPE}/' \
        -e 's/@@KERNEL_BOOTCMD@@/${KERNEL_BOOTCMD}/' \
        -e 's/@@BOOT_MEDIA@@/${BOOT_MEDIA}/' \
        -e 's/@@RPI_BOOT_ARGS@@/${RPI_BOOT_ARGS}/' \
        -e 's/@@RPI_DISK_NUMBER@@/${RPI_DISK_NUMBER}/' \
        -e 's/@@RAUCSLOT_A_PARTITION@@/${RAUCSLOT_A_PARTITION}/' \
        -e 's/@@RAUCSLOT_B_PARTITION@@/${RAUCSLOT_B_PARTITION}/' \
        "${UNPACKDIR}/boot.cmd.in" > "${WORKDIR}/boot.cmd"
    mkimage -A ${UBOOT_ARCH} -T script -C none -n "Boot script" -d "${WORKDIR}/boot.cmd" boot.scr
}
