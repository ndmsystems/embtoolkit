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
# \file         inputproto.mk
# \brief	inputproto.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         December 2009
################################################################################

INPUTPROTO_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_INPUTPROTO_VERSION_STRING)))
INPUTPROTO_SITE := http://xorg.freedesktop.org/archive/individual/proto
INPUTPROTO_PACKAGE := inputproto-$(INPUTPROTO_VERSION).tar.bz2
INPUTPROTO_BUILD_DIR := $(PACKAGES_BUILD)/inputproto-$(INPUTPROTO_VERSION)

INPUTPROTO_BINS =
INPUTPROTO_SBINS =
INPUTPROTO_INCLUDES = X11/extensions/XI2.h X11/extensions/XI2proto.h \
		X11/extensions/XI.h X11/extensions/XIproto.h
INPUTPROTO_LIBS =
INPUTPROTO_PKGCONFIGS = inputproto.pc

ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
PKG_CONFIG_PATH=$(SYSROOT)/usr/lib32/pkgconfig
else
PKG_CONFIG_PATH=$(SYSROOT)/usr/lib/pkgconfig
endif

inputproto_install: $(INPUTPROTO_BUILD_DIR)/.installed

$(INPUTPROTO_BUILD_DIR)/.installed: download_inputproto \
	$(INPUTPROTO_BUILD_DIR)/.decompressed $(INPUTPROTO_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	inputproto-$(INPUTPROTO_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(INPUTPROTO_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(INPUTPROTO_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_inputproto:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(INPUTPROTO_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(INPUTPROTO_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(INPUTPROTO_PACKAGE) \
	$(INPUTPROTO_SITE)/$(INPUTPROTO_PACKAGE)

$(INPUTPROTO_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(INPUTPROTO_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(INPUTPROTO_PACKAGE)
	@touch $@

$(INPUTPROTO_BUILD_DIR)/.configured:
	$(Q)cd $(INPUTPROTO_BUILD_DIR); \
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

inputproto_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup inputproto-$(INPUTPROTO_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(INPUTPROTO_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(INPUTPROTO_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(INPUTPROTO_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/lib; rm -rf $(INPUTPROTO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib/pkgconfig; rm -rf $(INPUTPROTO_PKGCONFIGS)
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cd $(SYSROOT)/usr/lib32; rm -rf $(INPUTPROTO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib32/pkgconfig; rm -rf $(INPUTPROTO_PKGCONFIGS)
endif

