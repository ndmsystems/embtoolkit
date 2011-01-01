################################################################################
# Embtoolkit
# Copyright(C) 2009-2011 Abdoulaye Walsimou GAYE. All rights reserved.
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
# \file         fs.mk
# \brief	fs.mk of Embtoolkit, targets for sereval filesystems build.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         August 2009
################################################################################

build_rootfs_devnodes:
	$(call EMBTK_GENERIC_MESSAGE,"Populating device nodes of the root \
	filesystem...")
	@$(FAKEROOT_BIN) -s $(EMBTK_ROOT)/.fakeroot.001 -- \
	$(MAKEDEVS_DIR)/makedevs \
	-d $(EMBTK_ROOT)/src/devices_table.txt $(ROOTFS)

build_tarbz2_rootfs:
	$(call EMBTK_GENERIC_MESSAGE,"Generating tar.bz2 file of the root \
	filesystem...")
	@cd $(ROOTFS) ; $(FAKEROOT_BIN) -i $(EMBTK_ROOT)/.fakeroot.001 -- \
	tar cjf rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG).tar.bz2 * ; \
	mv rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG).tar.bz2 $(EMBTK_ROOT)

build_jffs2_rootfs:
	$(call EMBTK_GENERIC_MESSAGE,"Generating JFFS2 root filesystem...")
	@$(FAKEROOT_BIN) -i $(EMBTK_ROOT)/.fakeroot.001 -- \
	$(HOSTTOOLS)/usr/sbin/mkfs.jffs2 \
	--eraseblock=$(CONFIG_EMBTK_ROOTFS_HAVE_JFFS2_ERASEBLOCKSIZE) \
	--pad=$(CONFIG_EMBTK_ROOTFS_HAVE_JFFS2_ERASEBLOCKSIZE) \
	--pagesize=$(CONFIG_EMBTK_ROOTFS_HAVE_JFFS2_PAGESIZE) \
	--cleanmarker=$(CONFIG_EMBTK_ROOTFS_HAVE_JFFS2_CLEANMARKERSIZE) \
	$(if $(CONFIG_EMBTK_TARGET_ARCH_LITTLE_ENDIAN), \
		--little-endian, --big-endian) \
	-n --root=$(ROOTFS) \
	-o $(EMBTK_ROOT)/rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG).jffs2.temp
	@$(FAKEROOT_BIN) -i $(EMBTK_ROOT)/.fakeroot.001 -- \
	$(HOSTTOOLS)/usr/sbin/sumtool \
	--eraseblock=$(CONFIG_EMBTK_ROOTFS_HAVE_JFFS2_ERASEBLOCKSIZE) \
	--cleanmarker=$(CONFIG_EMBTK_ROOTFS_HAVE_JFFS2_CLEANMARKERSIZE) \
	$(if $(CONFIG_EMBTK_TARGET_ARCH_LITTLE_ENDIAN), \
		--littleendian, --bigendian) \
	-n -p \
	-i $(EMBTK_ROOT)/rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG).jffs2.temp \
	-o $(EMBTK_ROOT)/rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG).jffs2
	@rm -rf $(EMBTK_ROOT)/rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG).jffs2.temp

build_squashfs_rootfs:
	$(call EMBTK_GENERIC_MESSAGE,"Generating squashfs root filesystem...")
	$(FAKEROOT_BIN) -i $(EMBTK_ROOT)/.fakeroot.001 -- \
	$(HOSTTOOLS)/usr/bin/mksquashfs $(ROOTFS) \
	rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG).squashfs

build_initramfs_archive:
	$(call EMBTK_GENERIC_MESSAGE,"Generating cpio archive for initramfs...")
ifeq ($(EMBTK_ROOTFS_HAVE_INITRAMFS_CPIO_GZIPED),y)
	@$(FAKEROOT_BIN) -i $(EMBTK_ROOT)/.fakeroot.001 -- \
	$(EMBTK_ROOT)/scripts/mkinitramfs $(ROOTFS) gzip \
	$(EMBTK_ROOT)/initramfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)
else
	@$(FAKEROOT_BIN) -i $(EMBTK_ROOT)/.fakeroot.001 -- \
	$(EMBTK_ROOT)/scripts/mkinitramfs $(ROOTFS) bzip2 \
	$(EMBTK_ROOT)/initramfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)
endif
