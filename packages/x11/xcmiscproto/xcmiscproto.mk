################################################################################
# GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
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
# \file         xcmiscproto.mk
# \brief	xcmiscproto.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         March 2010
################################################################################

XCMISCPROTO_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_XCMISCPROTO_VERSION_STRING)))
XCMISCPROTO_SITE := http://xorg.freedesktop.org/archive/individual/proto
XCMISCPROTO_PACKAGE := xcmiscproto-$(XCMISCPROTO_VERSION).tar.bz2
XCMISCPROTO_BUILD_DIR := $(PACKAGES_BUILD)/xcmiscproto-$(XCMISCPROTO_VERSION)

XCMISCPROTO_BINS =
XCMISCPROTO_SBINS =
XCMISCPROTO_INCLUDES = X11/extensions/xcmiscproto.h X11/extensions/xcmiscstr.h
XCMISCPROTO_LIBS =
XCMISCPROTO_PKGCONFIGS = xcmiscproto.pc

ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
PKG_CONFIG_PATH=$(SYSROOT)/usr/lib32/pkgconfig
else
PKG_CONFIG_PATH=$(SYSROOT)/usr/lib/pkgconfig
endif

xcmiscproto_install: $(XCMISCPROTO_BUILD_DIR)/.installed

$(XCMISCPROTO_BUILD_DIR)/.installed: download_xcmiscproto \
	$(XCMISCPROTO_BUILD_DIR)/.decompressed $(XCMISCPROTO_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	xcmiscproto-$(XCMISCPROTO_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(XCMISCPROTO_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(XCMISCPROTO_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_xcmiscproto:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(XCMISCPROTO_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(XCMISCPROTO_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(XCMISCPROTO_PACKAGE) \
	$(XCMISCPROTO_SITE)/$(XCMISCPROTO_PACKAGE)

$(XCMISCPROTO_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(XCMISCPROTO_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(XCMISCPROTO_PACKAGE)
	@touch $@

$(XCMISCPROTO_BUILD_DIR)/.configured:
	$(Q)cd $(XCMISCPROTO_BUILD_DIR); \
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

xcmiscproto_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup xcmiscproto-$(XCMISCPROTO_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(XCMISCPROTO_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(XCMISCPROTO_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(XCMISCPROTO_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/lib; rm -rf $(XCMISCPROTO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib/pkgconfig; rm -rf $(XCMISCPROTO_PKGCONFIGS)
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cd $(SYSROOT)/usr/lib32; rm -rf $(XCMISCPROTO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib32/pkgconfig; rm -rf $(XCMISCPROTO_PKGCONFIGS)
endif

