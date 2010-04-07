################################################################################
# GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
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
# \file         tslib.mk
# \brief	tslib.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         March 2010
################################################################################

TSLIB_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_TSLIB_VERSION_STRING)))
TSLIB_SITE := http://download.berlios.de/tslib
TSLIB_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/tslib/$(TSLIB_VERSION)
TSLIB_PACKAGE := tslib-$(TSLIB_VERSION).tar.bz2
TSLIB_BUILD_DIR := $(PACKAGES_BUILD)/tslib-$(TSLIB_VERSION)

TSLIB_BINS = ts_calibrate ts_harvest ts_print ts_print_raw ts_test
TSLIB_SBINS =
TSLIB_INCLUDES = tslib.h
TSLIB_LIBS = libts* ts
TSLIB_PKGCONFIGS = tslib-*.pc

TSLIB_DEPS =

tslib_install: $(TSLIB_BUILD_DIR)/.installed

$(TSLIB_BUILD_DIR)/.installed: $(TSLIB_DEPS) download_tslib \
	$(TSLIB_BUILD_DIR)/.decompressed $(TSLIB_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	tslib-$(TSLIB_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(TSLIB_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(TSLIB_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	$(Q)-cp -R $(SYSROOT)/usr/$(LIBDIR)/ts $(ROOTFS)/usr/$(LIBDIR)/
	@touch $@

download_tslib:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(TSLIB_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(TSLIB_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(TSLIB_PACKAGE) \
	$(TSLIB_SITE)/$(TSLIB_PACKAGE)
ifeq ($(CONFIG_EMBTK_TSLIB_NEED_PATCH),y)
	@test -e $(DOWNLOAD_DIR)/tslib-$(TSLIB_VERSION).patch || \
	wget -O $(DOWNLOAD_DIR)/tslib-$(TSLIB_VERSION).patch \
	$(TSLIB_PATCH_SITE)/tslib-$(TSLIB_VERSION)-*.patch
endif

$(TSLIB_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(TSLIB_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjf $(DOWNLOAD_DIR)/$(TSLIB_PACKAGE)
ifeq ($(CONFIG_EMBTK_TSLIB_NEED_PATCH),y)
	@cd $(PACKAGES_BUILD)/tslib-$(TSLIB_VERSION); \
	patch -p1 < $(DOWNLOAD_DIR)/tslib-$(TSLIB_VERSION).patch
endif
	@touch $@

$(TSLIB_BUILD_DIR)/.configured:
	$(Q)cd $(TSLIB_BUILD_DIR); \
	$(AUTORECONF); \
	chmod a+x configure; \
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
	ac_cv_func_malloc_0_nonnull=yes \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) --libdir=/usr/$(LIBDIR) \
	--prefix=/usr
	@touch $@

tslib_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup tslib-$(TSLIB_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(TSLIB_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(TSLIB_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(TSLIB_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(TSLIB_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(TSLIB_PKGCONFIGS)

