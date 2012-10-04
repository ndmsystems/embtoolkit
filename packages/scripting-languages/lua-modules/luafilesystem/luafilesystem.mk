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
# \file         luafilesystem.mk
# \brief	luafilesystem.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         April 2012
################################################################################

LUAFILESYSTEM_NAME	:= luafilesystem
LUAFILESYSTEM_VERSION	:= $(call embtk_get_pkgversion,luafilesystem)
LUAFILESYSTEM_SITE	:= https://github.com/downloads/keplerproject/luafilesystem
LUAFILESYSTEM_PACKAGE	:= luafilesystem-$(LUAFILESYSTEM_VERSION).tar.gz
LUAFILESYSTEM_SRC_DIR	:= $(embtk_pkgb)/luafilesystem-$(LUAFILESYSTEM_VERSION)
LUAFILESYSTEM_BUILD_DIR	:= $(embtk_pkgb)/luafilesystem-$(LUAFILESYSTEM_VERSION)

LUAFILESYSTEM_LIBS		=

LUAFILESYSTEM_DEPS		= lua_install

LUAFILESYSTEM_MAKE_OPTS		= PREFIX=$(embtk_sysroot)/usr/ LIBDIR=$(LIBDIR)
LUAFILESYSTEM_MAKE_OPTS		+= CC=$(TARGETCC_CACHED)
LUAFILESYSTEM_MAKE_OPTS		+= LDFLAGS="-L$(embtk_sysroot)/$(LIBDIR) -L$(embtk_sysroot)/usr/$(LIBDIR)"
LUAFILESYSTEM_MAKE_OPTS		+= CFLAGS="$(TARGET_CFLAGS) -I$(embtk_sysroot)/usr/include"

luafilesystem_install:
	$(call embtk_makeinstall_pkg,luafilesystem)

define embtk_postinstall_luafilesystem
	$(Q)mkdir -p $(embtk_rootfs)
	$(Q)mkdir -p $(embtk_rootfs)/usr
	$(Q)mkdir -p $(embtk_rootfs)/usr/$(LIBDIR)
	$(Q)cp -R $(embtk_sysroot)/usr/$(LIBDIR)/lua $(embtk_rootfs)/usr/$(LIBDIR)/
endef
