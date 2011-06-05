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

FREETYPE_NAME := freetype
FREETYPE_VERSION := $(call EMBTK_GET_PKG_VERSION,FREETYPE)
FREETYPE_SITE := http://downloads.sourceforge.net/project/freetype/freetype2/$(FREETYPE_VERSION)
FREETYPE_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
FREETYPE_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/freetype/$(FREETYPE_VERSION)
FREETYPE_PACKAGE := freetype-$(FREETYPE_VERSION).tar.bz2
FREETYPE_SRC_DIR := $(PACKAGES_BUILD)/freetype-$(FREETYPE_VERSION)
FREETYPE_BUILD_DIR := $(PACKAGES_BUILD)/freetype-$(FREETYPE_VERSION)

FREETYPE_BINS = freetype*
FREETYPE_SBINS =
FREETYPE_INCLUDES = ft*build.h freetype*
FREETYPE_LIBS = libfreetype*
FREETYPE_PKGCONFIGS = freetype*.pc

FREETYPE_DEPS := zlib_install

freetype_install:
	@test -e $(FREETYPE_BUILD_DIR)/.installed || \
	$(MAKE) $(FREETYPE_BUILD_DIR)/.installed

$(FREETYPE_BUILD_DIR)/.installed: $(FREETYPE_DEPS) download_freetype \
	$(FREETYPE_BUILD_DIR)/.decompressed $(FREETYPE_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	freetype-$(FREETYPE_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH, $(FREETYPE_BUILD_DIR))
	$(MAKE) -C $(FREETYPE_BUILD_DIR) $(J) \
	LIBTOOL=$(FREETYPE_BUILD_DIR)/builds/unix/libtool
	$(MAKE) -C $(FREETYPE_BUILD_DIR) \
	LIBTOOL=$(FREETYPE_BUILD_DIR)/builds/unix/libtool \
	DESTDIR=$(SYSROOT) install
	$(MAKE) libtool_files_adapt
	$(MAKE) pkgconfig_files_adapt
	@touch $@

download_freetype:
	$(call EMBTK_DOWNLOAD_PKG,FREETYPE)

$(FREETYPE_BUILD_DIR)/.decompressed:
	$(call EMBTK_DECOMPRESS_PKG,FREETYPE)

$(FREETYPE_BUILD_DIR)/.configured:
	$(call EMBTK_CONFIGURE_PKG,FREETYPE)

freetype_clean:
	$(call EMBTK_CLEANUP_PKG,FREETYPE)
