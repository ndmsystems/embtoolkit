################################################################################
# Embtoolkit
# Copyright(C) 2009-2013 Abdoulaye Walsimou GAYE.
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
MTDUTILS_PACKAGE		:= mtd-utils-$(MTDUTILS_VERSION).tar.bz2
MTDUTILS_SRC_DIR		:= $(embtk_pkgb)/mtd-utils-$(MTDUTILS_VERSION)
MTDUTILS_BUILD_DIR		:= $(embtk_pkgb)/mtd-utils-$(MTDUTILS_VERSION)

MTDUTILS_DEPS		:= zlib_install lzo_install e2fsprogs_install

__embtk_mtdutils_cflags	:= $(TARGET_CFLAGS)

# FIXME: remove this after upgrade to new version of mtd-utils
__embtk_mtdutils_cflags	+= -std=gnu90

MTDUTILS_MAKE_ENV	:= LDFLAGS="-L$(embtk_sysroot)/lib -L$(embtk_sysroot)/usr/lib"
MTDUTILS_MAKE_ENV	+= CPPFLAGS="-I. -I./include -I$(embtk_sysroot)/usr/include"
MTDUTILS_MAKE_ENV	+= CFLAGS="$(__embtk_mtdutils_cflags)"
MTDUTILS_MAKE_ENV	+= BUILDDIR=$(MTDUTILS_BUILD_DIR)
MTDUTILS_MAKE_ENV	+= PATH=$(PATH):$(embtk_tools)/bin
MTDUTILS_MAKE_ENV	+= CROSS=$(CROSS_COMPILE)
MTDUTILS_MAKE_OPTS	:= CC=$(TARGETCC_CACHED)
MTDUTILS_MAKE_OPTS	+= DESTDIR=$(embtk_sysroot) WITHOUT_XATTR=1

define __embtk_install_mtdutils
	$(call embtk_makeinstall_pkg,mtdutils)
endef
define embtk_install_mtdutils
	$(call embtk_makeinstall_pkg,mtdutils)
endef

#
# make these binaries selectable from kconfig
#
MTDUTILS_SBINS	:= docfdisk
MTDUTILS_SBINS	+= flash_erase
MTDUTILS_SBINS	+= flash_otp_dump
MTDUTILS_SBINS	+= ftl_check
MTDUTILS_SBINS	+= jffs2reader
MTDUTILS_SBINS	+= mtd_debug
MTDUTILS_SBINS	+= nandtest
MTDUTILS_SBINS	+= nftl_format
MTDUTILS_SBINS	+= rfdformat
MTDUTILS_SBINS	+= ubiattach
MTDUTILS_SBINS	+= ubiformat
MTDUTILS_SBINS	+= ubinize
MTDUTILS_SBINS	+= ubirsvol
MTDUTILS_SBINS	+= doc_loadbios
MTDUTILS_SBINS	+= flash_eraseall
MTDUTILS_SBINS	+= flash_otp_info
MTDUTILS_SBINS	+= ftl_format
MTDUTILS_SBINS	+= mkfs.jffs2
MTDUTILS_SBINS	+= mtdinfo
MTDUTILS_SBINS	+= nandwrite
MTDUTILS_SBINS	+= recv_image
MTDUTILS_SBINS	+= serve_image
MTDUTILS_SBINS	+= ubicrc32
MTDUTILS_SBINS	+= ubimkvol
MTDUTILS_SBINS	+= ubirename
MTDUTILS_SBINS	+= ubiupdatevol
MTDUTILS_SBINS	+= flashcp
MTDUTILS_SBINS	+= flash_lock
MTDUTILS_SBINS	+= flash_unlock
MTDUTILS_SBINS	+= jffs2dump
MTDUTILS_SBINS	+= mkfs.ubifs
MTDUTILS_SBINS	+= nanddump
MTDUTILS_SBINS	+= nftldump
MTDUTILS_SBINS	+= rfddump
MTDUTILS_SBINS	+= sumtool
MTDUTILS_SBINS	+= ubidetach
MTDUTILS_SBINS	+= ubinfo
MTDUTILS_SBINS	+= ubirmvol

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
MTDUTILS_HOST_MAKE_ENV	+= BUILDDIR=$(MTDUTILS_HOST_BUILD_DIR)
MTDUTILS_HOST_MAKE_OPTS	:= DESTDIR=$(embtk_htools) WITHOUT_XATTR=1

define embtk_install_mtdutils_host
	$(call embtk_makeinstall_hostpkg,mtdutils_host)
endef
