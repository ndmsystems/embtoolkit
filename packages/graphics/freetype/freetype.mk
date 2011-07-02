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
# \file         freetype.mk
# \brief	freetype.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         October 2009
################################################################################

FREETYPE_NAME		:= freetype
FREETYPE_VERSION	:= $(call embtk_get_pkgversion,FREETYPE)
FREETYPE_SITE		:= http://downloads.sourceforge.net/project/freetype/freetype2/$(FREETYPE_VERSION)
FREETYPE_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
FREETYPE_PATCH_SITE	:= ftp://ftp.embtoolkit.org/embtoolkit.org/freetype/$(FREETYPE_VERSION)
FREETYPE_PACKAGE	:= freetype-$(FREETYPE_VERSION).tar.bz2
FREETYPE_SRC_DIR	:= $(PACKAGES_BUILD)/freetype-$(FREETYPE_VERSION)
FREETYPE_BUILD_DIR	:= $(PACKAGES_BUILD)/freetype-$(FREETYPE_VERSION)

FREETYPE_BINS		= freetype*
FREETYPE_SBINS		=
FREETYPE_INCLUDES	= ft*build.h freetype*
FREETYPE_LIBS		= libfreetype*
FREETYPE_PKGCONFIGS	= freetype*.pc

FREETYPE_DEPS		:= zlib_install
FREETYPE_MAKE_OPTS	:= LIBTOOL=$(FREETYPE_BUILD_DIR)/builds/unix/libtool

freetype_install:
	$(call embtk_install_pkg,FREETYPE)

download_freetype:
	$(call embtk_download_pkg,FREETYPE)

freetype_clean:
	$(call embtk_cleanup_pkg,FREETYPE)
