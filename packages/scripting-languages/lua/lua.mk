################################################################################
# Embtoolkit
# Copyright(C) 2010 Abdoulaye Walsimou GAYE. All rights reserved.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
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

LUA_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_LUA_VERSION_STRING)))
LUA_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/lua
LUA_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/lua/$(LUA_VERSION)
LUA_PACKAGE := lua-$(LUA_VERSION).tar.bz2
LUA_BUILD_DIR := $(PACKAGES_BUILD)/lua-$(LUA_VERSION)

LUA_BINS = lua luac
LUA_SBINS =
LUA_INCLUDES = lauxlib.h luaconf.h lua.h lua.hpp lualib.h
LUA_LIBS = lua liblua.*
LUA_PKGCONFIGS =

LUA_DEPS =

lua_install:
	@test -e $(LUA_BUILD_DIR)/.installed || \
	$(MAKE) $(LUA_BUILD_DIR)/.installed

$(LUA_BUILD_DIR)/.installed: $(LUA_DEPS) download_lua \
	$(LUA_BUILD_DIR)/.decompressed
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	lua-$(LUA_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(LUA_BUILD_DIR) CC=$(TARGETCC_CACHED) \
	AR="$(TARGETAR) rcu" RANLIB=$(TARGETRANLIB) \
	LDFLAGS="-L$(SYSROOT)/$(LIBDIR) -L$(SYSROOT)/usr/$(LIBDIR)" \
	CFLAGS="$(TARGET_CFLAGS) -I$(SYSROOT)/usr/include" ansi
	$(Q)$(MAKE) -C $(LUA_BUILD_DIR) INSTALL_TOP=$(SYSROOT)/usr/ LIBDIR=$(LIBDIR) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_lua:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(LUA_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(LUA_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(LUA_PACKAGE) \
	$(LUA_SITE)/$(LUA_PACKAGE)
ifeq ($(CONFIG_EMBTK_LUA_NEED_PATCH),y)
	@test -e $(DOWNLOAD_DIR)/lua-$(LUA_VERSION).patch || \
	wget -O $(DOWNLOAD_DIR)/lua-$(LUA_VERSION).patch \
	$(LUA_PATCH_SITE)/lua-$(LUA_VERSION)-*.patch
endif

$(LUA_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LUA_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjf $(DOWNLOAD_DIR)/$(LUA_PACKAGE)
ifeq ($(CONFIG_EMBTK_LUA_NEED_PATCH),y)
	@cd $(LUA_BUILD_DIR); \
	patch -p1 < $(DOWNLOAD_DIR)/lua-$(LUA_VERSION).patch
endif
	@touch $@

lua_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup lua...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(LUA_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(LUA_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(LUA_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(LUA_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(LUA_PKGCONFIGS)
	$(Q)-rm -rf $(LUA_BUILD_DIR)*

