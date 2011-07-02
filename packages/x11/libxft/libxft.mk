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
# \file         libxft.mk
# \brief	libxft.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         June 2010
################################################################################

LIBXFT_NAME := libXft
LIBXFT_VERSION := $(call embtk_get_pkgversion,LIBXFT)
LIBXFT_SITE := http://xorg.freedesktop.org/archive/individual/lib
LIBXFT_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
LIBXFT_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/libxft/$(LIBXFT_VERSION)
LIBXFT_PACKAGE := libXft-$(LIBXFT_VERSION).tar.bz2
LIBXFT_SRC_DIR := $(PACKAGES_BUILD)/libXft-$(LIBXFT_VERSION)
LIBXFT_BUILD_DIR := $(PACKAGES_BUILD)/libXft-$(LIBXFT_VERSION)

LIBXFT_BINS = xft-config
LIBXFT_SBINS =
LIBXFT_INCLUDES = X11/xft
LIBXFT_LIBS = libXft.*
LIBXFT_PKGCONFIGS = xft.pc

LIBXFT_CONFIGURE_OPTS := --disable-malloc0returnsnull

LIBXFT_DEPS = freetype_install fontconfig_install libxrender_install

libxft_install:
	$(call embtk_install_pkg,LIBXFT)

download_libxft:
	$(call embtk_download_pkg,LIBXFT)

libxft_clean:
	$(call embtk_cleanup_pkg,LIBXFT)
