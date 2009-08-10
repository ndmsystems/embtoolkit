################################################################################
# GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# Copyright(C) 2009 GAYE Abdoulaye Walsimou. All rights reserved.
#
# This program is free software; you can distribute it and/or modify it
# under the terms of the GNU General Public License
# (Version 2 or later) published by the Free Software Foundation.
#
# This program is distributed in the hope it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
################################################################################
#
# \file         rootfs.mk
# \brief	rootfs.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         June 2009
################################################################################

ifeq ($(CONFIG_EMBTK_HAVE_ROOTFS),y)

#include various filesystems targets
include $(EMBTK_ROOT)/mk/fs.mk

#host tools in order to build root filesystems: fakeroot and makedevs.
include $(EMBTK_ROOT)/mk/fakeroot.mk
include $(EMBTK_ROOT)/mk/makedevs.mk
HOSTTOOLS_COMPONENTS += makedevs_install fakeroot_install

ifeq ($(CONFIG_EMBTK_ROOTFS_HAVE_JFFS2),y)
include $(EMBTK_ROOT)/mk/lzo.mk
include $(EMBTK_ROOT)/mk/mtd-utils.mk
include $(EMBTK_ROOT)/mk/zlib.mk
HOSTTOOLS_COMPONENTS += mtd-utils_host_install
HOSTTOOLS_COMPONENTS_CLEAN += mtd-utils_host_clean
FILESYSTEMS += build_jffs2_rootfs
endif

rootfs_build: rootfs_clean mkinitialpath $(HOSTTOOLS_COMPONENTS) \
$(ROOTFS_COMPONENTS) rootfs_fill build_tarbz2_rootfs $(FILESYSTEMS)

rootfs_fill:
ifeq ($(CONFIG_EMBTK_TARGET_ARCH_64BITS),y)
	@mkdir -p $(ROOTFS)/lib64
	@mkdir -p $(ROOTFS)/usr/lib64
	@rm -rf $(ROOTFS)/lib $(ROOTFS)/usr/lib
	@cp -R $(SYSROOT)/lib64/* $(ROOTFS)/lib64/
	@-$(TARGETSTRIP)  $(ROOTFS)/lib64/*.so
	@cp -R $(SYSROOT)/usr/bin/* $(ROOTFS)/usr/bin/
	@-$(TARGETSTRIP)  $(ROOTFS)/usr/bin/*
	@cp -R $(SYSROOT)/usr/sbin/* $(ROOTFS)/usr/sbin/
	@$(TARGETSTRIP)  $(ROOTFS)/usr/sbin/*
else
	@mkdir -p $(ROOTFS)/lib
	@cp -R $(SYSROOT)/lib/* $(ROOTFS)/lib/
	@-$(TARGETSTRIP)  $(ROOTFS)/lib/*.so
	@cp -R $(SYSROOT)/usr/bin/* $(ROOTFS)/usr/bin/
	@-$(TARGETSTRIP)  $(ROOTFS)/usr/bin/*
	@cp -R $(SYSROOT)/usr/sbin/* $(ROOTFS)/usr/sbin/
	@-$(TARGETSTRIP)  $(ROOTFS)/usr/sbin/*
endif

rootfs_clean: $(HOSTTOOLS_COMPONENTS_CLEAN) $(ROOTFS_COMPONENTS_CLEAN)
	@rm -rf rootfs-*

else
rootfs_build:
	@echo "############### Root filesystem build not selected #############"
	@echo "# Root filesystem build not selected in the configuration      #"
	@echo "# interface. If you want to build one please select it.        #"
	@echo "################################################################"
rootfs_clean: $(HOSTTOOLS_COMPONENTS_CLEAN)

endif
