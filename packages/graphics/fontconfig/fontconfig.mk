################################################################################
# Embtoolkit
# Copyright(C) 2009-2011 Abdoulaye Walsimou GAYE.
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
# \file         fontconfig.mk
# \brief	fontconfig.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

FONTCONFIG_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_FONTCONFIG_VERSION_STRING)))
FONTCONFIG_SITE := http://fontconfig.org/release
FONTCONFIG_PACKAGE := fontconfig-$(FONTCONFIG_VERSION).tar.gz
FONTCONFIG_BUILD_DIR := $(PACKAGES_BUILD)/fontconfig-$(FONTCONFIG_VERSION)

FONTCONFIG_BINS = fc-cache fc-cat fc-list fc-match fc-query fc-scan
FONTCONFIG_SBINS =
FONTCONFIG_INCLUDES = fontconfig
FONTCONFIG_LIBS = libfontconfig*
FONTCONFIG_PKGCONFIGS = fontconfig.pc

ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
LIBXML2_CFLAGS="-I$(SYSROOT)/usr/include/libxml2 -L$(SYSROOT)/usr/lib32"
else
LIBXML2_CFLAGS="-I$(SYSROOT)/usr/include/libxml2 -L$(SYSROOT)/usr/lib"
endif

fontconfig_install:
	@test -e $(FONTCONFIG_BUILD_DIR)/.installed || \
	$(MAKE) $(FONTCONFIG_BUILD_DIR)/.installed
	$(MAKE) $(FONTCONFIG_BUILD_DIR)/.special

$(FONTCONFIG_BUILD_DIR)/.installed: libxml2_install \
	download_fontconfig $(FONTCONFIG_BUILD_DIR)/.decompressed \
	$(FONTCONFIG_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	fontconfig-$(FONTCONFIG_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH, $(FONTCONFIG_BUILD_DIR))
	$(Q)$(MAKE) -C $(FONTCONFIG_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(FONTCONFIG_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_fontconfig:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(FONTCONFIG_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(FONTCONFIG_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(FONTCONFIG_PACKAGE) \
	$(FONTCONFIG_SITE)/$(FONTCONFIG_PACKAGE)

$(FONTCONFIG_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(FONTCONFIG_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzvf $(DOWNLOAD_DIR)/$(FONTCONFIG_PACKAGE)
	@touch $@

$(FONTCONFIG_BUILD_DIR)/.configured:
	cd $(FONTCONFIG_BUILD_DIR); \
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
	PKG_CONFIG=$(PKGCONFIG_BIN) \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) --with-arch=$(STRICT_GNU_TARGET) \
	--prefix=/usr --disable-docs --program-prefix="" --libdir=/usr/$(LIBDIR)
	@touch $@

.PHONY: $(FONTCONFIG_BUILD_DIR)/.special fontconfig_clean

fontconfig_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup fontconfig...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(FONTCONFIG_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(FONTCONFIG_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(FONTCONFIG_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(FONTCONFIG_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(FONTCONFIG_PKGCONFIGS)
	$(Q)-rm -rf $(FONTCONFIG_BUILD_DIR)*

$(FONTCONFIG_BUILD_DIR)/.special:
	$(Q)-cp -R $(SYSROOT)/usr/etc/fonts $(ROOTFS)/etc/
	@touch $@

