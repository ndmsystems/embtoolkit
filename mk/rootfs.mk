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
include $(EMBTK_ROOT)/mk/pkgconfig.mk
ROOTFS_HOSTTOOLS += makedevs_install fakeroot_install pkgconfig_install

#Does CPIO archive for initramfs selected?
ifeq ($(CONFIG_EMBTK_ROOTFS_HAVE_INITRAMFS_CPIO),y)
FILESYSTEMS += build_initramfs_archive
endif

#Does jffs2 filesystem selected?
ifeq ($(CONFIG_EMBTK_ROOTFS_HAVE_JFFS2),y)
ROOTFS_HOSTTOOLS += mtd-utils_host_install
ROOTFS_HOSTTOOLS_CLEAN += mtd-utils_host_clean
FILESYSTEMS += build_jffs2_rootfs
endif

#Does squashfs filesystem selected?
ifeq ($(CONFIG_EMBTK_ROOTFS_HAVE_SQUASHFS),y)
include $(EMBTK_ROOT)/mk/squashfs.mk
ROOTFS_HOSTTOOLS += squashfs_host_install
FILESYSTEMS += build_squashfs_rootfs
endif

rootfs_build:
	$(call EMBTK_GENERIC_MESSAGE,"Building selected root filesystems...")
	@$(MAKE) rootfs_clean mkinitialrootfs $(ROOTFS_HOSTTOOLS) \
	$(ROOTFS_COMPONENTS) rootfs_fill build_tarbz2_rootfs $(FILESYSTEMS)
	$(call EMBTK_GENERIC_MESSAGE,"Build of selected root filesystems \
	ended successfully!")

rootfs_fill:
	@mkdir -p $(ROOTFS)/lib
ifeq ($(CONFIG_EMBTK_64BITS_FS),y)
	@cd $(ROOTFS); \
	ln -s lib lib64
	@mkdir -p $(ROOTFS)/usr
	@cd $(ROOTFS)/usr; \
	ln -s lib lib64	
endif
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	@cd $(ROOTFS); \
	ln -s lib lib64; \
	mkdir -p lib32
	mkdir -p $(ROOTFS)/usr
	@cd $(ROOTFS)/usr; \
	ln -s lib lib64
	mkdir -p $(ROOTFS)/usr/lib32
endif
	@-cp -d $(SYSROOT)/lib/*.so* $(ROOTFS)/lib/
	@-cp -d $(SYSROOT)/usr/lib/*.so* $(ROOTFS)/usr/lib/
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	@-cp -d $(SYSROOT)/lib32/*.so* $(ROOTFS)/lib32/
	@-cp -d $(SYSROOT)/usr/lib32/*.so* $(ROOTFS)/usr/lib32/
endif
	@-cp -R $(SYSROOT)/bin/* $(ROOTFS)/bin/
	@-cp -R $(SYSROOT)/usr/bin/* $(ROOTFS)/usr/bin/
	@-cp -R $(SYSROOT)/sbin/* $(ROOTFS)/sbin/
	@-cp -R $(SYSROOT)/usr/sbin/* $(ROOTFS)/usr/sbin/
	@cp -R $(SYSROOT)/root  $(ROOTFS)/
ifeq ($(CONFIG_EMBTK_TARGET_STRIPPED),y)
	$(call EMBTK_GENERIC_MESSAGE,"Stripping binaries as specified...")
	@-$(TARGETSTRIP)  $(ROOTFS)/lib/*.so*
	@-$(TARGETSTRIP)  $(ROOTFS)/usr/lib/*.so*
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	@-$(TARGETSTRIP)  $(ROOTFS)/lib32/*.so*
	@-$(TARGETSTRIP)  $(ROOTFS)/usr/lib32/*.so*
endif
	@-$(TARGETSTRIP)  $(ROOTFS)/bin/*
	@-$(TARGETSTRIP)  $(ROOTFS)/sbin/*
	@-$(TARGETSTRIP)  $(ROOTFS)/usr/bin/*
	@-$(TARGETSTRIP)  $(ROOTFS)/usr/sbin/*
endif

mkinitialrootfs:
	@mkdir -p $(ROOTFS)
	@cp -Rp $(EMBTK_ROOT)/src/target_skeleton/* $(ROOTFS)/
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	@mkdir -p  $(ROOTFS)/lib32
	@mkdir -p  $(ROOTFS)/usr/lib32
endif
	@mkdir -p $(PACKAGES_BUILD)

rootfs_clean: $(ROOTFS_HOSTTOOLS_CLEAN) $(ROOTFS_COMPONENTS_CLEAN)
	@rm -rf $(EMBTK_ROOT)/rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)*
	@rm -rf $(EMBTK_ROOT)/initramfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)*

else
rootfs_build:
	@echo "############### Root filesystem build not selected #############"
	@echo "# Root filesystem build not selected in the configuration      #"
	@echo "# interface. If you want to build one please select it.        #"
	@echo "################################################################"
rootfs_clean: $(ROOTFS_HOSTTOOLS_CLEAN)

endif
