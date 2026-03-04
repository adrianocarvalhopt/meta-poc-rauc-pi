SUMMARY = "Install K3s static manifest"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

MANIFEST_FILENAME = "some.yaml"

SRC_URI = "file://${MANIFEST_FILENAME}"

do_install() {
    install -d ${D}${localstatedir}/lib/rancher/k3s/server/manifests
    install -m 0644 ${UNPACKDIR}/${MANIFEST_FILENAME} \
        ${D}${localstatedir}/lib/rancher/k3s/server/manifests/${MANIFEST_FILENAME}
}

FILES:${PN} += "${localstatedir}/lib/rancher/k3s/server/manifests/${MANIFEST_FILENAME}"
