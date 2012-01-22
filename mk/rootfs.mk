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

ROOTFS_HOSTTOOLS-y		:=
FILESYSTEMS-y			:=

#include various filesystems targets
include $(EMBTK_ROOT)/mk/fs.mk

#host tools in order to build root filesystems: fakeroot and makedevs.
include $(EMBTK_ROOT)/mk/fakeroot.mk
include $(EMBTK_ROOT)/mk/makedevs.mk
ROOTFS_HOSTTOOLS-y += makedevs_install fakeroot_install

#Does CPIO archive for initramfs selected?
FILESYSTEMS-$(CONFIG_EMBTK_ROOTFS_HAVE_INITRAMFS_CPIO) += build_initramfs_archive

#Does jffs2 filesystem selected?
ROOTFS_HOSTTOOLS-$(CONFIG_EMBTK_ROOTFS_HAVE_JFFS2) += mtdutils_host_install
FILESYSTEMS-$(CONFIG_EMBTK_ROOTFS_HAVE_JFFS2) += build_jffs2_rootfs

#Does squashfs filesystem selected?
ROOTFS_HOSTTOOLS-$(CONFIG_EMBTK_ROOTFS_HAVE_SQUASHFS) += squashfs_tools_install
FILESYSTEMS-$(CONFIG_EMBTK_ROOTFS_HAVE_SQUASHFS) += build_squashfs_rootfs
ifeq ($(CONFIG_EMBTK_ROOTFS_HAVE_SQUASHFS),y)
include $(EMBTK_ROOT)/mk/squashfs.mk
endif

#Files to strip if requested
ifeq ($(CONFIG_EMBTK_TARGET_STRIPPED),y)
ROOTFS_STRIPPED_FILES := `find $$ROOTFS/lib -type f -name *.so*`
ROOTFS_STRIPPED_FILES += `find $$ROOTFS/usr/lib -type f -name *.so*`
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
ROOTFS_STRIPPED_FILES += `find $$ROOTFS/lib32 -type f -name *.so*`
ROOTFS_STRIPPED_FILES += `find $$ROOTFS/usr/lib32 -type f -name *.so*`
endif
ROOTFS_STRIPPED_FILES += `[ -d $$ROOTFS/bin ] && find $$ROOTFS/bin -type f`
ROOTFS_STRIPPED_FILES += `[ -d $$ROOTFS/sbin ] && find $$ROOTFS/sbin -type f`
ROOTFS_STRIPPED_FILES += `[ -d $$ROOTFS/usr/bin ] && find $$ROOTFS/usr/bin -type f`
ROOTFS_STRIPPED_FILES += `[ -d $$ROOTFS/usr/sbin ] && find $$ROOTFS/usr/sbin -type f`
ROOTFS_STRIPPED_FILES += `[ -d $$ROOTFS/usr/libexec ] && find $$ROOTFS/usr/libexec -type f`
endif

define __embtk_rootfs_mkdevnodes
	$(call embtk_pinfo,"Populating devices nodes of the rootfs...")
	$(FAKEROOT_BIN) -s $(FAKEROOT_ENV_FILE) -- $(MAKEDEVS_BIN)		\
				-d $(EMBTK_ROOT)/src/devices_table.txt $(ROOTFS)
endef

define __embtk_rootfs_cleanup
	$(foreach pkg-n,$(__embtk_rootfs_pkgs-n),$(MAKE) $(pkg-n)_clean;)
	rm -rf $(EMBTK_GENERATED)/rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)*
	rm -rf $(EMBTK_GENERATED)/initramfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)*
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
	-cp -d $(SYSROOT)/lib/*.so* $(ROOTFS)/lib/
	-cp -d $(SYSROOT)/usr/lib/*.so* $(ROOTFS)/usr/lib/
	$(if $(CONFIG_EMBTK_64BITS_FS_COMPAT32),
		-cp -d $(SYSROOT)/lib32/*.so* $(ROOTFS)/lib32/
		-cp -d $(SYSROOT)/usr/lib32/*.so* $(ROOTFS)/usr/lib32/)
	-cp -R $(SYSROOT)/bin/* $(ROOTFS)/bin/ >/dev/null 2>/dev/null
	-cp -R $(SYSROOT)/usr/bin/* $(ROOTFS)/usr/bin/
	-cp -R $(SYSROOT)/sbin/* $(ROOTFS)/sbin/ >/dev/null 2>/dev/null
	-cp -R $(SYSROOT)/usr/sbin/* $(ROOTFS)/usr/sbin/
	-cp -R $(SYSROOT)/etc/* $(ROOTFS)/etc/ >/dev/null 2>/dev/null
	cp -R $(SYSROOT)/root $(ROOTFS)/
	$(if $(CONFIG_EMBTK_TARGET_STRIPPED),
		$(call embtk_pinfo,"Stripping binaries as specified...")
		-$(FAKEROOT_BIN) -i $(EMBTK_ROOT)/.fakeroot.001 --		\
			$(TARGETSTRIP) $(ROOTFS_STRIPPED_FILES) >/dev/null 2>&1)
	-$(FAKEROOT_BIN) -i $(EMBTK_ROOT)/.fakeroot.001 -- 			\
		rm -rf `find $$ROOTFS -type f -name *.la`
endef

define __embtk_rootfs_build
	$(call embtk_pinfo,"Building selected root filesystems - please wait...")
	$(__embtk_rootfs_cleanup)
	$(__embtk_rootfs_mkinitpath)
	$(MAKE) $(ROOTFS_HOSTTOOLS-y) $(ROOTFS_COMPONENTS-y)
	$(__embtk_rootfs_mkdevnodes)
	$(__embtk_rootfs_fill)
	$(MAKE) build_tarbz2_rootfs $(FILESYSTEMS-y)
	rm -rf $(ROOTFS)
	$(call embtk_pinfo,"Selected root filesystems built successfully!")
endef

rootfs_build:
	$(Q)$(__embtk_rootfs_build)

# Download target for offline build
packages_fetch:: $(patsubst %_install,download_%,$(ROOTFS_HOSTTOOLS-y))
else
rootfs_build:
	$(call embtk_pinfo,"Build of root filesystem not selected")
endif
