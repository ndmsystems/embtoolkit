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
# \file         utilmacros.mk
# \brief	utilmacros.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

UTILMACROS_NAME := util-macro
UTILMACROS_VERSION := $(call EMBTK_GET_PKG_VERSION,UTILMACROS)
UTILMACROS_SITE := http://xorg.freedesktop.org/archive/individual/util
UTILMACROS_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
UTILMACROS_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/util-macro/$(UTILMACROS_VERSION)
UTILMACROS_PACKAGE := util-macros-$(UTILMACROS_VERSION).tar.bz2
UTILMACROS_SRC_DIR := $(PACKAGES_BUILD)/util-macros-$(UTILMACROS_VERSION)
UTILMACROS_BUILD_DIR := $(PACKAGES_BUILD)/util-macros-$(UTILMACROS_VERSION)

UTILMACROS_BINS =
UTILMACROS_SBINS =
UTILMACROS_INCLUDES =
UTILMACROS_LIBS =
UTILMACROS_PKGCONFIGS = xorg-macros.pc

UTILMACROS_CONFIGURE_OPTS := --disable-malloc0returnsnull

utilmacros_install:
	$(call EMBTK_INSTALL_PKG,UTILMACROS) && \
	cp $(SYSROOT)/usr/share/pkgconfig/xorg-macros.pc $(EMBTK_PKG_CONFIG_PATH) \
	&& $(MAKE) pkgconfig_files_adapt

download_utilmacros:
	$(call EMBTK_DOWNLOAD_PKG,UTILMACROS)

utilmacros_clean:
	$(call EMBTK_CLEANUP_PKG,UTILMACROS)
