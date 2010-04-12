################################################################################
# GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# Copyright(C) 2009 GAYE Abdoulaye Walsimou. All rights reserved.
#
# This program is free software; you can distribute it and/or modify it
# under the terms of the GNU General Public License
# (Version 2 or later) published by the Free Software Foundation.
#
# This program is distributed in the hope it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
################################################################################
#
# \file         utilmacros.mk
# \brief	utilmacros.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
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

ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
PKG_CONFIG_PATH=$(SYSROOT)/usr/lib32/pkgconfig
else
PKG_CONFIG_PATH=$(SYSROOT)/usr/lib/pkgconfig
endif

utilmacros_install: $(UTILMACROS_BUILD_DIR)/.installed

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
	--target=$(STRICT_GNU_TARGET) \
	--disable-malloc0returnsnull \
	--prefix=/usr --libdir=/usr/$(LIBDIR)
	@touch $@

utilmacros_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup utilmacros-$(UTILMACROS_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(UTILMACROS_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(UTILMACROS_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(UTILMACROS_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/lib; rm -rf $(UTILMACROS_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib/pkgconfig; rm -rf $(UTILMACROS_PKGCONFIGS)
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cd $(SYSROOT)/usr/lib32; rm -rf $(UTILMACROS_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib32/pkgconfig; rm -rf $(UTILMACROS_PKGCONFIGS)
endif

