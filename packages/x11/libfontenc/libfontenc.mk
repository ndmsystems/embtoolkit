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
# \file         libfontenc.mk
# \brief	libfontenc.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         March 2010
################################################################################

LIBFONTENC_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_LIBFONTENC_VERSION_STRING)))
LIBFONTENC_SITE := http://xorg.freedesktop.org/archive/individual/lib
LIBFONTENC_PACKAGE := libfontenc-$(LIBFONTENC_VERSION).tar.bz2
LIBFONTENC_BUILD_DIR := $(PACKAGES_BUILD)/libfontenc-$(LIBFONTENC_VERSION)

LIBFONTENC_BINS =
LIBFONTENC_SBINS =
LIBFONTENC_INCLUDES = X11/fonts/fontenc.h
LIBFONTENC_LIBS = libfontenc.*
LIBFONTENC_PKGCONFIGS = libfontenc.pc

libfontenc_install: $(LIBFONTENC_BUILD_DIR)/.installed

$(LIBFONTENC_BUILD_DIR)/.installed: download_libfontenc \
	$(LIBFONTENC_BUILD_DIR)/.decompressed $(LIBFONTENC_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	libfontenc-$(LIBFONTENC_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(LIBFONTENC_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBFONTENC_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_libfontenc:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(LIBFONTENC_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(LIBFONTENC_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(LIBFONTENC_PACKAGE) \
	$(LIBFONTENC_SITE)/$(LIBFONTENC_PACKAGE)

$(LIBFONTENC_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LIBFONTENC_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(LIBFONTENC_PACKAGE)
	@touch $@

$(LIBFONTENC_BUILD_DIR)/.configured:
	$(Q)cd $(LIBFONTENC_BUILD_DIR); \
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

libfontenc_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup libfontenc-$(LIBFONTENC_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(LIBFONTENC_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(LIBFONTENC_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(LIBFONTENC_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(LIBFONTENC_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(LIBFONTENC_PKGCONFIGS)

