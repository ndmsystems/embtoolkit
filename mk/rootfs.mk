################################################################################
# Embtoolkit
# Copyright(C) 2009-2012 Abdoulaye Walsimou GAYE.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
################################################################################
#
# \file         rootfs.mk
# \brief	rootfs.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         June 2009
################################################################################

ifeq ($(CONFIG_EMBTK_HAVE_ROOTFS),y)

# Include various filesystems macros
include $(EMBTK_ROOT)/mk/fs.mk
ROOTFS_JFFS2		:= $(EMBTK_GENERATED)/rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)-$(__embtk_toolchain_clib).jffs2
ROOTFS_TARBZ2		:= rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)-$(__embtk_toolchain_clib).tar.bz2
ROOTFS_SQUASHFS		:= $(EMBTK_GENERATED)/rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)-$(__embtk_toolchain_clib).squashfs
ROOTFS_INITRAMFS	:= $(EMBTK_GENERATED)/rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)-$(__embtk_toolchain_clib).initramfs

HOSTTOOLS_COMPONENTS-y += makedevs_install fakeroot_install
HOSTTOOLS_COMPONENTS-$(CONFIG_EMBTK_ROOTFS_HAVE_JFFS2) += mtdutils_host_install
HOSTTOOLS_COMPONENTS-$(CONFIG_EMBTK_ROOTFS_HAVE_SQUASHFS) += squashfs_tools_install

# Files to strip if requested

__embtk_rootfs/libso		= $(shell [ -d $(ROOTFS)/lib ] && find $(ROOTFS)/lib -type f -name *.so*)
__embtk_rootfs/lib32so		= $(shell [ -d $(ROOTFS)/lib32 ] && find $(ROOTFS)/lib32 -type f -name *.so*)
__embtk_rootfs/usr/libso	= $(shell [ -d $(ROOTFS)/usr/lib ] && find $(ROOTFS)/usr/lib -type f -name *.so*)
__embtk_rootfs/usr/lib32so	= $(shell [ -d $(ROOTFS)/usr/lib32 ] && find $(ROOTFS)/usr/lib32 -type f -name *.so*)
__embtk_rootfs/usr/libexec	= $(shell [ -d $(ROOTFS)/usr/libexec ] && find $(ROOTFS)/usr/libexec -type f)
__embtk_rootfs/bins		= $(shell [ -d $(ROOTFS)/bin ] && find $(ROOTFS)/bin -type f)
__embtk_rootfs/sbins		= $(shell [ -d $(ROOTFS)/sbin ] && find $(ROOTFS)/sbin -type f)
__embtk_rootfs/usr/bins		= $(shell [ -d $(ROOTFS)/usr/bin ] && find $(ROOTFS)/usr/bin -type f)
__embtk_rootfs/usr/sbins	= $(shell [ -d $(ROOTFS)/usr/sbin ] && find $(ROOTFS)/usr/sbin -type f)

define __embtk_rootfs_strip_f
	-$(FAKEROOT_BIN) -i $(FAKEROOT_ENV_FILE) --				\
					$(TARGETSTRIP) $(1) >/dev/null 2>&1
endef

define __embtk_rootfs_stripbins
	$(if $(__embtk_rootfs/libso),
		$(foreach bin,$(__embtk_rootfs/libso),
				$(call __embtk_rootfs_strip_f,$(bin));))
	$(if $(__embtk_rootfs/lib32so),
		$(foreach bin,$(__embtk_rootfs/lib32so),
				$(call __embtk_rootfs_strip_f,$(bin));))
	$(if $(__embtk_rootfs/usr/libso),
		$(foreach bin,$(__embtk_rootfs/usr/libso),
				$(call __embtk_rootfs_strip_f,$(bin));))
	$(if $(__embtk_rootfs/usr/lib32so),
		$(foreach bin,$(__embtk_rootfs/usr/lib32so),
				$(call __embtk_rootfs_strip_f,$(bin));))
	$(if $(__embtk_rootfs/usr/libexec),
		$(foreach bin,$(__embtk_rootfs/usr/libexec),
				$(call __embtk_rootfs_strip_f,$(bin));))
	$(if $(__embtk_rootfs/bins),
		$(foreach bin,$(__embtk_rootfs/bins),
				$(call __embtk_rootfs_strip_f,$(bin));))
	$(if $(__embtk_rootfs/sbins),
		$(foreach bin,$(__embtk_rootfs/sbins),
				$(call __embtk_rootfs_strip_f,$(bin));))
	$(if $(__embtk_rootfs/usr/bins),
		$(foreach bin,$(__embtk_rootfs/usr/bins),
				$(call __embtk_rootfs_strip_f,$(bin));))
	$(if $(__embtk_rootfs/usr/sbins),
		$(foreach bin,$(__embtk_rootfs/usr/sbins),
				$(call __embtk_rootfs_strip_f,$(bin));))
endef

__embtk_rootfs_strip:
	$(__embtk_rootfs_stripbins)

define __embtk_rootfs_mkdevnodes
	$(call embtk_pinfo,"Populating devices nodes of the rootfs...")
	$(FAKEROOT_BIN) -s $(FAKEROOT_ENV_FILE) -- $(MAKEDEVS_BIN)		\
				-d $(EMBTK_ROOT)/src/devices_table.txt $(ROOTFS)
endef

define __embtk_rootfs_cleanup
	$(foreach pkg-n,$(__embtk_rootfs_pkgs-n),
		$(call __embtk_cleanup_pkg,$(pkg-n));)
	rm -rf $(EMBTK_GENERATED)/rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)*
endef

define __embtk_rootfs_mkinitpath
	mkdir -p $(ROOTFS)
	cp -Rp $(EMBTK_ROOT)/src/target_skeleton/* $(ROOTFS)
	mkdir -p $(PACKAGES_BUILD)
	$(if $(CONFIG_EMBTK_64BITS_FS_COMPAT32),
		mkdir -p $(ROOTFS)/lib32
		mkdir -p $(ROOTFS)/usr/lib32)
endef

define __embtk_rootfs_fill
	mkdir -p $(ROOTFS)/$(LIBDIR)
	mkdir -p $(ROOTFS)/lib
	mkdir -p $(ROOTFS)/usr
	mkdir -p $(ROOTFS)/usr/$(LIBDIR)
	mkdir -p $(ROOTFS)/usr/lib
	$(if $(CONFIG_EMBTK_64BITS_FS),
		cd $(ROOTFS); ln -s lib lib64
		cd $(ROOTFS)/usr; ln -s lib lib64)
	$(if $(CONFIG_EMBTK_64BITS_FS_COMPAT32),
		cd $(ROOTFS); ln -s lib lib64
		cd $(ROOTFS)/usr; ln -s lib lib64)
	-cp -d $(embtk_sysroot)/lib/*.so* $(ROOTFS)/lib/
	-cp -d $(embtk_sysroot)/usr/lib/*.so* $(ROOTFS)/usr/lib/
	$(if $(CONFIG_EMBTK_64BITS_FS_COMPAT32),
		-cp -d $(embtk_sysroot)/lib32/*.so* $(ROOTFS)/lib32/
		-cp -d $(embtk_sysroot)/usr/lib32/*.so* $(ROOTFS)/usr/lib32/)
	-cp -R $(embtk_sysroot)/bin/* $(ROOTFS)/bin/ >/dev/null 2>/dev/null
	-cp -R $(embtk_sysroot)/usr/bin/* $(ROOTFS)/usr/bin/
	-cp -R $(embtk_sysroot)/sbin/* $(ROOTFS)/sbin/ >/dev/null 2>/dev/null
	-cp -R $(embtk_sysroot)/usr/sbin/* $(ROOTFS)/usr/sbin/
	-cp -R $(embtk_sysroot)/etc/* $(ROOTFS)/etc/ >/dev/null 2>/dev/null
	cp -R $(embtk_sysroot)/root $(ROOTFS)/
	$(if $(CONFIG_EMBTK_TARGET_STRIPPED),
		$(call embtk_pinfo,"Stripping binaries as specified...")
		$(MAKE) __embtk_rootfs_strip)
	-$(FAKEROOT_BIN) -i $(FAKEROOT_ENV_FILE) -- 				\
				rm -rf `find $(ROOTFS) -type f -name *.la`
endef

define __embtk_rootfs_build
	$(call embtk_pinfo,"Building selected root filesystems - please wait...")
	$(__embtk_rootfs_cleanup)
	$(__embtk_rootfs_mkinitpath)
	$(MAKE) $(ROOTFS_COMPONENTS-y)
	$(__embtk_rootfs_mkdevnodes)
	$(__embtk_rootfs_fill)
	$(call embtk_rootfs_mktarbz2,$(ROOTFS),$(ROOTFS_TARBZ2))
	$(if $(CONFIG_EMBTK_ROOTFS_HAVE_INITRAMFS_CPIO),
		$(call embtk_rootfs_mkinitramfs,$(ROOTFS),$(ROOTFS_INITRAMFS)))
	$(if $(CONFIG_EMBTK_ROOTFS_HAVE_JFFS2),
		$(call embtk_rootfs_mkjffs2,$(ROOTFS),$(ROOTFS_JFFS2)))
	$(if $(CONFIG_EMBTK_ROOTFS_HAVE_SQUASHFS),
		$(call embtk_rootfs_mksquashfs,$(ROOTFS),$(ROOTFS_SQUASHFS)))
	rm -rf $(ROOTFS)
	$(call embtk_pinfo,"Selected root filesystems built successfully!")
endef

rootfs_build: buildtoolchain host_packages_build
	$(Q)$(__embtk_rootfs_build)
else
# Build of root file system not selected
rootfs_build:
	$(call embtk_pinfo,"Build of root filesystem not selected")
endif
