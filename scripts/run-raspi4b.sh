#!/bin/bash
# Based on https://github.com/trinitronx/qemu-raspbian

#QEMU="oe-run-native qemu-helper-native qemu-system-aarch64"
QEMU="qemu-system-aarch64"

DEPLOY_DIR="tmp/deploy/images/raspberrypi4-64"

KERNEL_FILE="$DEPLOY_DIR/u-boot.bin"
DTB_FILE="$DEPLOY_DIR/bcm2711-rpi-4-b.dtb"

WIC_FILE="$DEPLOY_DIR/core-image-minimal-raspberrypi4-64.rootfs.wic"

# Base configuration
args=(
    # Only accelerated on native ARM64 server
    # -accel kvm
    # -cpu host
    -smp 4
    -m 2G

    # QEMU monitor listening on qga.sock in background
    # -chardev socket,id=charchannel0,path=qga.sock,server=on,wait=off
    # -mon chardev=charchannel0,id=monitor,mode=readline

    # Serial output to terminal stdout & logfile
    # -chardev stdio,id=char0,logfile=qemu-serial.log,signal=off
    # -serial chardev:char0

    # Serial output to background pseudoterminal & logged to file
    # -chardev pty,id=char0,logfile=qemu-serial.log,signal=off
    # -serial chardev:char0

    # Simple stdio/pty alternate options
    # -serial pty
    # -serial stdio
    # -monitor stdio

    # -boot order=c
    # -d guest_errors,unimp
    # -D qemu-debug.log
)

# Group 1: Machine and CPU configuration
args+=(
    # -S
    -machine raspi4b
    -kernel "$KERNEL_FILE"
    -dtb "$DTB_FILE"
    -append  "rw earlyprintk loglevel=8 console=ttyAMA1,115200 console=tty1
              coherent_pool=1M 8250.nr_uarts=0
              snd_bcm2835.enable_headphones=1 snd_bcm2835.enable_hdmi=1
              bcm2708_fb.fbwidth=720 bcm2708_fb.fbheight=480
              bcm2708_fb.fbdepth=16 bcm2708_fb.fbswap=1 vc_mem.mem_base=0x3f000000
              vc_mem.mem_size=0x3f600000 dwc_otg.lpm_enable=0
              root=/dev/mmcblk1p2 rootfstype=ext4 rootdelay=1 fsck.repair=yes
              verbosity=2 net.ifnames=0"

# Other kernel cmdline options:
# dwc2 network
#              modules-load=dwc2,g_ether
# Firstboot init script
#              init=/usr/lib/raspberrypi-sys-mods/firstboot"

#    -nographic

#    -no-user-config
#    -nodefaults
)


# Group 2: USB and input devices
args+=(
    -usb
    # -device usb-mouse
    -device usb-kbd
    # -device usb-tablet
)

# Group 3: Storage and block devices
args+=(
    -drive "if=sd,file=${WIC_FILE},format=raw,discard=unmap,detect-zeroes=unmap"
)

# Group 4: Audio configuration
#args+=(
#    -device '{"driver":"usb-audio","id":"sound0"}'
#)

# Group 5: Networking
args+=(
    # localhost forwarding
    -device usb-net,netdev=net0
    -netdev user,id=net0,hostfwd=tcp::5555-:22

    # Bridged via libvirt virbr0 (must be created manually)
    # -netdev bridge,id=net0,br=virbr0,helper=/usr/lib/qemu/qemu-bridge-helper
    # -device usb-net,netdev=net0
)

$QEMU "${args[@]}"
