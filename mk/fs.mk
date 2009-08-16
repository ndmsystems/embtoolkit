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
# \file         fs.mk
# \brief	fs.mk of Embtoolkit, targets for sereval filesystems build.
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         August 2009
################################################################################

build_tarbz2_rootfs:
	$(call EMBTK_GENERIC_MESSAGE,"Generating tar.bz2 file of the root \
	filesystem...")
	@$(FAKEROOT_BIN) -s $(EMBTK_ROOT)/.fakeroot.001 -- \
	$(MAKEDEVS_DIR)/makedevs \
	-d $(EMBTK_ROOT)/src/devices_table.txt $(ROOTFS)
	@cd $(ROOTFS) ; $(FAKEROOT_BIN) -i $(EMBTK_ROOT)/.fakeroot.001 -- \
	tar cjf rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG).tar.bz2 * ; \
	mv rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG).tar.bz2 $(EMBTK_ROOT)

build_jffs2_rootfs:
	$(call EMBTK_GENERIC_MESSAGE,"Generating JFFS2 root filesystem...")
	@$(FAKEROOT_BIN) -i $(EMBTK_ROOT)/.fakeroot.001 -- \
	$(HOSTTOOLS)/usr/sbin/mkfs.jffs2 \
	-n -e $(CONFIG_EMBTK_ROOTFS_HAVE_JFFS2_BLOCKSIZE) -r $(ROOTFS) \
	-o $(EMBTK_ROOT)/rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG).jffs2.temp
	@$(FAKEROOT_BIN) -i $(EMBTK_ROOT)/.fakeroot.001 -- \
	$(HOSTTOOLS)/usr/sbin/sumtool \
	-n -e $(CONFIG_EMBTK_ROOTFS_HAVE_JFFS2_BLOCKSIZE) \
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
