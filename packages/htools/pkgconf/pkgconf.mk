################################################################################
# Copyright(C) 2013-2014 Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
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

PKGCONF_HOST_NAME		:= pkgconf
PKGCONF_HOST_VERSION		:= $(call embtk_get_pkgversion,pkgconf_host)
PKGCONF_HOST_SITE		:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
PKGCONF_HOST_PACKAGE		:= pkgconf-$(PKGCONF_HOST_VERSION).tar.gz
PKGCONF_HOST_SRC_DIR		:= $(embtk_toolsb)/pkgconf-$(PKGCONF_HOST_VERSION)
PKGCONF_HOST_BUILD_DIR		:= $(embtk_toolsb)/pkgconf-$(PKGCONF_HOST_VERSION)

PKGCONFIG_BIN		:= $(embtk_htools)/usr/bin/pkg-config
export PKGCONFIG_BIN

#
# pkgconf install
#
PKGCONF_HOST_PREFIX	:= /usr
PKGCONF_HOST_DESTDIR	:= $(embtk_htools)

define embtk_postinstallonce_pkgconf_host
	cd $(embtk_htools)/usr/bin/; ln -sf pkgconf pkg-config
endef
