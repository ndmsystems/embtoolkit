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
LUA_SITE	:= ftp://ftp.embtoolkit.org/embtoolkit.org/lua
LUA_PACKAGE	:= lua-$(LUA_VERSION).tar.bz2
LUA_SRC_DIR	:= $(PACKAGES_BUILD)/lua-$(LUA_VERSION)
LUA_BUILD_DIR	:= $(PACKAGES_BUILD)/lua-$(LUA_VERSION)

LUA_BINS	= lua luac
LUA_SBINS	=
LUA_INCLUDES	= lauxlib.h luaconf.h lua.h lua.hpp lualib.h
LUA_LIBS	= lua liblua.*
LUA_PKGCONFIGS	=

LUA_DEPS	=

LUA_MAKE_OPTS	= INSTALL_TOP=$(SYSROOT)/usr/ LIBDIR=$(LIBDIR)

define embtk_beforeinstall_lua
	$(Q)$(MAKE) -C $(LUA_BUILD_DIR) CC=$(TARGETCC_CACHED)			\
		AR="$(TARGETAR) rcu" RANLIB=$(TARGETRANLIB)			\
		LDFLAGS="-L$(SYSROOT)/$(LIBDIR) -L$(SYSROOT)/usr/$(LIBDIR)"	\
		CFLAGS="$(TARGET_CFLAGS) -I$(SYSROOT)/usr/include" ansi
endef
