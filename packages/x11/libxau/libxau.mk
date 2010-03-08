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
# \file         libxau.mk
# \brief	libxau.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         March 2010
################################################################################

LIBXAU_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_LIBXAU_VERSION_STRING)))
LIBXAU_SITE := http://ftp.x.org/pub/individual/lib
LIBXAU_PACKAGE := libXau-$(LIBXAU_VERSION).tar.bz2
LIBXAU_BUILD_DIR := $(PACKAGES_BUILD)/libXau-$(LIBXAU_VERSION)

LIBXAU_BINS =
LIBXAU_SBINS =
LIBXAU_INCLUDES = X11/Xauth.h
LIBXAU_LIBS = libXau.*
LIBXAU_PKGCONFIGS = xau.pc

LIBXAU_DEPS = xproto_install

libxau_install: $(LIBXAU_BUILD_DIR)/.installed

$(LIBXAU_BUILD_DIR)/.installed: $(LIBXAU_DEPS) download_libxau \
	$(LIBXAU_BUILD_DIR)/.decompressed $(LIBXAU_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	libxau-$(LIBXAU_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(LIBXAU_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBXAU_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_libxau:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(LIBXAU_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(LIBXAU_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(LIBXAU_PACKAGE) \
	$(LIBXAU_SITE)/$(LIBXAU_PACKAGE)

$(LIBXAU_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LIBXAU_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(LIBXAU_PACKAGE)
	@touch $@

$(LIBXAU_BUILD_DIR)/.configured:
	$(Q)cd $(LIBXAU_BUILD_DIR); \
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

libxau_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup libxau-$(LIBXAU_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(LIBXAU_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(LIBXAU_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(LIBXAU_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(LIBXAU_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(LIBXAU_PKGCONFIGS)
