################################################################################
# Copyright(C) 2013 Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
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
# \file         pkgconf.mk
# \brief	pkgconf.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         January 2013
################################################################################

PKGCONF_NAME		:= pkgconf
PKGCONF_VERSION		:= $(call embtk_get_pkgversion,pkgconf)
PKGCONF_SITE		:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
PKGCONF_PACKAGE		:= pkgconf-$(PKGCONF_VERSION).tar.gz
PKGCONF_SRC_DIR		:= $(embtk_toolsb)/pkgconf-$(PKGCONF_VERSION)
PKGCONF_BUILD_DIR	:= $(embtk_toolsb)/pkgconf-$(PKGCONF_VERSION)

PKGCONFIG_BIN		:= $(embtk_htools)/usr/bin/pkg-config
export PKGCONFIG_BIN

#
# PKG_CONFIG_PATH for target packages
#
__EMBTK_PKG_CONFIG_PATH		:= $(embtk_sysroot)/usr/$(LIBDIR)/pkgconfig
__EMBTK_PKG_CONFIG_PATH		+= $(embtk_sysroot)/usr/share/pkgconfig
EMBTK_PKG_CONFIG_PATH		:= $(subst $(embtk_space),:,$(__EMBTK_PKG_CONFIG_PATH))
EMBTK_PKG_CONFIG_LIBDIR		:= $(EMBTK_PKG_CONFIG_PATH)

export PKGCONFIG_BIN EMBTK_PKG_CONFIG_PATH

#
# PKG_CONFIG_PATH for host packages
#
__EMBTK_HOST_PKG_CONFIG_PATH	:= $(embtk_htools)/usr/lib/pkgconfig/
__EMBTK_HOST_PKG_CONFIG_PATH	+= /usr/lib/pkgconfig/ /usr/share/pkgconfig/
__EMBTK_HOST_PKG_CONFIG_PATH	+= /usr/local/lib/pkgconfig/ /usr/local/share/pkgconfig/
__EMBTK_HOST_PKG_CONFIG_PATH	+= $(dir $(shell find /usr/lib -type f -name '*.pc' 2>/dev/null))
__EMBTK_HOST_PKG_CONFIG_PATH	+= $(dir $(shell find /usr/local/lib -type f -name '*.pc' 2>/dev/null))
EMBTK_HOST_PKG_CONFIG_PATH	:= $(subst $(embtk_space),:,$(sort $(__EMBTK_HOST_PKG_CONFIG_PATH)))

export EMBTK_HOST_PKG_CONFIG_PATH

#
# pkgconf install
#
PKGCONF_PREFIX	:= /usr
PKGCONF_DESTDIR	:= $(embtk_htools)

define embtk_install_pkgconf
	$(call __embtk_install_hostpkg,pkgconf)
endef

define embtk_postinstallonce_pkgconf
	cd $(embtk_htools)/usr/bin/; ln -sf pkgconf pkg-config
endef
