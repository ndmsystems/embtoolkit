################################################################################
# Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# Copyright(C) 2009-2011 Abdoulaye Walsimou GAYE.
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
# \file         pkgconfig.mk
# \brief	pkgconfig.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         October 2009
################################################################################

PKGCONFIG_NAME		:= pkg-config
PKGCONFIG_VERSION	:= $(call EMBTK_GET_PKG_VERSION,PKGCONFIG)
PKGCONFIG_SITE		:= http://pkgconfig.freedesktop.org/releases
PKGCONFIG_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
PKGCONFIG_PATCH_SITE	:= ftp://ftp.embtoolkit.org/embtoolkit.org/pkgconfig/$(PKGCONFIG_VERSION)
PKGCONFIG_PACKAGE	:= pkg-config-$(PKGCONFIG_VERSION).tar.gz
PKGCONFIG_SRC_DIR	:= $(TOOLS_BUILD)/pkg-config-$(PKGCONFIG_VERSION)
PKGCONFIG_BUILD_DIR	:= $(TOOLS_BUILD)/pkg-config-$(PKGCONFIG_VERSION)

PKGCONFIG_BIN	:=  $(HOSTTOOLS)/usr/bin/pkg-config
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
PKG_CONFIG_PATH	:=$(SYSROOT)/usr/lib32/pkgconfig
else
PKG_CONFIG_PATH	:=$(SYSROOT)/usr/lib/pkgconfig
endif
export PKGCONFIG_BIN PKG_CONFIG_PATH

pkgconfig_install:
	$(call EMBTK_INSTALL_HOSTPKG,PKGCONFIG)

download_pkgconfig:
	$(call EMBTK_DOWNLOAD_PKG,PKGCONFIG)
