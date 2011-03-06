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
# \file         atk.mk
# \brief	atk.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

ATK_NAME := atk
ATK_VERSION := $(call EMBTK_GET_PKG_VERSION,ATK)
ATK_MAJOR_VERSION := $(call EMBTK_GET_PKG_VERSION,ATK_MAJOR)
ATK_SITE := http://ftp.gnome.org/pub/gnome/sources/atk/$(ATK_MAJOR_VERSION)
ATK_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
ATK_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/atk/$(ATK_VERSION)
ATK_PACKAGE := atk-$(ATK_VERSION).tar.bz2
ATK_SRC_DIR := $(PACKAGES_BUILD)/atk-$(ATK_VERSION)
ATK_BUILD_DIR := $(PACKAGES_BUILD)/atk-$(ATK_VERSION)

ATK_BINS =
ATK_SBINS =
ATK_INCLUDES = atk-*
ATK_LIBS = libatk-*
ATK_PKGCONFIGS = atk.pc

atk_install:
	$(call EMBTK_INSTALL_PKG,ATK)

download_atk:
	$(call EMBTK_DOWNLOAD_PKG,ATK)

atk_clean:
	$(call EMBTK_CLEANUP_PKG,ATK)
