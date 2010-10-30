################################################################################
# Embtoolkit
# Copyright(C) 2010 Abdoulaye Walsimou GAYE. All rights reserved.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
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
# \file         libxft.mk
# \brief	libxft.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         June 2010
################################################################################

LIBXFT_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_LIBXFT_VERSION_STRING)))
LIBXFT_SITE := http://xorg.freedesktop.org/archive/individual/lib
LIBXFT_PACKAGE := libXft-$(LIBXFT_VERSION).tar.bz2
LIBXFT_BUILD_DIR := $(PACKAGES_BUILD)/libXft-$(LIBXFT_VERSION)

LIBXFT_BINS = xft-config
LIBXFT_SBINS =
LIBXFT_INCLUDES = X11/xft
LIBXFT_LIBS = libXft.*
LIBXFT_PKGCONFIGS = xft.pc

LIBXFT_DEPS = freetype_install fontconfig_install libxrender_install

libxft_install:
	@test -e $(LIBXFT_BUILD_DIR)/.installed || \
	$(MAKE) $(LIBXFT_BUILD_DIR)/.installed

$(LIBXFT_BUILD_DIR)/.installed: $(LIBXFT_DEPS) download_libxft \
	$(LIBXFT_BUILD_DIR)/.decompressed $(LIBXFT_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	libxft-$(LIBXFT_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH,$(LIBXFT_BUILD_DIR))
	$(Q)$(MAKE) -C $(LIBXFT_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBXFT_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_libxft:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(LIBXFT_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(LIBXFT_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(LIBXFT_PACKAGE) \
	$(LIBXFT_SITE)/$(LIBXFT_PACKAGE)

$(LIBXFT_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LIBXFT_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjf $(DOWNLOAD_DIR)/$(LIBXFT_PACKAGE)
	@touch $@

$(LIBXFT_BUILD_DIR)/.configured:
	$(Q)cd $(LIBXFT_BUILD_DIR); \
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

libxft_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup libxft...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(LIBXFT_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(LIBXFT_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(LIBXFT_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(LIBXFT_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(LIBXFT_PKGCONFIGS)
	$(Q)-rm -rf $(LIBXFT_BUILD_DIR)*

