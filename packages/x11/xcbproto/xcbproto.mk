################################################################################
# Embtoolkit
# Copyright(C) 2010 GAYE Abdoulaye Walsimou. All rights reserved.
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
# \file         xcbproto.mk
# \brief	xcbproto.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         March 2010
################################################################################

XCBPROTO_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_XCBPROTO_VERSION_STRING)))
XCBPROTO_SITE := http://xcb.freedesktop.org/dist
XCBPROTO_PACKAGE := xcb-proto-$(XCBPROTO_VERSION).tar.gz
XCBPROTO_BUILD_DIR := $(PACKAGES_BUILD)/xcb-proto-$(XCBPROTO_VERSION)

XCBPROTO_BINS =
XCBPROTO_SBINS =
XCBPROTO_INCLUDES =
XCBPROTO_LIBS = python2.6/dist-packages/xcbgen
XCBPROTO_PKGCONFIGS = xcb-proto.pc

ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
PKG_CONFIG_PATH=$(SYSROOT)/usr/lib32/pkgconfig
else
PKG_CONFIG_PATH=$(SYSROOT)/usr/lib/pkgconfig
endif

xcbproto_install: $(XCBPROTO_BUILD_DIR)/.installed

$(XCBPROTO_BUILD_DIR)/.installed: download_xcbproto \
	$(XCBPROTO_BUILD_DIR)/.decompressed $(XCBPROTO_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	xcbproto-$(XCBPROTO_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(XCBPROTO_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(XCBPROTO_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_xcbproto:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(XCBPROTO_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(XCBPROTO_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(XCBPROTO_PACKAGE) \
	$(XCBPROTO_SITE)/$(XCBPROTO_PACKAGE)

$(XCBPROTO_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(XCBPROTO_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzf $(DOWNLOAD_DIR)/$(XCBPROTO_PACKAGE)
	@touch $@

$(XCBPROTO_BUILD_DIR)/.configured:
	$(Q)cd $(XCBPROTO_BUILD_DIR); \
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
	--prefix=/usr --libdir=/usr/$(LIBDIR)
	@touch $@

xcbproto_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup xcbproto-$(XCBPROTO_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(XCBPROTO_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(XCBPROTO_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(XCBPROTO_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/lib; rm -rf $(XCBPROTO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib/pkgconfig; rm -rf $(XCBPROTO_PKGCONFIGS)
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cd $(SYSROOT)/usr/lib32; rm -rf $(XCBPROTO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib32/pkgconfig; rm -rf $(XCBPROTO_PKGCONFIGS)
endif

