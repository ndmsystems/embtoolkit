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
# \file         libxau.mk
# \brief	libxau.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         February 2010
################################################################################

LIBXAU_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_LIBXAU_VERSION_STRING)))
LIBXAU_SITE := http://xorg.freedesktop.org/archive/individual/lib
LIBXAU_PACKAGE := libXau-$(LIBXAU_VERSION).tar.bz2
LIBXAU_BUILD_DIR := $(PACKAGES_BUILD)/libXau-$(LIBXAU_VERSION)

LIBXAU_BINS =
LIBXAU_SBINS =
LIBXAU_INCLUDES = X11/Xauth.h
LIBXAU_LIBS = libXau.*
LIBXAU_PKGCONFIGS = xau.pc

LIBXAU_DEPS = xproto_install

libxau_install:
	@test -e $(LIBXAU_BUILD_DIR)/.installed || \
	$(MAKE) $(LIBXAU_BUILD_DIR)/.installed

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
	--target=$(STRICT_GNU_TARGET) --prefix=/usr --libdir=/usr/$(LIBDIR) \
	--disable-malloc0returnsnull
	@touch $@

libxau_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup libxau-$(LIBXAU_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(LIBXAU_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(LIBXAU_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(LIBXAU_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(LIBXAU_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(LIBXAU_PKGCONFIGS)
	$(Q)-rm -rf $(LIBXAU_BUILD_DIR)*

