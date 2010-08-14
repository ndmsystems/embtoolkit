################################################################################
# Embtoolkit
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
# \file         zlib.mk
# \brief	zlib.mk of Embtoolkit.
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         June 2009
################################################################################

ZLIB_VERSION := 1.2.5
ZLIB_SITE := http://www.gzip.org/zlib
ZLIB_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/zlib/patches
ZLIB_PACKAGE := zlib-$(ZLIB_VERSION).tar.bz2
ZLIB_HOST_BUILD_DIR := $(TOOLS_BUILD)/zlib-$(ZLIB_VERSION)
ZLIB_TARGET_BUILD_DIR := $(PACKAGES_BUILD)/zlib-$(ZLIB_VERSION)

zlib_host_install: $(ZLIB_HOST_BUILD_DIR)/.installed

ZLIB_TARGET_BINS =
ZLIB_TARGET_SBINS =
ZLIB_TARGET_INCLUDES = zconf.h zlib.h
ZLIB_TARGET_LIBS = libz.*
ZLIB_TARGET_PKGCONFIGS = zlib.pc

ifeq ($(CONFIG_EMBTK_64BITS_FS),y)
ZLIB_TARGET_LINUX_ARCH := --64
endif
zlib_target_install: $(ZLIB_TARGET_BUILD_DIR)/.installed

#zlib on host machine
$(ZLIB_HOST_BUILD_DIR)/.installed: download_zlib \
	$(ZLIB_HOST_BUILD_DIR)/.decompressed $(ZLIB_HOST_BUILD_DIR)/.configured
	@$(MAKE) -C $(ZLIB_HOST_BUILD_DIR)
	@$(MAKE) -C $(ZLIB_HOST_BUILD_DIR) install
	@touch $@

$(ZLIB_HOST_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(ZLIB_PACKAGE)...")
	@tar -C $(TOOLS_BUILD) -xjf $(DOWNLOAD_DIR)/$(ZLIB_PACKAGE)
	@touch $@

$(ZLIB_HOST_BUILD_DIR)/.configured:
	$(call EMBTK_GENERIC_MESSAGE,"Configuring \
	zlib-$(ZLIB_VERSION) for your development machine...")
	@cd $(ZLIB_HOST_BUILD_DIR); \
	./configure --prefix=$(HOSTTOOLS)/usr
	@touch $@

#zlib on target machine
$(ZLIB_TARGET_BUILD_DIR)/.installed: download_zlib \
	$(ZLIB_TARGET_BUILD_DIR)/.decompressed \
	$(ZLIB_TARGET_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	zlib-$(ZLIB_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(ZLIB_TARGET_BUILD_DIR)
	$(Q)$(MAKE) -C $(ZLIB_TARGET_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

$(ZLIB_TARGET_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(ZLIB_PACKAGE)...")
	@tar -C $(PACKAGES_BUILD) -xjf $(DOWNLOAD_DIR)/$(ZLIB_PACKAGE)
	@touch $@

$(ZLIB_TARGET_BUILD_DIR)/.configured:
	$(Q)cd $(ZLIB_TARGET_BUILD_DIR); \
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
	./configure \
	--libdir=/usr/$(LIBDIR) --prefix=/usr
	@touch $@

zlib_target_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup zlib-$(ZLIB_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(ZLIB_TARGET_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(ZLIB_TARGET_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(ZLIB_TARGET_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(ZLIB_TARGET_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(ZLIB_TARGET_PKGCONFIGS)


#zlib download
download_zlib:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(ZLIB_PACKAGE) if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(ZLIB_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(ZLIB_PACKAGE) $(ZLIB_SITE)/$(ZLIB_PACKAGE)

