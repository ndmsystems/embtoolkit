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
# \file         libxkbfile.mk
# \brief	libxkbfile.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         February 2010
################################################################################

LIBXKBFILE_NAME := libxkbfile
LIBXKBFILE_VERSION := $(call EMBTK_GET_PKG_VERSION,LIBXKBFILE)
LIBXKBFILE_SITE := http://xorg.freedesktop.org/archive/individual/lib
LIBXKBFILE_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
LIBXKBFILE_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/libxkbfile/$(LIBXKBFILE_VERSION)
LIBXKBFILE_PACKAGE := libxkbfile-$(LIBXKBFILE_VERSION).tar.bz2
LIBXKBFILE_SRC_DIR := $(PACKAGES_BUILD)/libxkbfile-$(LIBXKBFILE_VERSION)
LIBXKBFILE_BUILD_DIR := $(PACKAGES_BUILD)/libxkbfile-$(LIBXKBFILE_VERSION)

LIBXKBFILE_BINS =
LIBXKBFILE_SBINS =
LIBXKBFILE_INCLUDES = X11/extensions/XKBbells.h X11/extensions/XKBconfig.h \
		X11/extensions/XKBfile.h X11/extensions/XKBrules.h \
		X11/extensions/XKMformat.h X11/extensions/XKM.h
LIBXKBFILE_LIBS = libxkbfile.*
LIBXKBFILE_PKGCONFIGS =

LIBXKBFILE_DEPS = kbproto_install libx11_install

libxkbfile_install:
	$(call EMBTK_INSTALL_PKG,LIBXKBFILE)

download_libxkbfile:
	$(call EMBTK_DOWNLOAD_PKG,LIBXKBFILE)

libxkbfile_clean:
	$(call EMBTK_CLEANUP_PKG,LIBXKBFILE)
