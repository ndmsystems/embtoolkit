################################################################################
# Embtoolkit
# Copyright(C) 2010 Abdoulaye Walsimou GAYE. All rights reserved.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
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
# \file         libxrandr.mk
# \brief	libxrandr.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         June 2010
################################################################################

LIBXRANDR_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_LIBXRANDR_VERSION_STRING)))
LIBXRANDR_SITE := http://xorg.freedesktop.org/archive/individual/lib
LIBXRANDR_PACKAGE := libXrandr-$(LIBXRANDR_VERSION).tar.bz2
LIBXRANDR_BUILD_DIR := $(PACKAGES_BUILD)/libXrandr-$(LIBXRANDR_VERSION)

LIBXRANDR_BINS =
LIBXRANDR_SBINS =
LIBXRANDR_INCLUDES = X11/extensions/Xrandr.h
LIBXRANDR_LIBS = libXrandr.*
LIBXRANDR_PKGCONFIGS = xrandr.pc

LIBXRANDR_DEPS = xproto_install randrproto_install

libxrandr_install:
	@test -e $(LIBXRANDR_BUILD_DIR)/.installed || \
	$(MAKE) $(LIBXRANDR_BUILD_DIR)/.installed

$(LIBXRANDR_BUILD_DIR)/.installed: $(LIBXRANDR_DEPS) download_libxrandr \
	$(LIBXRANDR_BUILD_DIR)/.decompressed $(LIBXRANDR_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	libxrandr-$(LIBXRANDR_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH,$(LIBXRANDR_BUILD_DIR))
	$(Q)$(MAKE) -C $(LIBXRANDR_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBXRANDR_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_libxrandr:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(LIBXRANDR_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(LIBXRANDR_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(LIBXRANDR_PACKAGE) \
	$(LIBXRANDR_SITE)/$(LIBXRANDR_PACKAGE)

$(LIBXRANDR_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LIBXRANDR_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjf $(DOWNLOAD_DIR)/$(LIBXRANDR_PACKAGE)
	@touch $@

$(LIBXRANDR_BUILD_DIR)/.configured:
	$(Q)cd $(LIBXRANDR_BUILD_DIR); \
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

libxrandr_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup libxrandr...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(LIBXRANDR_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(LIBXRANDR_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(LIBXRANDR_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(LIBXRANDR_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(LIBXRANDR_PKGCONFIGS)
	$(Q)-rm -rf $(LIBXRANDR_BUILD_DIR)*

