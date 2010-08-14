################################################################################
# Embtoolkit
# Copyright(C) 2010 GAYE Abdoulaye Walsimou. All rights reserved.
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
# \file         libxrender.mk
# \brief	libxrender.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

LIBXRENDER_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_LIBXRENDER_VERSION_STRING)))
LIBXRENDER_SITE := http://xorg.freedesktop.org/archive/individual/lib
LIBXRENDER_PACKAGE := libXrender-$(LIBXRENDER_VERSION).tar.bz2
LIBXRENDER_BUILD_DIR := $(PACKAGES_BUILD)/libXrender-$(LIBXRENDER_VERSION)

LIBXRENDER_BINS =
LIBXRENDER_SBINS =
LIBXRENDER_INCLUDES = X11/extensions/Xrender.h
LIBXRENDER_LIBS = libXrender.*
LIBXRENDER_PKGCONFIGS = xrender.pc

LIBXRENDER_DEPS = renderproto_install libx11_install

libxrender_install: $(LIBXRENDER_BUILD_DIR)/.installed

$(LIBXRENDER_BUILD_DIR)/.installed: $(LIBXRENDER_DEPS) download_libxrender \
	$(LIBXRENDER_BUILD_DIR)/.decompressed $(LIBXRENDER_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	libxrender-$(LIBXRENDER_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH,$(LIBXRENDER_BUILD_DIR))
	$(Q)$(MAKE) -C $(LIBXRENDER_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBXRENDER_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_libxrender:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(LIBXRENDER_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(LIBXRENDER_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(LIBXRENDER_PACKAGE) \
	$(LIBXRENDER_SITE)/$(LIBXRENDER_PACKAGE)

$(LIBXRENDER_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LIBXRENDER_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjf $(DOWNLOAD_DIR)/$(LIBXRENDER_PACKAGE)
	@touch $@

$(LIBXRENDER_BUILD_DIR)/.configured:
	$(Q)cd $(LIBXRENDER_BUILD_DIR); \
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

libxrender_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup libxrender-$(LIBXRENDER_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(LIBXRENDER_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(LIBXRENDER_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(LIBXRENDER_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(LIBXRENDER_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(LIBXRENDER_PKGCONFIGS)

