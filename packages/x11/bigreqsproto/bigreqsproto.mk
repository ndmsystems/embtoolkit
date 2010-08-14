################################################################################
# Embtoolkit
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
# \file         bigreqsproto.mk
# \brief	bigreqsproto.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         February 2010
################################################################################

BIGREQSPROTO_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_BIGREQSPROTO_VERSION_STRING)))
BIGREQSPROTO_SITE := http://xorg.freedesktop.org/archive/individual/proto
BIGREQSPROTO_PACKAGE := bigreqsproto-$(BIGREQSPROTO_VERSION).tar.bz2
BIGREQSPROTO_BUILD_DIR := $(PACKAGES_BUILD)/bigreqsproto-$(BIGREQSPROTO_VERSION)

BIGREQSPROTO_BINS =
BIGREQSPROTO_SBINS =
BIGREQSPROTO_INCLUDES = X11/extensions/bigreqsproto.h X11/extensions/bigreqstr.h
BIGREQSPROTO_LIBS =
BIGREQSPROTO_PKGCONFIGS = bigreqsproto.pc

bigreqsproto_install: $(BIGREQSPROTO_BUILD_DIR)/.installed

$(BIGREQSPROTO_BUILD_DIR)/.installed: download_bigreqsproto \
	$(BIGREQSPROTO_BUILD_DIR)/.decompressed $(BIGREQSPROTO_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	bigreqsproto-$(BIGREQSPROTO_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(BIGREQSPROTO_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(BIGREQSPROTO_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_bigreqsproto:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(BIGREQSPROTO_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(BIGREQSPROTO_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(BIGREQSPROTO_PACKAGE) \
	$(BIGREQSPROTO_SITE)/$(BIGREQSPROTO_PACKAGE)

$(BIGREQSPROTO_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(BIGREQSPROTO_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(BIGREQSPROTO_PACKAGE)
	@touch $@

$(BIGREQSPROTO_BUILD_DIR)/.configured:
	$(Q)cd $(BIGREQSPROTO_BUILD_DIR); \
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

bigreqsproto_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup bigreqsproto-$(BIGREQSPROTO_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(BIGREQSPROTO_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(BIGREQSPROTO_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(BIGREQSPROTO_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/lib; rm -rf $(BIGREQSPROTO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib/pkgconfig; rm -rf $(BIGREQSPROTO_PKGCONFIGS)
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cd $(SYSROOT)/usr/lib32; rm -rf $(BIGREQSPROTO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib32/pkgconfig; rm -rf $(BIGREQSPROTO_PKGCONFIGS)
endif

