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
# \file         libxfixes.mk
# \brief	libxfixes.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         June 2010
################################################################################

LIBXFIXES_NAME := libXfixes
LIBXFIXES_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_LIBXFIXES_VERSION_STRING)))
LIBXFIXES_SITE := http://xorg.freedesktop.org/archive/individual/lib
LIBXFIXES_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
LIBXFIXES_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/libxfixes/$(LIBXFIXES_VERSION)
LIBXFIXES_PACKAGE := libXfixes-$(LIBXFIXES_VERSION).tar.bz2
LIBXFIXES_SRC_DIR := $(PACKAGES_BUILD)/libXfixes-$(LIBXFIXES_VERSION)
LIBXFIXES_BUILD_DIR := $(PACKAGES_BUILD)/libXfixes-$(LIBXFIXES_VERSION)

LIBXFIXES_BINS =
LIBXFIXES_SBINS =
LIBXFIXES_INCLUDES = X11/extensions/Xfixes.h
LIBXFIXES_LIBS = libXfixes.*
LIBXFIXES_PKGCONFIGS =xfixes.pc

LIBXFIXES_DEPS = xproto_install fixesproto_install

libxfixes_install:
	@test -e $(LIBXFIXES_BUILD_DIR)/.installed || \
	$(MAKE) $(LIBXFIXES_BUILD_DIR)/.installed

$(LIBXFIXES_BUILD_DIR)/.installed: $(LIBXFIXES_DEPS) download_libxfixes \
	$(LIBXFIXES_BUILD_DIR)/.decompressed $(LIBXFIXES_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	libxfixes-$(LIBXFIXES_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(LIBXFIXES_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBXFIXES_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_libxfixes:
	$(call EMBTK_DOWNLOAD_PKG,LIBXFIXES)

$(LIBXFIXES_BUILD_DIR)/.decompressed:
	$(call EMBTK_DECOMPRESS_PKG,LIBXFIXES)

$(LIBXFIXES_BUILD_DIR)/.configured:
	$(call EMBTK_CONFIGURE_PKG,LIBXFIXES)

libxfixes_clean:
	$(call EMBTK_CLEANUP_PKG,LIBXFIXES)
