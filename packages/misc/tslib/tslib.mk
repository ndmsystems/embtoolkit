################################################################################
# Embtoolkit
# Copyright(C) 2010-2011 Abdoulaye Walsimou GAYE. All rights reserved.
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
# \file         tslib.mk
# \brief	tslib.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

TSLIB_NAME := tslib
TSLIB_VERSION := $(call EMBTK_GET_PKG_VERSION,TSLIB)
TSLIB_SITE := http://download.berlios.de/tslib
TSLIB_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
TSLIB_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/tslib/$(TSLIB_VERSION)
TSLIB_PACKAGE := tslib-$(TSLIB_VERSION).tar.bz2
TSLIB_SRC_DIR := $(PACKAGES_BUILD)/tslib-$(TSLIB_VERSION)
TSLIB_BUILD_DIR := $(PACKAGES_BUILD)/tslib-$(TSLIB_VERSION)

TSLIB_BINS = ts_calibrate ts_harvest ts_print ts_print_raw ts_test
TSLIB_SBINS =
TSLIB_INCLUDES = tslib.h
TSLIB_LIBS = libts* ts
TSLIB_PKGCONFIGS = tslib-*.pc

TSLIB_DEPS =

tslib_install:
	@test -e $(TSLIB_BUILD_DIR)/.installed || \
	$(MAKE) $(TSLIB_BUILD_DIR)/.installed
	$(Q)$(MAKE) $(TSLIB_BUILD_DIR)/.special

$(TSLIB_BUILD_DIR)/.installed: $(TSLIB_DEPS) download_tslib \
	$(TSLIB_BUILD_DIR)/.decompressed $(TSLIB_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	tslib-$(TSLIB_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(TSLIB_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(TSLIB_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_tslib:
	$(call EMBTK_DOWNLOAD_PKG,TSLIB)

$(TSLIB_BUILD_DIR)/.decompressed:
	$(call EMBTK_DECOMPRESS_PKG,TSLIB)

$(TSLIB_BUILD_DIR)/.configured:
	$(call EMBTK_CONFIGURE_PKG,TSLIB)

tslib_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup tslib-$(TSLIB_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(TSLIB_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(TSLIB_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(TSLIB_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(TSLIB_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(TSLIB_PKGCONFIGS)
	$(Q)-rm -rf $(TSLIB_BUILD_DIR)*


.PHONY: $(TSLIB_BUILD_DIR)/.special

$(TSLIB_BUILD_DIR)/.special:
	$(Q)-cp -R $(SYSROOT)/usr/$(LIBDIR)/ts $(ROOTFS)/usr/$(LIBDIR)/
	@touch $@
