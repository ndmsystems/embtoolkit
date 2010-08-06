################################################################################
# Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
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
# \file         libxcomposite.mk
# \brief	libxcomposite.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         June 2010
################################################################################

LIBXCOMPOSITE_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_LIBXCOMPOSITE_VERSION_STRING)))
LIBXCOMPOSITE_SITE := http://xorg.freedesktop.org/archive/individual/lib
LIBXCOMPOSITE_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/libxcomposite/$(LIBXCOMPOSITE_VERSION)
LIBXCOMPOSITE_PACKAGE := libXcomposite-$(LIBXCOMPOSITE_VERSION).tar.bz2
LIBXCOMPOSITE_BUILD_DIR := $(PACKAGES_BUILD)/libXcomposite-$(LIBXCOMPOSITE_VERSION)

LIBXCOMPOSITE_BINS =
LIBXCOMPOSITE_SBINS =
LIBXCOMPOSITE_INCLUDES = X11/extensions/Xcomposite.h
LIBXCOMPOSITE_LIBS = libXcomposite.*
LIBXCOMPOSITE_PKGCONFIGS = xcomposite.pc

LIBXCOMPOSITE_DEPS = xproto_install libxfixes_install compositeproto_install

libxcomposite_install: $(LIBXCOMPOSITE_BUILD_DIR)/.installed

$(LIBXCOMPOSITE_BUILD_DIR)/.installed: $(LIBXCOMPOSITE_DEPS) download_libxcomposite \
	$(LIBXCOMPOSITE_BUILD_DIR)/.decompressed $(LIBXCOMPOSITE_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	libxcomposite-$(LIBXCOMPOSITE_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH,$(LIBXCOMPOSITE_BUILD_DIR))
	$(Q)$(MAKE) -C $(LIBXCOMPOSITE_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBXCOMPOSITE_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_libxcomposite:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(LIBXCOMPOSITE_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(LIBXCOMPOSITE_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(LIBXCOMPOSITE_PACKAGE) \
	$(LIBXCOMPOSITE_SITE)/$(LIBXCOMPOSITE_PACKAGE)
ifeq ($(CONFIG_EMBTK_LIBXCOMPOSITE_NEED_PATCH),y)
	@test -e $(DOWNLOAD_DIR)/libxcomposite-$(LIBXCOMPOSITE_VERSION).patch || \
	wget -O $(DOWNLOAD_DIR)/libxcomposite-$(LIBXCOMPOSITE_VERSION).patch \
	$(LIBXCOMPOSITE_PATCH_SITE)/libxcomposite-$(LIBXCOMPOSITE_VERSION)-*.patch
endif

$(LIBXCOMPOSITE_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LIBXCOMPOSITE_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjf $(DOWNLOAD_DIR)/$(LIBXCOMPOSITE_PACKAGE)
ifeq ($(CONFIG_EMBTK_LIBXCOMPOSITE_NEED_PATCH),y)
	@cd $(PACKAGES_BUILD)/libxcomposite-$(LIBXCOMPOSITE_VERSION); \
	patch -p1 < $(DOWNLOAD_DIR)/libxcomposite-$(LIBXCOMPOSITE_VERSION).patch
endif
	@touch $@

$(LIBXCOMPOSITE_BUILD_DIR)/.configured:
	$(Q)cd $(LIBXCOMPOSITE_BUILD_DIR); \
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
	--prefix=/usr
	@touch $@

libxcomposite_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup libxcomposite-$(LIBXCOMPOSITE_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(LIBXCOMPOSITE_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(LIBXCOMPOSITE_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(LIBXCOMPOSITE_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(LIBXCOMPOSITE_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(LIBXCOMPOSITE_PKGCONFIGS)

