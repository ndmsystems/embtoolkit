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
# \file         bigreqsproto.mk
# \brief	bigreqsproto.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         February 2010
################################################################################

BIGREQSPROTO_NAME := bigreqsproto
BIGREQSPROTO_VERSION := $(call EMBTK_GET_PKG_VERSION,BIGREQSPROTO)
BIGREQSPROTO_SITE := http://xorg.freedesktop.org/archive/individual/proto
BIGREQSPROTO_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
BIGREQSPROTO_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/bigreqsprot/$(BIGREQSPROTO_VERSION)
BIGREQSPROTO_PACKAGE := bigreqsproto-$(BIGREQSPROTO_VERSION).tar.bz2
BIGREQSPROTO_SRC_DIR := $(PACKAGES_BUILD)/bigreqsproto-$(BIGREQSPROTO_VERSION)
BIGREQSPROTO_BUILD_DIR := $(PACKAGES_BUILD)/bigreqsproto-$(BIGREQSPROTO_VERSION)

BIGREQSPROTO_BINS =
BIGREQSPROTO_SBINS =
BIGREQSPROTO_INCLUDES = X11/extensions/bigreqsproto.h X11/extensions/bigreqstr.h
BIGREQSPROTO_LIBS =
BIGREQSPROTO_PKGCONFIGS = bigreqsproto.pc

bigreqsproto_install:
	$(call EMBTK_INSTALL_PKG,BIGREQSPROTO)

download_bigreqsproto:
	$(call EMBTK_DOWNLOAD_PKG,BIGREQSPROTO)

bigreqsproto_clean:
	$(call EMBTK_CLEANUP_PKG,BIGREQSPROTO)
