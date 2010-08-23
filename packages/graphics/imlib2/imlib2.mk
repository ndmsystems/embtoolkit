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
# \file         imlib2.mk
# \brief	imlib2.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         June 2010
################################################################################

IMLIB2_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_IMLIB2_VERSION_STRING)))
IMLIB2_SITE := http://downloads.sourceforge.net/project/enlightenment/imlib2-src/$(IMLIB2_VERSION)
IMLIB2_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/imlib2/$(IMLIB2_VERSION)
IMLIB2_PACKAGE := imlib2-$(IMLIB2_VERSION).tar.gz
IMLIB2_BUILD_DIR := $(PACKAGES_BUILD)/imlib2-$(IMLIB2_VERSION)

IMLIB2_BINS = imlib2_bumpmap imlib2_colorspace imlib2-config imlib2_conv \
		imlib2_grab imlib2_poly imlib2_show imlib2_test imlib2_view
IMLIB2_SBINS =
IMLIB2_INCLUDES = Imlib2.h
IMLIB2_LIBS = imlib2 libImlib2.*
IMLIB2_PKGCONFIGS = imlib2.pc

IMLIB2_DEPS := libpng_install freetype_install libjpeg_install

imlib2_install:
	test -e $(IMLIB2_BUILD_DIR)/.installed || \
	$(MAKE) $(IMLIB2_BUILD_DIR)/.installed
	$(Q)$(MAKE) $(IMLIB2_BUILD_DIR)/.special

$(IMLIB2_BUILD_DIR)/.installed: $(IMLIB2_DEPS) download_imlib2 \
	$(IMLIB2_BUILD_DIR)/.decompressed $(IMLIB2_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	imlib2-$(IMLIB2_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH,$(IMLIB2_BUILD_DIR))
	$(Q)$(MAKE) -C $(IMLIB2_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(IMLIB2_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_imlib2:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(IMLIB2_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(IMLIB2_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(IMLIB2_PACKAGE) \
	$(IMLIB2_SITE)/$(IMLIB2_PACKAGE)
ifeq ($(CONFIG_EMBTK_IMLIB2_NEED_PATCH),y)
	@test -e $(DOWNLOAD_DIR)/imlib2-$(IMLIB2_VERSION).patch || \
	wget -O $(DOWNLOAD_DIR)/imlib2-$(IMLIB2_VERSION).patch \
	$(IMLIB2_PATCH_SITE)/imlib2-$(IMLIB2_VERSION)-*.patch
endif

$(IMLIB2_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(IMLIB2_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzf $(DOWNLOAD_DIR)/$(IMLIB2_PACKAGE)
ifeq ($(CONFIG_EMBTK_IMLIB2_NEED_PATCH),y)
	@cd $(PACKAGES_BUILD)/imlib2-$(IMLIB2_VERSION); \
	patch -p1 < $(DOWNLOAD_DIR)/imlib2-$(IMLIB2_VERSION).patch
endif
	@touch $@

$(IMLIB2_BUILD_DIR)/.configured:
	$(Q)cd $(IMLIB2_BUILD_DIR); \
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

imlib2_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup imlib2...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(IMLIB2_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(IMLIB2_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(IMLIB2_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(IMLIB2_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(IMLIB2_PKGCONFIGS)
	$(Q)-rm -rf $(IMLIB2_BUILD_DIR)*

.PHONY: $(IMLIB2_BUILD_DIR)/.special

$(IMLIB2_BUILD_DIR)/.special:
	$(Q)mkdir -p $(ROOTFS)/usr/$(LIBDIR)
	$(Q)-cp -R $(SYSROOT)/usr/$(LIBDIR)/imlib2 $(ROOTFS)/usr/$(LIBDIR)
	$(Q)-mkdir -p $(ROOTFS)/usr/share
	$(Q)-cp -R $(SYSROOT)/usr/share/imlib2 $(ROOTFS)/usr/share
	@touch $@
