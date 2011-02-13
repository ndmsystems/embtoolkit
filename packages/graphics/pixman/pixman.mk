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
# \file         pixman.mk
# \brief	pixman.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

PIXMAN_NAME := pixman
PIXMAN_VERSION := $(call EMBTK_GET_PKG_VERSION,PIXMAN)
PIXMAN_SITE := http://www.cairographics.org/releases
PIXMAN_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
PIXMAN_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/pixman/$(PIXMAN_VERSION)
PIXMAN_PACKAGE := pixman-$(PIXMAN_VERSION).tar.gz
PIXMAN_SRC_DIR := $(PACKAGES_BUILD)/pixman-$(PIXMAN_VERSION)
PIXMAN_BUILD_DIR := $(PACKAGES_BUILD)/pixman-$(PIXMAN_VERSION)

PIXMAN_BINS =
PIXMAN_SBINS =
PIXMAN_INCLUDES = pixman-*
PIXMAN_LIBS = libpixman-*
PIXMAN_PKGCONFIGS = pixman-*.pc

pixman_install:
	@test -e $(PIXMAN_BUILD_DIR)/.installed || \
	$(MAKE) $(PIXMAN_BUILD_DIR)/.installed

$(PIXMAN_BUILD_DIR)/.installed: download_pixman \
	$(PIXMAN_BUILD_DIR)/.decompressed $(PIXMAN_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	pixman-$(PIXMAN_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(PIXMAN_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(PIXMAN_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_pixman:
	$(call EMBTK_DOWNLOAD_PKG,PIXMAN)

$(PIXMAN_BUILD_DIR)/.decompressed:
	$(call EMBTK_DECOMPRESS_PKG,PIXMAN)

$(PIXMAN_BUILD_DIR)/.configured:
	$(call EMBTK_CONFIGURE_PKG,PIXMAN)

pixman_clean:
	$(call EMBTK_CLEANUP_PKG,PIXMAN)
