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
# \file         mtd-utils.mk
# \brief	mtd-utils.mk of Embtoolkit.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         June 2009
################################################################################

MTDUTILS_NAME			:= mtd-utils
MTDUTILS_VERSION		:= $(call embtk_get_pkgversion,mtdutils)
MTDUTILS_SITE			:= ftp://ftp.infradead.org/pub/mtd-utils
MTDUTILS_SITE_MIRROR3		:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
MTDUTILS_PATCH_SITE		:= ftp://ftp.embtoolkit.org/embtoolkit.org/mtd-utils/$(MTDUTILS_VERSION)
MTDUTILS_PACKAGE		:= mtd-utils-$(MTDUTILS_VERSION).tar.bz2
MTDUTILS_SRC_DIR		:= $(embtk_pkgb)/mtd-utils-$(MTDUTILS_VERSION)
MTDUTILS_BUILD_DIR		:= $(embtk_pkgb)/mtd-utils-$(MTDUTILS_VERSION)

#
# make these binaries selectable from kconfig after version 1.4.6
#
MTDUTILS_SBINS := bin2nand flash_eraseall flash_unlock mkfs.jffs2 nand2bin \
		nftl_format rfddump ubicrc32 ubimirror ubirmvol docfdisk \
		flash_info ftl_check mkfs.ubifs nanddump pddcustomize \
		rfdformat ubicrc32.pl ubimkvol ubirsvol doc_loadbios \
		flash_lock ftl_format mkpfi nandtest pfi2bin serve_image \
		ubidetach ubinfo ubiupdatevol flashcp flash_otp_dump \
		jffs2dump mtd_debug nandwrite pfiflash sumtool ubiformat \
		ubinize unubi flash_erase flash_otp_info mkbootenv mtdinfo \
		nftldump recv_image ubiattach ubigen ubirename

MTDUTILS_DEPS		:= zlib_install lzo_install e2fsprogs_install
MTDUTILS_MAKE_ENV	:= LDFLAGS="-L$(embtk_sysroot)/lib -L$(embtk_sysroot)/usr/lib"
MTDUTILS_MAKE_ENV	+= CPPFLAGS="-I. -I./include -I$(embtk_sysroot)/usr/include"
MTDUTILS_MAKE_ENV	+= CFLAGS="$(TARGET_CFLAGS)"
MTDUTILS_MAKE_ENV	+= BUILDDIR=$(MTDUTILS_BUILD_DIR)
MTDUTILS_MAKE_ENV	+= DESTDIR=$(embtk_sysroot)
MTDUTILS_MAKE_ENV	+= PATH=$(PATH):$(embtk_tools)/bin CROSS=$(CROSS_COMPILE)

mtdutils_install:
	$(call embtk_makeinstall_pkg,mtdutils)

#
# mtd-utils for host development machine.
#
MTDUTILS_HOST_NAME		:= $(MTDUTILS_NAME)
MTDUTILS_HOST_VERSION		:= $(MTDUTILS_VERSION)
MTDUTILS_HOST_SITE		:= $(MTDUTILS_SITE)
MTDUTILS_HOST_SITE_MIRROR1	:= $(MTDUTILS_SITE_MIRROR1)
MTDUTILS_SITE_MIRROR2		:= $(MTDUTILS_SITE_MIRROR2)
MTDUTILS_HOST_SITE_MIRROR3	:= $(MTDUTILS_SITE_MIRROR3)
MTDUTILS_HOST_PACKAGE		:= $(MTDUTILS_PACKAGE)
MTDUTILS_HOST_SRC_DIR		:= $(embtk_toolsb)/mtd-utils-$(MTDUTILS_VERSION)
MTDUTILS_HOST_BUILD_DIR		:= $(embtk_toolsb)/mtd-utils-$(MTDUTILS_VERSION)

MTDUTILS_HOST_DEPS	:= zlib_host_install lzo_host_install \
			e2fsprogs_host_install

MTDUTILS_HOST_MAKE_ENV	:= LDFLAGS="-L$(embtk_htools)/usr/lib"
MTDUTILS_HOST_MAKE_ENV	+= CPPFLAGS="-I. -Iinclude -I../include -I$(embtk_htools)/usr/include"
MTDUTILS_HOST_MAKE_ENV	+= DESTDIR=$(embtk_htools)
MTDUTILS_HOST_MAKE_ENV	+= BUILDDIR=$(MTDUTILS_HOST_BUILD_DIR)

mtdutils_host_install:
	$(call embtk_makeinstall_hostpkg,mtdutils_host)
