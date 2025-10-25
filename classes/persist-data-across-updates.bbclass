ROOTFS_POSTPROCESS_COMMAND += "persistant_data_across_updates_setup;"

PERSISTDATADIR = "/data"
PERSISTDATASOURCEDIR = "${IMAGE_ROOTFS}"
PERSISTDATADEPLOYDIR = "${DEPLOY_DIR_IMAGE}/data-tree"

PERSISTDATA_dirs555 ?= ""
PERSISTDATA_files444 ?= ""

persistant_data_across_updates_setup() {
    # clean previous setup.
    rm -rf "${PERSISTDATADEPLOYDIR}"

    # setup.
    mkdir -p "${PERSISTDATADEPLOYDIR}"

	for d in ${PERSISTDATA_dirs555}; do
        install -d "$(dirname "${PERSISTDATADEPLOYDIR}$d")"
        if [ -e "${PERSISTDATASOURCEDIR}$d" ] ; then
            mv "${PERSISTDATASOURCEDIR}$d" "${PERSISTDATADEPLOYDIR}$d"
            chmod 0555 "${PERSISTDATADEPLOYDIR}$d"
        else
		    install -m 0555 -d "${PERSISTDATADEPLOYDIR}$d"
        fi

        install -d "$(dirname "${PERSISTDATASOURCEDIR}$d")"
        ln -sf "${PERSISTDATADIR}$d" "${PERSISTDATASOURCEDIR}$d"
	done

	for d in ${PERSISTDATA_files444}; do
        install -d "$(dirname "${PERSISTDATADEPLOYDIR}$d")"
        mv "${PERSISTDATASOURCEDIR}$d" "${PERSISTDATADEPLOYDIR}$d"
        chmod 0444 "${PERSISTDATADEPLOYDIR}$d"

        install -d "$(dirname "${PERSISTDATASOURCEDIR}$d")"
        ln -sf "${PERSISTDATADIR}$d" "${PERSISTDATASOURCEDIR}$d"
	done
}
