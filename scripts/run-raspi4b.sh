#!/bin/bash

DEPLOY_DIR="tmp/deploy/images/raspberrypi4-64"

export MACHINE="raspi4b"
export MEMORY="2G"
export KERNEL_FILE="$DEPLOY_DIR/u-boot.bin"
export DTB_FILE="$DEPLOY_DIR/bcm2711-rpi-4-b.dtb"
export BOOTARGS="\
rw earlyprintk loglevel=8 console=ttyAMA1,115200 console=tty1 \
coherent_pool=1M 8250.nr_uarts=0 \
snd_bcm2835.enable_headphones=1 snd_bcm2835.enable_hdmi=1 \
bcm2708_fb.fbwidth=720 bcm2708_fb.fbheight=480 \
bcm2708_fb.fbdepth=16 bcm2708_fb.fbswap=1 vc_mem.mem_base=0x3f000000 \
vc_mem.mem_size=0x3f600000 dwc_otg.lpm_enable=0\
"

export WIC_FILE="$DEPLOY_DIR/core-image-minimal-raspberrypi4-64.rootfs.wic"

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
"$SCRIPT_DIR/run-raspi.sh"