################################################################################
# Embtoolkit
# Copyright(C) 2012 Abdoulaye Walsimou GAYE.
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
# \file         libbsd.mk
# \brief	libbsd.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2012
################################################################################

LIBBSD_NAME		:= libbsd
LIBBSD_VERSION		:= $(call embtk_get_pkgversion,libbsd)
LIBBSD_SITE		:= http://libbsd.freedesktop.org/releases
LIBBSD_PACKAGE		:= libbsd-$(LIBBSD_VERSION).tar.gz
LIBBSD_SRC_DIR		:= $(PACKAGES_BUILD)/libbsd-$(LIBBSD_VERSION)
LIBBSD_BUILD_DIR	:= $(PACKAGES_BUILD)/libbsd-$(LIBBSD_VERSION)

LIBBSD_INCLUDES		:= bsd
LIBBSD_LIBS		:= libbsd*
LIBBSD_PKGCONFIGS	:= libbsd*.pc

LIBBSD_MAKE_OPTS	:= CC=$(TARGETCC_CACHED) AR=$(TARGETAR)
LIBBSD_MAKE_OPTS	+= CFLAGS="$(TARGET_CFLAGS)"

libbsd_install:
	$(call embtk_makeinstall_pkg,libbsd)
