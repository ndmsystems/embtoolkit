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
# \file         renderproto.mk
# \brief	renderproto.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         March 2010
################################################################################

RENDERPROTO_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_RENDERPROTO_VERSION_STRING)))
RENDERPROTO_SITE := http://xorg.freedesktop.org/archive/individual/proto
RENDERPROTO_PACKAGE := renderproto-$(RENDERPROTO_VERSION).tar.bz2
RENDERPROTO_BUILD_DIR := $(PACKAGES_BUILD)/renderproto-$(RENDERPROTO_VERSION)

RENDERPROTO_BINS =
RENDERPROTO_SBINS =
RENDERPROTO_INCLUDES = X11/extensions/render.h X11/extensions/renderproto.h
RENDERPROTO_LIBS =
RENDERPROTO_PKGCONFIGS = renderproto.pc

ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
PKG_CONFIG_PATH=$(SYSROOT)/usr/lib32/pkgconfig
else
PKG_CONFIG_PATH=$(SYSROOT)/usr/lib/pkgconfig
endif

renderproto_install: $(RENDERPROTO_BUILD_DIR)/.installed

$(RENDERPROTO_BUILD_DIR)/.installed: download_renderproto \
	$(RENDERPROTO_BUILD_DIR)/.decompressed $(RENDERPROTO_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	renderproto-$(RENDERPROTO_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(RENDERPROTO_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(RENDERPROTO_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_renderproto:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(RENDERPROTO_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(RENDERPROTO_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(RENDERPROTO_PACKAGE) \
	$(RENDERPROTO_SITE)/$(RENDERPROTO_PACKAGE)

$(RENDERPROTO_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(RENDERPROTO_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(RENDERPROTO_PACKAGE)
	@touch $@

$(RENDERPROTO_BUILD_DIR)/.configured:
	$(Q)cd $(RENDERPROTO_BUILD_DIR); \
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

renderproto_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup renderproto-$(RENDERPROTO_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(RENDERPROTO_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(RENDERPROTO_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(RENDERPROTO_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/lib; rm -rf $(RENDERPROTO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib/pkgconfig; rm -rf $(RENDERPROTO_PKGCONFIGS)
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cd $(SYSROOT)/usr/lib32; rm -rf $(RENDERPROTO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib32/pkgconfig; rm -rf $(RENDERPROTO_PKGCONFIGS)
endif
