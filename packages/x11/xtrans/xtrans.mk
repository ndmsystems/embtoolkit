################################################################################
# GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# Copyright(C) 2010 GAYE Abdoulaye Walsimou. All rights reserved.
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
# \file         xtrans.mk
# \brief	xtrans.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         March 2010
################################################################################

XTRANS_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_XTRANS_VERSION_STRING)))
XTRANS_SITE := http://xorg.freedesktop.org/archive/individual/lib
XTRANS_PACKAGE := xtrans-$(XTRANS_VERSION).tar.bz2
XTRANS_BUILD_DIR := $(PACKAGES_BUILD)/xtrans-$(XTRANS_VERSION)

XTRANS_BINS =
XTRANS_SBINS =
XTRANS_INCLUDES = X11/xtrans
XTRANS_LIBS =
XTRANS_PKGCONFIGS =

ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
PKG_CONFIG_PATH=$(SYSROOT)/usr/lib32/pkgconfig
else
PKG_CONFIG_PATH=$(SYSROOT)/usr/lib/pkgconfig
endif

xtrans_install: $(XTRANS_BUILD_DIR)/.installed

$(XTRANS_BUILD_DIR)/.installed: download_xtrans \
	$(XTRANS_BUILD_DIR)/.decompressed $(XTRANS_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	xtrans-$(XTRANS_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(XTRANS_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(XTRANS_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)cp $(SYSROOT)/usr/share/pkgconfig/xtrans.pc $(PKG_CONFIG_PATH)
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_xtrans:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(XTRANS_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(XTRANS_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(XTRANS_PACKAGE) \
	$(XTRANS_SITE)/$(XTRANS_PACKAGE)

$(XTRANS_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(XTRANS_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(XTRANS_PACKAGE)
	@touch $@

$(XTRANS_BUILD_DIR)/.configured:
	$(Q)cd $(XTRANS_BUILD_DIR); \
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

xtrans_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup xtrans-$(XTRANS_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(XTRANS_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(XTRANS_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(XTRANS_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/lib; rm -rf $(XTRANS_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib/pkgconfig; rm -rf $(XTRANS_PKGCONFIGS)
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cd $(SYSROOT)/usr/lib32; rm -rf $(XTRANS_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib32/pkgconfig; rm -rf $(XTRANS_PKGCONFIGS)
endif

