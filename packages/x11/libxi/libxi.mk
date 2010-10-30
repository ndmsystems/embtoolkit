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
# \file         libxi.mk
# \brief	libxi.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         September 2010
################################################################################

LIBXI_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_LIBXI_VERSION_STRING)))
LIBXI_SITE := http://xorg.freedesktop.org/archive/individual/lib
LIBXI_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/libxi/$(LIBXI_VERSION)
LIBXI_PACKAGE := libXi-$(LIBXI_VERSION).tar.bz2
LIBXI_BUILD_DIR := $(PACKAGES_BUILD)/libXi-$(LIBXI_VERSION)

LIBXI_BINS =
LIBXI_SBINS =
LIBXI_INCLUDES = X11/extensions/XInput.h X11/extensions/XInput2.h
LIBXI_LIBS = libXi.*
LIBXI_PKGCONFIGS = xi.pc

LIBXI_DEPS := xproto_install xextproto_install inputproto_install \
	libx11_install libxext_install

libxi_install:
	@test -e $(LIBXI_BUILD_DIR)/.installed || \
	$(MAKE) $(LIBXI_BUILD_DIR)/.installed

$(LIBXI_BUILD_DIR)/.installed: $(LIBXI_DEPS) download_libxi \
	$(LIBXI_BUILD_DIR)/.decompressed $(LIBXI_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	libxi-$(LIBXI_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH,$(LIBXI_BUILD_DIR))
	$(Q)$(MAKE) -C $(LIBXI_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBXI_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_libxi:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(LIBXI_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(LIBXI_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(LIBXI_PACKAGE) \
	$(LIBXI_SITE)/$(LIBXI_PACKAGE)
ifeq ($(CONFIG_EMBTK_LIBXI_NEED_PATCH),y)
	@test -e $(DOWNLOAD_DIR)/libXi-$(LIBXI_VERSION).patch || \
	wget -O $(DOWNLOAD_DIR)/libXi-$(LIBXI_VERSION).patch \
	$(LIBXI_PATCH_SITE)/libXi-$(LIBXI_VERSION)-*.patch
endif

$(LIBXI_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LIBXI_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjf $(DOWNLOAD_DIR)/$(LIBXI_PACKAGE)
ifeq ($(CONFIG_EMBTK_LIBXI_NEED_PATCH),y)
	@cd $(LIBXI_BUILD_DIR); \
	patch -p1 < $(DOWNLOAD_DIR)/libXi-$(LIBXI_VERSION).patch
endif
	@touch $@

$(LIBXI_BUILD_DIR)/.configured:
	$(Q)cd $(LIBXI_BUILD_DIR); \
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
	--target=$(STRICT_GNU_TARGET) --libdir=/usr/$(LIBDIR) \
	--prefix=/usr --disable-malloc0returnsnull
	@touch $@

libxi_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup libxi...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(LIBXI_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(LIBXI_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(LIBXI_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(LIBXI_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(LIBXI_PKGCONFIGS)
	$(Q)-rm -rf $(LIBXI_BUILD_DIR)*

