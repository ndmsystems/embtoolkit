################################################################################
# Embtoolkit
# Copyright(C) 2009-2014 Abdoulaye Walsimou GAYE.
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
include core/mk/rootfs/fs.mk

ROOTFS_JFFS2		:= $(embtk_generated)/rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)-$(embtk_clib).jffs2
ROOTFS_TARBZ2		:= rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)-$(embtk_clib).tar.bz2
ROOTFS_SQUASHFS		:= $(embtk_generated)/rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)-$(embtk_clib).squashfs
ROOTFS_INITRAMFS	:= $(embtk_generated)/rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)-$(embtk_clib).initramfs

HOSTTOOLS_COMPONENTS-y += makedevs_install
HOSTTOOLS_COMPONENTS-$(CONFIG_EMBTK_ROOTFS_HAVE_JFFS2) += mtdutils_host_install

# Files to strip if requested

__embtk_rootfs/libso		= $(shell [ -d $(embtk_rootfs)/lib ] && find $(embtk_rootfs)/lib -type f -name *.so*)
__embtk_rootfs/lib32so		= $(shell [ -d $(embtk_rootfs)/lib32 ] && find $(embtk_rootfs)/lib32 -type f -name *.so*)
__embtk_rootfs/usr/libso	= $(shell [ -d $(embtk_rootfs)/usr/lib ] && find $(embtk_rootfs)/usr/lib -type f -name *.so*)
__embtk_rootfs/usr/lib32so	= $(shell [ -d $(embtk_rootfs)/usr/lib32 ] && find $(embtk_rootfs)/usr/lib32 -type f -name *.so*)
__embtk_rootfs/usr/libexec	= $(shell [ -d $(embtk_rootfs)/usr/libexec ] && find $(embtk_rootfs)/usr/libexec -type f)
__embtk_rootfs/bins		= $(shell [ -d $(embtk_rootfs)/bin ] && find $(embtk_rootfs)/bin -type f)
__embtk_rootfs/sbins		= $(shell [ -d $(embtk_rootfs)/sbin ] && find $(embtk_rootfs)/sbin -type f)
__embtk_rootfs/usr/bins		= $(shell [ -d $(embtk_rootfs)/usr/bin ] && find $(embtk_rootfs)/usr/bin -type f)
__embtk_rootfs/usr/sbins	= $(shell [ -d $(embtk_rootfs)/usr/sbin ] && find $(embtk_rootfs)/usr/sbin -type f)

define __embtk_rootfs_strip_f
	-$(FAKEROOT_BIN) -i $(FAKEROOT_ENV_FILE) --				\
					$(TARGETSTRIP) $(1) >/dev/null 2>&1
endef

define __embtk_rootfs_components_strip
	$(call embtk_pinfo,"Stripping binaries as specified...")
	$(if $(__embtk_rootfs/libso),
		$(foreach bin,$(__embtk_rootfs/libso),
				$(call __embtk_rootfs_strip_f,$(bin)) &&:))
	$(if $(__embtk_rootfs/lib32so),
		$(foreach bin,$(__embtk_rootfs/lib32so),
				$(call __embtk_rootfs_strip_f,$(bin)) &&:))
	$(if $(__embtk_rootfs/usr/libso),
		$(foreach bin,$(__embtk_rootfs/usr/libso),
				$(call __embtk_rootfs_strip_f,$(bin)) &&:))
	$(if $(__embtk_rootfs/usr/lib32so),
		$(foreach bin,$(__embtk_rootfs/usr/lib32so),
				$(call __embtk_rootfs_strip_f,$(bin)) &&:))
	$(if $(__embtk_rootfs/usr/libexec),
		$(foreach bin,$(__embtk_rootfs/usr/libexec),
				$(call __embtk_rootfs_strip_f,$(bin)) &&:))
	$(if $(__embtk_rootfs/bins),
		$(foreach bin,$(__embtk_rootfs/bins),
				$(call __embtk_rootfs_strip_f,$(bin)) &&:))
	$(if $(__embtk_rootfs/sbins),
		$(foreach bin,$(__embtk_rootfs/sbins),
				$(call __embtk_rootfs_strip_f,$(bin)) &&:))
	$(if $(__embtk_rootfs/usr/bins),
		$(foreach bin,$(__embtk_rootfs/usr/bins),
				$(call __embtk_rootfs_strip_f,$(bin)) &&:))
	$(if $(__embtk_rootfs/usr/sbins),
		$(foreach bin,$(__embtk_rootfs/usr/sbins),
				$(call __embtk_rootfs_strip_f,$(bin)) &&:))
endef

define __embtk_rootfs_mkdevnodes
	$(call embtk_pinfo,"Populating devices nodes of the rootfs...")
	$(FAKEROOT_BIN) -s $(FAKEROOT_ENV_FILE) -- $(MAKEDEVS_BIN)		\
				-d $(EMBTK_ROOT)/src/devices_table.txt $(embtk_rootfs)
endef

define __embtk_rootfs_cleanup
	$(foreach pkg-n,$(__embtk_rootfs_pkgs-n),
		$(call __embtk_cleanup_pkg,$(pkg-n)))
	rm -rf $(embtk_generated)/rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)*
endef

define __embtk_rootfs_mkinitpath
	mkdir -p $(embtk_rootfs)
	cp -Rp $(EMBTK_ROOT)/src/rootfs_skel/* $(embtk_rootfs)
	mkdir -p $(embtk_pkgb)
	$(if $(CONFIG_EMBTK_64BITS_FS_COMPAT32),
		mkdir -p $(embtk_rootfs)/lib32
		mkdir -p $(embtk_rootfs)/usr/lib32)
endef

define __embtk_rootfs_components_install
	mkdir -p $(embtk_rootfs)/$(LIBDIR)
	mkdir -p $(embtk_rootfs)/lib
	mkdir -p $(embtk_rootfs)/usr
	mkdir -p $(embtk_rootfs)/usr/$(LIBDIR)
	mkdir -p $(embtk_rootfs)/usr/lib
	$(if $(CONFIG_EMBTK_64BITS_FS),
		cd $(embtk_rootfs); ln -s lib lib64
		cd $(embtk_rootfs)/usr; ln -s lib lib64)
	$(if $(CONFIG_EMBTK_64BITS_FS_COMPAT32),
		cd $(embtk_rootfs); ln -s lib lib64
		cd $(embtk_rootfs)/usr; ln -s lib lib64)
	-(cd $(embtk_sysroot)/lib/ && tar -cf - *.so*)				\
		| tar -xf - -C $(embtk_rootfs)/lib/
	-(cd $(embtk_sysroot)/usr/lib/ && tar -cf - *.so*)			\
		| tar -xf - -C $(embtk_rootfs)/usr/lib/
	-cp -R $(embtk_sysroot)/usr/libexec $(embtk_rootfs)/usr/
	rm -rf $(embtk_rootfs)/lib/libgcc_s.so
	rm -rf $(embtk_rootfs)/usr/lib/libc.so
	$(if $(CONFIG_EMBTK_64BITS_FS_COMPAT32),
		-(cd $(embtk_sysroot)/lib32/ && tar -cf - *.so*)		\
			| tar -xf - -C $(embtk_rootfs)/lib32/
		-(cd $(embtk_sysroot)/usr/lib32/ && tar -cf - *.so*)		\
			| tar -xf - -C $(embtk_rootfs)/usr/lib32/
		rm -rf $(embtk_rootfs)/lib32/libgcc_s.so
		rm -rf $(embtk_rootfs)/usr/lib32/libc.so)
	-cp -R $(embtk_sysroot)/bin/* $(embtk_rootfs)/bin/ >/dev/null 2>/dev/null
	-cp -R $(embtk_sysroot)/usr/bin/* $(embtk_rootfs)/usr/bin/
	-cp -R $(embtk_sysroot)/sbin/* $(embtk_rootfs)/sbin/ >/dev/null 2>/dev/null
	-cp -R $(embtk_sysroot)/usr/sbin/* $(embtk_rootfs)/usr/sbin/
	-cp -R $(embtk_sysroot)/etc/* $(embtk_rootfs)/etc/ >/dev/null 2>/dev/null
	-rm -rf $$(find $(embtk_rootfs) -type f -name '.empty')
	cp -R $(embtk_sysroot)/root $(embtk_rootfs)/
	-$(FAKEROOT_BIN) -i $(FAKEROOT_ENV_FILE) -- 				\
				rm -rf `find $(embtk_rootfs) -type f -name *.la`
endef

define __embtk_rootfs_fs_generate
	$(call embtk_rootfs_mktarbz2,$(embtk_rootfs),$(ROOTFS_TARBZ2))
	$(if $(CONFIG_EMBTK_ROOTFS_HAVE_INITRAMFS_CPIO),
		$(call embtk_rootfs_mkinitramfs,$(embtk_rootfs),$(ROOTFS_INITRAMFS)))
	$(if $(CONFIG_EMBTK_ROOTFS_HAVE_JFFS2),
		$(call embtk_rootfs_mkjffs2,$(embtk_rootfs),$(ROOTFS_JFFS2)))
	$(if $(CONFIG_EMBTK_ROOTFS_HAVE_SQUASHFS),
		$(call embtk_rootfs_mksquashfs,$(embtk_rootfs),$(ROOTFS_SQUASHFS)))
	rm -rf $(embtk_rootfs)
endef

__rootfs_build_msg:
	$(call embtk_pinfo,"Building selected filesystems - please wait...")

__rootfs_clean:
	$(Q)$(__embtk_rootfs_cleanup)

__rootfs_mkinitpath:
	$(Q)$(__embtk_rootfs_mkinitpath)

__rootfs_components_build: $(ROOTFS_COMPONENTS-y)
	true

__rootfs_mkdevnodes:
	$(Q)$(__embtk_rootfs_mkdevnodes)

__rootfs_components_install:
	$(Q)$(__embtk_rootfs_components_install)

__rootfs_components_strip:
	$(__embtk_rootfs_components_strip)

__rootfs_prebuild_targets := __rootfs_build_msg
__rootfs_prebuild_targets += __rootfs_clean
__rootfs_prebuild_targets += __rootfs_mkinitpath
__rootfs_prebuild_targets += __rootfs_components_build
__rootfs_prebuild_targets += __rootfs_mkdevnodes
__rootfs_prebuild_targets += __rootfs_components_install
__rootfs_prebuild_targets += $(if $(CONFIG_EMBTK_BUILD_LINUX_KERNEL),linux_modules_install)
__rootfs_prebuild_targets += $(if $(CONFIG_EMBTK_TARGET_STRIPPED),__rootfs_components_strip)

define __rootfs_build_end
	$(if $(findstring rootfs_build,$(MAKECMDGOALS)),
		$(call embtk_pinfo,"Selected root filesystems built successfully...")
		$(help_rootfs_summary))
endef

rootfs_build: toolchain_install host_packages_build $(__rootfs_prebuild_targets)
	$(Q)$(__embtk_rootfs_fs_generate)
	$(Q)$(__rootfs_build_end)
else
# Build of root file system not selected
rootfs_build:
	$(call embtk_pinfo,"Build of root filesystem not selected")
endif
