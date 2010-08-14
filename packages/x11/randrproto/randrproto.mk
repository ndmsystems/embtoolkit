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
# \file         randrproto.mk
# \brief	randrproto.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         February 2010
################################################################################

RANDRPROTO_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_RANDRPROTO_VERSION_STRING)))
RANDRPROTO_SITE := http://xorg.freedesktop.org/archive/individual/proto
RANDRPROTO_PACKAGE := randrproto-$(RANDRPROTO_VERSION).tar.bz2
RANDRPROTO_BUILD_DIR := $(PACKAGES_BUILD)/randrproto-$(RANDRPROTO_VERSION)

RANDRPROTO_BINS =
RANDRPROTO_SBINS =
RANDRPROTO_INCLUDES = X11/extensions/randr.h X11/extensions/randrproto.h
RANDRPROTO_LIBS =
RANDRPROTO_PKGCONFIGS = randrproto.pc

ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
PKG_CONFIG_PATH=$(SYSROOT)/usr/lib32/pkgconfig
else
PKG_CONFIG_PATH=$(SYSROOT)/usr/lib/pkgconfig
endif

randrproto_install: $(RANDRPROTO_BUILD_DIR)/.installed

$(RANDRPROTO_BUILD_DIR)/.installed: download_randrproto \
	$(RANDRPROTO_BUILD_DIR)/.decompressed $(RANDRPROTO_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	randrproto-$(RANDRPROTO_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(RANDRPROTO_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(RANDRPROTO_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_randrproto:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(RANDRPROTO_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(RANDRPROTO_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(RANDRPROTO_PACKAGE) \
	$(RANDRPROTO_SITE)/$(RANDRPROTO_PACKAGE)

$(RANDRPROTO_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(RANDRPROTO_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(RANDRPROTO_PACKAGE)
	@touch $@

$(RANDRPROTO_BUILD_DIR)/.configured:
	$(Q)cd $(RANDRPROTO_BUILD_DIR); \
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

randrproto_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup randrproto-$(RANDRPROTO_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(RANDRPROTO_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(RANDRPROTO_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(RANDRPROTO_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/lib; rm -rf $(RANDRPROTO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib/pkgconfig; rm -rf $(RANDRPROTO_PKGCONFIGS)
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cd $(SYSROOT)/usr/lib32; rm -rf $(RANDRPROTO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib32/pkgconfig; rm -rf $(RANDRPROTO_PKGCONFIGS)
endif

