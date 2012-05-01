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
CGILUA_SRC_DIR		:= $(PACKAGES_BUILD)/cgilua-$(CGILUA_VERSION)
CGILUA_BUILD_DIR	:= $(PACKAGES_BUILD)/cgilua-$(CGILUA_VERSION)

CGILUA_LIBS		=

CGILUA_DEPS		= lua_install luafilesystem_install rings_install

CGILUA_MAKE_OPTS	= PREFIX=$(SYSROOT)/usr/

cgilua_install:
	$(call embtk_makeinstall_pkg,cgilua)

define embtk_postinstall_cgilua
	$(Q)mkdir -p $(ROOTFS)
	$(Q)mkdir -p $(ROOTFS)/usr
	$(Q)mkdir -p $(ROOTFS)/usr/share
	$(Q)cp -R $(SYSROOT)/usr/share/lua $(ROOTFS)/usr/share/
endef