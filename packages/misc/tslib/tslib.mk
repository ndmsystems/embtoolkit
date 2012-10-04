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
# \file         tslib.mk
# \brief	tslib.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

TSLIB_NAME		:= tslib
TSLIB_VERSION		:= $(call embtk_get_pkgversion,tslib)
TSLIB_SITE		:= http://download.berlios.de/tslib
TSLIB_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
TSLIB_PACKAGE		:= tslib-$(TSLIB_VERSION).tar.bz2
TSLIB_SRC_DIR		:= $(PACKAGES_BUILD)/tslib-$(TSLIB_VERSION)
TSLIB_BUILD_DIR		:= $(PACKAGES_BUILD)/tslib-$(TSLIB_VERSION)

TSLIB_BINS		= ts_calibrate ts_harvest ts_print ts_print_raw ts_test
TSLIB_SBINS		=
TSLIB_INCLUDES		= tslib.h
TSLIB_LIBS		= libts* ts
TSLIB_PKGCONFIGS	= tslib*.pc

TSLIB_DEPS =

define embtk_postinstall_tslib
	$(Q)-cp -R $(embtk_sysroot)/usr/$(LIBDIR)/ts $(embtk_rootfs)/usr/$(LIBDIR)/
endef
