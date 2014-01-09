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
# \file         cgilua.mk
# \brief	cgilua.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         April 2012
################################################################################

CGILUA_NAME		:= cgilua
CGILUA_VERSION		:= $(call embtk_get_pkgversion,cgilua)
CGILUA_SITE		:= https://github.com/downloads/keplerproject/cgilua
CGILUA_PACKAGE		:= cgilua-$(CGILUA_VERSION).tar.gz
CGILUA_SRC_DIR		:= $(embtk_pkgb)/cgilua-$(CGILUA_VERSION)
CGILUA_BUILD_DIR	:= $(embtk_pkgb)/cgilua-$(CGILUA_VERSION)

CGILUA_LIBS		=

CGILUA_DEPS		= lua_install luafilesystem_install rings_install

CGILUA_MAKE_OPTS	= PREFIX=$(embtk_sysroot)/usr/

define embtk_install_cgilua
	$(call embtk_makeinstall_pkg,cgilua)
endef

define embtk_postinstall_cgilua
	$(Q)mkdir -p $(embtk_rootfs)
	$(Q)mkdir -p $(embtk_rootfs)/usr
	$(Q)mkdir -p $(embtk_rootfs)/usr/share
	$(Q)cp -R $(embtk_sysroot)/usr/share/lua $(embtk_rootfs)/usr/share/
endef
