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
# \file         libxi.mk
# \brief	libxi.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         September 2010
################################################################################

LIBXI_NAME := libXi
LIBXI_VERSION := $(call EMBTK_GET_PKG_VERSION,LIBXI)
LIBXI_SITE := http://xorg.freedesktop.org/archive/individual/lib
LIBXI_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
LIBXI_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/libxi/$(LIBXI_VERSION)
LIBXI_PACKAGE := libXi-$(LIBXI_VERSION).tar.bz2
LIBXI_SRC_DIR := $(PACKAGES_BUILD)/libXi-$(LIBXI_VERSION)
LIBXI_BUILD_DIR := $(PACKAGES_BUILD)/libXi-$(LIBXI_VERSION)

LIBXI_BINS =
LIBXI_SBINS =
LIBXI_INCLUDES = X11/extensions/XInput.h X11/extensions/XInput2.h
LIBXI_LIBS = libXi.*
LIBXI_PKGCONFIGS = xi.pc

LIBXI_CONFIGURE_OPTS := --disable-malloc0returnsnull

LIBXI_DEPS := xproto_install xextproto_install inputproto_install \
	libx11_install libxext_install

libxi_install:
	$(call EMBTK_INSTALL_PKG,LIBXI)

download_libxi:
	$(call EMBTK_DOWNLOAD_PKG,LIBXI)

libxi_clean:
	$(call EMBTK_CLEANUP_PKG,LIBXI)
