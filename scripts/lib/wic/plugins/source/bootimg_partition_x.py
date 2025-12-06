#
# Copyright OpenEmbedded Contributors
#
# SPDX-License-Identifier: GPL-2.0-only
#
# DESCRIPTION
# This implements the 'bootimg_partition' source plugin class for
# 'wic'. The plugin creates an image of boot partition, copying over
# files listed in IMAGE_BOOT_FILES bitbake variable.
#
# AUTHORS
# Maciej Borzecki <maciej.borzecki (at] open-rnd.pl>
#

import logging

from wic.plugins.source.bootimg_partition import BootimgPartitionPlugin

logger = logging.getLogger('wic')

class BootimgPartitionXPlugin(BootimgPartitionPlugin):
    """
    Create an image of boot partition, copying over files
    listed in IMAGE_BOOT_FILES_<slot> bitbake variable.
    """

    name = 'bootimg_partition_x'

    @classmethod
    def do_configure_partition(cls, part, source_params, cr, cr_workdir,
                             oe_builddir, bootimg_dir, kernel_dir,
                             native_sysroot):
        image_boot_files_var_name_ = cls.image_boot_files_var_name
        cls.image_boot_files_var_name += f"_{source_params['slot']}"
        logger.debug(f"{cls.image_boot_files_var_name}")
        super().do_configure_partition(part, source_params, cr, cr_workdir, oe_builddir, bootimg_dir, kernel_dir, native_sysroot)
        cls.image_boot_files_var_name = image_boot_files_var_name_


    @classmethod
    def do_prepare_partition(cls, part, source_params, cr, cr_workdir,
                             oe_builddir, bootimg_dir, kernel_dir,
                             rootfs_dir, native_sysroot):
        image_boot_files_var_name_ = cls.image_boot_files_var_name
        cls.image_boot_files_var_name += f"_{source_params['slot']}"
        logger.debug(f"{cls.image_boot_files_var_name}")
        super().do_prepare_partition(part, source_params, cr, cr_workdir, oe_builddir, bootimg_dir, kernel_dir, rootfs_dir, native_sysroot)
        cls.image_boot_files_var_name = image_boot_files_var_name_
