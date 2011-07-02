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
# \file         libpng.mk
# \brief	libpng.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         October 2009
################################################################################

LIBPNG_NAME := libpng
LIBPNG_VERSION := $(call embtk_get_pkgversion,LIBPNG)
LIBPNG_SITE := http://download.sourceforge.net/libpng
LIBPNG_PACKAGE := libpng-$(LIBPNG_VERSION).tar.gz
LIBPNG_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
LIBPNG_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/libpng/$(LIBPNG_VERSION)
LIBPNG_SRC_DIR := $(PACKAGES_BUILD)/libpng-$(LIBPNG_VERSION)
LIBPNG_BUILD_DIR := $(PACKAGES_BUILD)/libpng-$(LIBPNG_VERSION)

LIBPNG_BINS = libpng*
LIBPNG_SBINS =
LIBPNG_INCLUDES = libpng* png*
LIBPNG_LIBS = libpng*
LIBPNG_PKGCONFIGS = libpng*

LIBPNG_CONFIGURE_OPTS := --with-libpng-compat=no

LIBPNG_DEPS := zlib_install

libpng_install:
	@test -e $(LIBPNG_BUILD_DIR)/.installed || \
	$(MAKE) $(LIBPNG_BUILD_DIR)/.installed

$(LIBPNG_BUILD_DIR)/.installed:  $(LIBPNG_DEPS) download_libpng \
	$(LIBPNG_BUILD_DIR)/.decompressed $(LIBPNG_BUILD_DIR)/.configured
	$(call embtk_generic_message,"Compiling and installing \
	libpng-$(LIBPNG_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(LIBPNG_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBPNG_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_libpng:
	$(call embtk_download_pkg,LIBPNG)

$(LIBPNG_BUILD_DIR)/.decompressed:
	$(call embtk_decompress_pkg,LIBPNG)

$(LIBPNG_BUILD_DIR)/.configured:
	$(call embtk_configure_pkg,LIBPNG)

libpng_clean:
	$(call embtk_cleanup_pkg,LIBPNG)
