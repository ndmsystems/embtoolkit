################################################################################
# Embtoolkit
# Copyright(C) 2009-2011 Abdoulaye Walsimou GAYE.
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

JFFS2_ROOTFS		:= $(EMBTK_GENERATED)/rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG).jffs2
BZIP2_ROOTFS		:= rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG).tar.bz2
SQUASHFS_ROOTFS		:= $(EMBTK_GENERATED)/rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG).squashfs
INITRAMFS_ROOTFS	:= $(EMBTK_GENERATED)/initramfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)

build_rootfs_devnodes:
	$(call embtk_generic_msg,"Populating device nodes of the rootfs...")
	$(Q)$(FAKEROOT_BIN) -s $(FAKEROOT_ENV_FILE) -- $(MAKEDEVS_BIN)		\
			-d $(EMBTK_ROOT)/src/devices_table.txt $(ROOTFS)

build_tarbz2_rootfs:
	$(call embtk_generic_msg,"Generating TAR.BZ2 file of the rootfs...")
	@cd $(ROOTFS) ; $(FAKEROOT_BIN) -i $(FAKEROOT_ENV_FILE) -- \
	tar cjf rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG).tar.bz2 * ; \
	mv $(BZIP2_ROOTFS) $(EMBTK_GENERATED)/

build_jffs2_rootfs:
	$(call embtk_generic_msg,"Generating JFFS2 rootfs..")
	@$(FAKEROOT_BIN) -i $(FAKEROOT_ENV_FILE) -- \
	$(HOSTTOOLS)/usr/sbin/mkfs.jffs2 \
	--eraseblock=$(CONFIG_EMBTK_ROOTFS_HAVE_JFFS2_ERASEBLOCKSIZE) \
	--pad=$(CONFIG_EMBTK_ROOTFS_HAVE_JFFS2_ERASEBLOCKSIZE) \
	--pagesize=$(CONFIG_EMBTK_ROOTFS_HAVE_JFFS2_PAGESIZE) \
	--cleanmarker=$(CONFIG_EMBTK_ROOTFS_HAVE_JFFS2_CLEANMARKERSIZE) \
	$(if $(CONFIG_EMBTK_TARGET_ARCH_LITTLE_ENDIAN), \
		--little-endian, --big-endian) \
	-n --root=$(ROOTFS) -o $(JFFS2_ROOTFS).temp
	@$(FAKEROOT_BIN) -i $(FAKEROOT_ENV_FILE) -- \
	$(HOSTTOOLS)/usr/sbin/sumtool \
	--eraseblock=$(CONFIG_EMBTK_ROOTFS_HAVE_JFFS2_ERASEBLOCKSIZE) \
	--cleanmarker=$(CONFIG_EMBTK_ROOTFS_HAVE_JFFS2_CLEANMARKERSIZE) \
	$(if $(CONFIG_EMBTK_TARGET_ARCH_LITTLE_ENDIAN), \
		--littleendian, --bigendian) \
	-n -p -i $(JFFS2_ROOTFS).temp -o $(JFFS2_ROOTFS)
	@rm -rf $(JFFS2_ROOTFS).temp

build_squashfs_rootfs:
	$(call embtk_generic_msg,"Generating SQUASHFS rootfs...")
	$(FAKEROOT_BIN) -i $(FAKEROOT_ENV_FILE) -- \
	$(MKSQUASHFS_BIN) $(ROOTFS) $(SQUASHFS_ROOTFS)

build_initramfs_archive:
	$(call embtk_generic_msg,"Generating cpio archive for INITRAMFS...")
	@$(FAKEROOT_BIN) -i $(FAKEROOT_ENV_FILE) -- \
	$(EMBTK_ROOT)/scripts/mkinitramfs $(ROOTFS) \
	$(if $(EMBTK_ROOTFS_HAVE_INITRAMFS_CPIO_GZIPED),gzip,bzip2) \
	$(INITRAMFS_ROOTFS)

