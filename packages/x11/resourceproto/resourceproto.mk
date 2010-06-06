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
# \file         resourceproto.mk
# \brief	resourceproto.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         March 2010
################################################################################

RESOURCEPROTO_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_RESOURCEPROTO_VERSION_STRING)))
RESOURCEPROTO_SITE := http://ftp.x.org/pub/individual/proto
RESOURCEPROTO_PACKAGE := resourceproto-$(RESOURCEPROTO_VERSION).tar.bz2
RESOURCEPROTO_BUILD_DIR := $(PACKAGES_BUILD)/resourceproto-$(RESOURCEPROTO_VERSION)

RESOURCEPROTO_BINS =
RESOURCEPROTO_SBINS =
RESOURCEPROTO_INCLUDES = X11/extensions/XResproto.h
RESOURCEPROTO_LIBS =
RESOURCEPROTO_PKGCONFIGS = resourceproto.pc

resourceproto_install: $(RESOURCEPROTO_BUILD_DIR)/.installed

$(RESOURCEPROTO_BUILD_DIR)/.installed: download_resourceproto \
	$(RESOURCEPROTO_BUILD_DIR)/.decompressed $(RESOURCEPROTO_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	resourceproto-$(RESOURCEPROTO_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(RESOURCEPROTO_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(RESOURCEPROTO_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_resourceproto:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(RESOURCEPROTO_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(RESOURCEPROTO_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(RESOURCEPROTO_PACKAGE) \
	$(RESOURCEPROTO_SITE)/$(RESOURCEPROTO_PACKAGE)

$(RESOURCEPROTO_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(RESOURCEPROTO_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(RESOURCEPROTO_PACKAGE)
	@touch $@

$(RESOURCEPROTO_BUILD_DIR)/.configured:
	$(Q)cd $(RESOURCEPROTO_BUILD_DIR); \
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
	--target=$(STRICT_GNU_TARGET) --libdir=/usr/$(LIBDIR) --prefix=/usr \
	--disable-malloc0returnsnull
	@touch $@

resourceproto_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup resourceproto-$(RESOURCEPROTO_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(RESOURCEPROTO_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(RESOURCEPROTO_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(RESOURCEPROTO_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/lib; rm -rf $(RESOURCEPROTO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib/pkgconfig; rm -rf $(RESOURCEPROTO_PKGCONFIGS)
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cd $(SYSROOT)/usr/lib32; rm -rf $(RESOURCEPROTO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib32/pkgconfig; rm -rf $(RESOURCEPROTO_PKGCONFIGS)
endif

