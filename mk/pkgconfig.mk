################################################################################
# Copyright(C) 2009-2012 Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
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
PKGCONFIG_VERSION	:= $(call embtk_get_pkgversion,pkgconfig)
PKGCONFIG_SITE		:= http://pkgconfig.freedesktop.org/releases
PKGCONFIG_PACKAGE	:= pkg-config-$(PKGCONFIG_VERSION).tar.gz
PKGCONFIG_SRC_DIR	:= $(TOOLS_BUILD)/pkg-config-$(PKGCONFIG_VERSION)
PKGCONFIG_BUILD_DIR	:= $(TOOLS_BUILD)/pkg-config-$(PKGCONFIG_VERSION)

PKGCONFIG_BIN			:= $(HOSTTOOLS)/usr/bin/pkg-config

__EMBTK_PKG_CONFIG_PATH		:= $(embtk_sysroot)/usr/$(LIBDIR)/pkgconfig
__EMBTK_PKG_CONFIG_PATH		+= $(embtk_sysroot)/usr/share/pkgconfig
EMBTK_PKG_CONFIG_PATH		:= $(subst $(embtk_space),:,$(__EMBTK_PKG_CONFIG_PATH))
EMBTK_PKG_CONFIG_LIBDIR		:= $(EMBTK_PKG_CONFIG_PATH)

__EMBTK_HOST_PKG_CONFIG_PATH	:= $(HOSTTOOLS)/usr/lib/pkgconfig/
__EMBTK_HOST_PKG_CONFIG_PATH	+= /usr/lib/pkgconfig/ /usr/share/pkgconfig/
__EMBTK_HOST_PKG_CONFIG_PATH	+= /usr/local/lib/pkgconfig/ /usr/local/share/pkgconfig/
__EMBTK_HOST_PKG_CONFIG_PATH	+= $(dir $(shell find /usr/lib -type f -name '*.pc'))
__EMBTK_HOST_PKG_CONFIG_PATH	+= $(dir $(shell find /usr/local/lib -type f -name '*.pc'))
EMBTK_HOST_PKG_CONFIG_PATH	:= $(subst $(embtk_space),:,$(sort $(__EMBTK_HOST_PKG_CONFIG_PATH)))

PKGCONFIG_CONFIGURE_OPTS	:= --with-pc-path="$(EMBTK_HOST_PKG_CONFIG_PATH)"
PKGCONFIG_CONFIGURE_OPTS	+= --with-internal-glib

export PKGCONFIG_BIN EMBTK_PKG_CONFIG_PATH EMBTK_PKG_CONFIG_LIBDIR
export EMBTK_HOST_PKG_CONFIG_PATH

PKGCONFIG_PREFIX	:= /usr
PKGCONFIG_DESTDIR	:= $(HOSTTOOLS)

pkgconfig_install:
	$(call embtk_install_hostpkg,pkgconfig)
