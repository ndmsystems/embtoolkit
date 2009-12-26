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
# \file         fontconfig.mk
# \brief	fontconfig.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         December 2009
################################################################################

FONTCONFIG_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_FONTCONFIG_VERSION_STRING)))
FONTCONFIG_SITE := http://fontconfig.org/release
FONTCONFIG_PACKAGE := fontconfig-$(FONTCONFIG_VERSION).tar.gz
FONTCONFIG_BUILD_DIR := $(PACKAGES_BUILD)/fontconfig-$(FONTCONFIG_VERSION)

FONTCONFIG_BINS = fc-cache fc-cat fc-list fc-match fc-query fc-scan
FONTCONFIG_SBINS =
FONTCONFIG_INCLUDES = fontconfig
FONTCONFIG_LIBS = libfontconfig*
FONTCONFIG_PKGCONFIGS = fontconfig.pc

ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
LIBXML2_CFLAGS="-I$(SYSROOT)/usr/include/libxml2 -L$(SYSROOT)/usr/lib32"
else
LIBXML2_CFLAGS="-I$(SYSROOT)/usr/include/libxml2 -L$(SYSROOT)/usr/lib"
endif

fontconfig_install:	$(FONTCONFIG_BUILD_DIR)/.installed \
			$(FONTCONFIG_BUILD_DIR)/.special	

$(FONTCONFIG_BUILD_DIR)/.installed: libxml2_install \
	download_fontconfig $(FONTCONFIG_BUILD_DIR)/.decompressed \
	$(FONTCONFIG_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	fontconfig-$(FONTCONFIG_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(FONTCONFIG_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(FONTCONFIG_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_fontconfig:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(FONTCONFIG_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(FONTCONFIG_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(FONTCONFIG_PACKAGE) \
	$(FONTCONFIG_SITE)/$(FONTCONFIG_PACKAGE)

$(FONTCONFIG_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(FONTCONFIG_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzvf $(DOWNLOAD_DIR)/$(FONTCONFIG_PACKAGE)
	@touch $@

$(FONTCONFIG_BUILD_DIR)/.configured:
	$(Q)cd $(FONTCONFIG_BUILD_DIR); \
	CC=$(TARGETCC_CACHED) CXX=$(TARGETCXX_CACHED) \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="-L$(SYSROOT)/lib -L$(SYSROOT)/usr/lib \
	-L$(SYSROOT)/lib32 -L$(SYSROOT)/usr/lib32" \
	CPPFLGAS="-I$(SYSROOT)/usr/include" \
	PKG_CONFIG=$(PKGCONFIG_BIN) \
	LIBXML2_CFLAGS=$(LIBXML2_CFLAGS) \
	LIBXML2_LIBS="-lxml2" \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) --with-arch=$(STRICT_GNU_TARGET) \
	--prefix=/usr --disable-docs
	@touch $@

.PHONY: $(FONTCONFIG_BUILD_DIR)/.special fontconfig_clean

fontconfig_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup fontconfig-$(FONTCONFIG_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(FONTCONFIG_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(FONTCONFIG_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(FONTCONFIG_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/lib; rm -rf $(FONTCONFIG_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib/pkgconfig; rm -rf $(FONTCONFIG_PKGCONFIGS)
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cd $(SYSROOT)/usr/lib32; rm -rf $(FONTCONFIG_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib32/pkgconfig; rm -rf $(FONTCONFIG_PKGCONFIGS)
endif

$(FONTCONFIG_BUILD_DIR)/.special:
	$(Q)-cp $(SYSROOT)/usr/etc/fonts $(ROOTFS)/etc/
	@touch $@

