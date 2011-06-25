################################################################################
# Embtoolkit
# Copyright(C) 2010-2011 Abdoulaye Walsimou GAYE.
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
# \file         fontsproto.mk
# \brief	fontsproto.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         February 2010
################################################################################

FONTSPROTO_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_FONTSPROTO_VERSION_STRING)))
FONTSPROTO_SITE := http://xorg.freedesktop.org/archive/individual/proto
FONTSPROTO_PACKAGE := fontsproto-$(FONTSPROTO_VERSION).tar.bz2
FONTSPROTO_BUILD_DIR := $(PACKAGES_BUILD)/fontsproto-$(FONTSPROTO_VERSION)

FONTSPROTO_BINS =
FONTSPROTO_SBINS =
FONTSPROTO_INCLUDES = X11/fonts/font.h X11/fonts/fontproto.h \
		X11/fonts/fontstruct.h X11/fonts/FS.h X11/fonts/fsmasks.h \
		X11/fonts/FSproto.h
FONTSPROTO_LIBS =
FONTSPROTO_PKGCONFIGS = fontsproto.pc

fontsproto_install:
	@test -e $(FONTSPROTO_BUILD_DIR)/.installed || \
	$(MAKE) $(FONTSPROTO_BUILD_DIR)/.installed

$(FONTSPROTO_BUILD_DIR)/.installed: download_fontsproto \
	$(FONTSPROTO_BUILD_DIR)/.decompressed $(FONTSPROTO_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	fontsproto-$(FONTSPROTO_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(FONTSPROTO_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(FONTSPROTO_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_fontsproto:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(FONTSPROTO_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(FONTSPROTO_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(FONTSPROTO_PACKAGE) \
	$(FONTSPROTO_SITE)/$(FONTSPROTO_PACKAGE)

$(FONTSPROTO_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(FONTSPROTO_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(FONTSPROTO_PACKAGE)
	@touch $@

$(FONTSPROTO_BUILD_DIR)/.configured:
	$(Q)cd $(FONTSPROTO_BUILD_DIR); \
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
	PKG_CONFIG_PATH=$(EMBTK_PKG_CONFIG_PATH) \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) --prefix=/usr --libdir=/usr/$(LIBDIR) \
	--disable-malloc0returnsnull
	@touch $@

fontsproto_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup fontsproto...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(FONTSPROTO_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(FONTSPROTO_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(FONTSPROTO_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(FONTSPROTO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(FONTSPROTO_PKGCONFIGS)
	$(Q)-rm -rf $(FONTSPROTO_BUILD_DIR)*

