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
# \file         utilmacros.mk
# \brief	utilmacros.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

UTILMACROS_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_UTILMACROS_VERSION_STRING)))
UTILMACROS_SITE := http://xorg.freedesktop.org/archive/individual/util
UTILMACROS_PACKAGE := util-macros-$(UTILMACROS_VERSION).tar.bz2
UTILMACROS_BUILD_DIR := $(PACKAGES_BUILD)/util-macros-$(UTILMACROS_VERSION)

UTILMACROS_BINS =
UTILMACROS_SBINS =
UTILMACROS_INCLUDES =
UTILMACROS_LIBS =
UTILMACROS_PKGCONFIGS = xorg-macros.pc

utilmacros_install:
	@test -e $(UTILMACROS_BUILD_DIR)/.installed || \
	$(MAKE) $(UTILMACROS_BUILD_DIR)/.installed

$(UTILMACROS_BUILD_DIR)/.installed: download_utilmacros \
	$(UTILMACROS_BUILD_DIR)/.decompressed $(UTILMACROS_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	utilmacros-$(UTILMACROS_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(UTILMACROS_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(UTILMACROS_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)cp $(SYSROOT)/usr/share/pkgconfig/xorg-macros.pc $(PKG_CONFIG_PATH)
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_utilmacros:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(UTILMACROS_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(UTILMACROS_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(UTILMACROS_PACKAGE) \
	$(UTILMACROS_SITE)/$(UTILMACROS_PACKAGE)

$(UTILMACROS_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(UTILMACROS_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(UTILMACROS_PACKAGE)
	@touch $@

$(UTILMACROS_BUILD_DIR)/.configured:
	$(Q)cd $(UTILMACROS_BUILD_DIR); \
	CC=$(TARGETCC_CACHED) \
	CXX=$(TARGETCXX_CACHED) \
	AR=$(TARGETAR) \
	RANLIB=$(TARGETRANLIB) \
	AS=$(CROSS_COMPILE)as \
	LD=$(TARGETLD) \
	NM=$(TARGETNM) \
	STRIP=$(TARGETSTRIP) \
	OBJDUMP=$(TARGETOBJDUMP) \
	OBJCOPY=$(TARGETOBJCOPY) \
	CFLAGS="$(TARGET_CFLAGS)" \
	CXXFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="-L$(SYSROOT)/$(LIBDIR) -L$(SYSROOT)/usr/$(LIBDIR)" \
	CPPFLGAS="-I$(SYSROOT)/usr/include" \
	PKG_CONFIG=$(PKGCONFIG_BIN) \
	PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) --prefix=/usr --libdir=/usr/$(LIBDIR) \
	--disable-malloc0returnsnull
	@touch $@

utilmacros_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup utilmacros-$(UTILMACROS_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(UTILMACROS_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(UTILMACROS_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(UTILMACROS_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(UTILMACROS_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(UTILMACROS_PKGCONFIGS)
	$(Q)-rm -rf $(UTILMACROS_BUILD_DIR)*

