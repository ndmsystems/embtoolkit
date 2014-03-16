################################################################################
# Embtoolkit
# Copyright(C) 2014 Abdoulaye Walsimou GAYE.
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
# \file         mtdutils.mk
# \brief	mtd-utils for host
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         Marsh 2014
################################################################################

MTDUTILS_HOST_NAME		:= mtd-utils
MTDUTILS_HOST_VERSION		:= $(call embtk_get_pkgversion,mtdutils)
MTDUTILS_HOST_SITE		:= ftp://ftp.infradead.org/pub/mtd-utils
MTDUTILS_HOST_PACKAGE		:= mtd-utils-$(MTDUTILS_HOST_VERSION).tar.bz2
MTDUTILS_HOST_SRC_DIR		:= $(embtk_toolsb)/mtd-utils-$(MTDUTILS_HOST_VERSION)
MTDUTILS_HOST_BUILD_DIR		:= $(embtk_toolsb)/mtd-utils-$(MTDUTILS_HOST_VERSION)

MTDUTILS_HOST_DEPS := zlib_host_install lzo_host_install e2fsprogs_host_install

MTDUTILS_HOST_MAKE_ENV	:= LDFLAGS="-L$(embtk_htools)/usr/lib"
MTDUTILS_HOST_MAKE_ENV	+= CPPFLAGS="-I. -Iinclude -I../include -I$(embtk_htools)/usr/include"
MTDUTILS_HOST_MAKE_ENV	+= BUILDDIR=$(MTDUTILS_HOST_BUILD_DIR)
MTDUTILS_HOST_MAKE_OPTS	:= DESTDIR=$(embtk_htools) WITHOUT_XATTR=1

define embtk_install_mtdutils_host
	$(call embtk_makeinstall_hostpkg,mtdutils_host)
endef
