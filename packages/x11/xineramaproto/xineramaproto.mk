################################################################################
# Abdoulaye Walsimou GAYE, <awg@embtoolkit.org>
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
# \file         xineramaproto.mk
# \brief	xineramaproto.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE, <awg@embtoolkit.org>
# \date         June 2010
################################################################################

XINERAMAPROTO_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_XINERAMAPROTO_VERSION_STRING)))
XINERAMAPROTO_SITE := http://ftp.x.org/pub/individual/proto
XINERAMAPROTO_PACKAGE := xineramaproto-$(XINERAMAPROTO_VERSION).tar.bz2
XINERAMAPROTO_BUILD_DIR := $(PACKAGES_BUILD)/xineramaproto-$(XINERAMAPROTO_VERSION)

XINERAMAPROTO_BINS =
XINERAMAPROTO_SBINS =
XINERAMAPROTO_INCLUDES = X11/extensions/panoramiXproto.h
XINERAMAPROTO_LIBS =
XINERAMAPROTO_PKGCONFIGS = xineramaproto.pc

xineramaproto_install: $(XINERAMAPROTO_BUILD_DIR)/.installed

$(XINERAMAPROTO_BUILD_DIR)/.installed: download_xineramaproto \
	$(XINERAMAPROTO_BUILD_DIR)/.decompressed $(XINERAMAPROTO_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	xineramaproto-$(XINERAMAPROTO_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(XINERAMAPROTO_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(XINERAMAPROTO_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_xineramaproto:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(XINERAMAPROTO_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(XINERAMAPROTO_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(XINERAMAPROTO_PACKAGE) \
	$(XINERAMAPROTO_SITE)/$(XINERAMAPROTO_PACKAGE)

$(XINERAMAPROTO_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(XINERAMAPROTO_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(XINERAMAPROTO_PACKAGE)
	@touch $@

$(XINERAMAPROTO_BUILD_DIR)/.configured:
	$(Q)cd $(XINERAMAPROTO_BUILD_DIR); \
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

xineramaproto_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup xineramaproto-$(XINERAMAPROTO_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(XINERAMAPROTO_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(XINERAMAPROTO_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(XINERAMAPROTO_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(XINERAMAPROTO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(XINERAMAPROTO_PKGCONFIGS)

