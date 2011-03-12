################################################################################
# Embtoolkit
# Copyright(C) 2010-2011 Abdoulaye Walsimou GAYE.
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
# \file         libxcomposite.mk
# \brief	libxcomposite.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         June 2010
################################################################################

LIBXCOMPOSITE_NAME := libXcomposite
LIBXCOMPOSITE_VERSION := $(call EMBTK_GET_PKG_VERSION,LIBXCOMPOSITE)
LIBXCOMPOSITE_SITE := http://xorg.freedesktop.org/archive/individual/lib
LIBXCOMPOSITE_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/libxcomposite/$(LIBXCOMPOSITE_VERSION)
LIBXCOMPOSITE_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
LIBXCOMPOSITE_PACKAGE := libXcomposite-$(LIBXCOMPOSITE_VERSION).tar.bz2
LIBXCOMPOSITE_SRC_DIR := $(PACKAGES_BUILD)/libXcomposite-$(LIBXCOMPOSITE_VERSION)
LIBXCOMPOSITE_BUILD_DIR := $(PACKAGES_BUILD)/libXcomposite-$(LIBXCOMPOSITE_VERSION)

LIBXCOMPOSITE_BINS =
LIBXCOMPOSITE_SBINS =
LIBXCOMPOSITE_INCLUDES = X11/extensions/Xcomposite.h
LIBXCOMPOSITE_LIBS = libXcomposite.*
LIBXCOMPOSITE_PKGCONFIGS = xcomposite.pc

LIBXCOMPOSITE_DEPS = xproto_install libxfixes_install compositeproto_install

libxcomposite_install:
	@test -e $(LIBXCOMPOSITE_BUILD_DIR)/.installed || \
	$(MAKE) $(LIBXCOMPOSITE_BUILD_DIR)/.installed

$(LIBXCOMPOSITE_BUILD_DIR)/.installed: $(LIBXCOMPOSITE_DEPS) download_libxcomposite \
	$(LIBXCOMPOSITE_BUILD_DIR)/.decompressed $(LIBXCOMPOSITE_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	libxcomposite-$(LIBXCOMPOSITE_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(LIBXCOMPOSITE_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBXCOMPOSITE_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_libxcomposite:
	$(call EMBTK_DOWNLOAD_PKG,LIBXCOMPOSITE)

$(LIBXCOMPOSITE_BUILD_DIR)/.decompressed:
	$(call EMBTK_DECOMPRESS_PKG,LIBXCOMPOSITE)

$(LIBXCOMPOSITE_BUILD_DIR)/.configured:
	$(call EMBTK_CONFIGURE_PKG,LIBXCOMPOSITE)

libxcomposite_clean:
	$(call EMBTK_CLEANUP_PKG,LIBXCOMPOSITE)
