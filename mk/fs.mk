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
# \file         fs.mk
# \brief	fs.mk of Embtoolkit, macros for sereval filesystems build.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         August 2009
################################################################################

#
# TAR.BZ2 rootfs macro
#
__embtk_tarbz2_rootdir	= $(strip $(1))
__embtk_tarbz2_rootfs	= $(strip $(2))
define embtk_rootfs_mktarbz2
	$(call embtk_pinfo,"Generating TAR.BZ2 file of the rootfs...")
	cd $(__embtk_tarbz2_rootdir);						\
	$(FAKEROOT_BIN) -i $(FAKEROOT_ENV_FILE) --				\
	tar cjf $(__embtk_tarbz2_rootfs) *;					\
	mv $(__embtk_tarbz2_rootfs) $(EMBTK_GENERATED)/
endef

#
# JFFS2 rootfs macro
#
__embtk_mkjffs2			:= $(HOSTTOOLS)/usr/sbin/mkfs.jffs2
__embtk_sumtool			:= $(HOSTTOOLS)/usr/sbin/sumtool
__embtk_jffs2_eraseblksz	:= $(CONFIG_EMBTK_ROOTFS_HAVE_JFFS2_ERASEBLOCKSIZE)
__embtk_jffs2_pad		:= $(CONFIG_EMBTK_ROOTFS_HAVE_JFFS2_ERASEBLOCKSIZE)
__embtk_jffs2_pagesz		:= $(CONFIG_EMBTK_ROOTFS_HAVE_JFFS2_PAGESIZE)
__embtk_jffs2_cleanmarkersz	:= $(CONFIG_EMBTK_ROOTFS_HAVE_JFFS2_CLEANMARKERSIZE)
__embtk_jffs2_rootdir		= $(strip $(1))
__embtk_jffs2_rootfs		= $(strip $(2))
define embtk_rootfs_mkjffs2
	$(call embtk_pinfo,"Generating JFFS2 rootfs..")
	$(FAKEROOT_BIN) -i $(FAKEROOT_ENV_FILE) --				\
	$(__embtk_mkjffs2)							\
		--eraseblock=$(__embtk_jffs2_eraseblksz)			\
		--pad=$(__embtk_jffs2_pad)					\
		--pagesize=$(__embtk_jffs2_pagesz)				\
		--cleanmarker=$(__embtk_jffs2_cleanmarkersz)			\
		$(if $(CONFIG_EMBTK_TARGET_ARCH_LITTLE_ENDIAN),			\
					--little-endian,--big-endian)		\
		-n --root=$(__embtk_jffs2_rootdir)				\
		-o $(__embtk_jffs2_rootfs).temp
	$(__embtk_sumtool)							\
		--eraseblock=$(__embtk_jffs2_eraseblksz)			\
		--cleanmarker=$(__embtk_jffs2_cleanmarkersz)			\
		$(if $(CONFIG_EMBTK_TARGET_ARCH_LITTLE_ENDIAN),			\
					--littleendian,--bigendian)		\
		-n -p -i $(__embtk_jffs2_rootfs).temp -o $(__embtk_jffs2_rootfs)
	rm -rf $(__embtk_jffs2_rootfs).temp
endef

#
# SQUASHFS rootfs macro
#
__embtk_mksquashfs		:= $(MKSQUASHFS_BIN)
__embtk_squashfs_rootdir	= $(strip $(1))
__embtk_squashfs_rootfs		= $(strip $(2))
define embtk_rootfs_mksquashfs
	$(call embtk_pinfo,"Generating SQUASHFS rootfs...")
	$(FAKEROOT_BIN) -i $(FAKEROOT_ENV_FILE) --				\
	$(__embtk_mksquashfs)							\
		$(__embtk_squashfs_rootdir) $(__embtk_squashfs_rootfs)		\
		$(if $(CONFIG_EMBTK_SQUASHFS_TOOLS_VERSION_3_4),		\
			$(if $(CONFIG_EMBTK_TARGET_ARCH_LITTLE_ENDIAN),-le,-be))\
		-all-root
endef

#
# CPIO (initramfs) rootfs macro
#
__embtk_mkinitramfs		:= $(EMBTK_ROOT)/scripts/mkinitramfs
__embtk_initramfs_rootdir	= $(strip $(1))
__embtk_initramfs_rootfs	= $(strip $(2))
define embtk_rootfs_mkinitramfs
	$(call embtk_pinfo,"Generating INITRAMFS rootfs...")
	$(FAKEROOT_BIN) -i $(FAKEROOT_ENV_FILE) --				\
	$(__embtk_mkinitramfs)							\
		$(__embtk_initramfs_rootdir)					\
		$(if $(EMBTK_ROOTFS_HAVE_INITRAMFS_CPIO_GZIPED),gzip,bzip2)	\
		$(__embtk_initramfs_rootfs)
endef
