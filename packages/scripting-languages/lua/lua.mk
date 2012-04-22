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
# \file         lua.mk
# \brief	lua.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         June 2010
################################################################################

LUA_NAME	:= lua
LUA_VERSION	:= $(call embtk_get_pkgversion,lua)
LUA_SITE	:= http://www.lua.org/ftp
LUA_PACKAGE	:= lua-$(LUA_VERSION).tar.gz
LUA_SRC_DIR	:= $(PACKAGES_BUILD)/lua-$(LUA_VERSION)
LUA_BUILD_DIR	:= $(PACKAGES_BUILD)/lua-$(LUA_VERSION)

LUA_BINS	= lua luac
LUA_SBINS	=
LUA_INCLUDES	= lauxlib.h luaconf.h lua.h lua.hpp lualib.h
LUA_LIBS	= lua liblua.*
LUA_PKGCONFIGS	= lua.pc
LUA_SHARES	= lua

LUA_DEPS	=
LUACONF_H_OPTS	= -DCONFIG_LUA_ROOT="/usr/" -DCONFIG_SYSTEM_LIBDIR="$(LIBDIR)/"
LUACONF_H_OPTS	+= -DLUA_USE_DLOPEN

LUA_MAKE_OPTS	= INSTALL_TOP=$(SYSROOT)/usr/ LIBDIR=$(LIBDIR) PLAT=ansi

lua_install:
	$(call embtk_makeinstall_pkg,lua)

define embtk_beforeinstall_lua
	$(Q)$(MAKE) -C $(LUA_BUILD_DIR) CC=$(TARGETCC_CACHED)			\
	AR="$(TARGETAR) rcu" RANLIB=$(TARGETRANLIB)				\
	LDFLAGS="-L$(SYSROOT)/$(LIBDIR) -L$(SYSROOT)/usr/$(LIBDIR) -ldl"	\
	CFLAGS="$(TARGET_CFLAGS) -I$(SYSROOT)/usr/include $(LUACONF_H_OPTS)"	\
	PLAT=ansi
endef

define embtk_postinstall_lua
	$(Q)mkdir -p $(ROOTFS)
	$(Q)mkdir -p $(ROOTFS)/usr
	$(Q)mkdir -p $(ROOTFS)/usr/$(LIBDIR)
	$(Q)mkdir -p $(ROOTFS)/usr/share
	$(Q)cp -R $(SYSROOT)/usr/$(LIBDIR)/lua $(ROOTFS)/usr/$(LIBDIR)/
	$(Q)cp -R $(SYSROOT)/usr/share/lua $(ROOTFS)/usr/share/
endef
