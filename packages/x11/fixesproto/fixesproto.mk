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
# \file         fixesproto.mk
# \brief	fixesproto.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         February 2010
################################################################################

FIXESPROTO_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_FIXESPROTO_VERSION_STRING)))
FIXESPROTO_SITE := http://xorg.freedesktop.org/archive/individual/proto
FIXESPROTO_PACKAGE := fixesproto-$(FIXESPROTO_VERSION).tar.bz2
FIXESPROTO_BUILD_DIR := $(PACKAGES_BUILD)/fixesproto-$(FIXESPROTO_VERSION)

FIXESPROTO_BINS =
FIXESPROTO_SBINS =
FIXESPROTO_INCLUDES = X11/extensions/xfixesproto.h X11/extensions/xfixeswire.h
FIXESPROTO_LIBS =
FIXESPROTO_PKGCONFIGS = fixesproto.pc

fixesproto_install:
	@test -e $(FIXESPROTO_BUILD_DIR)/.installed || \
	$(MAKE) $(FIXESPROTO_BUILD_DIR)/.installed

$(FIXESPROTO_BUILD_DIR)/.installed: download_fixesproto \
	$(FIXESPROTO_BUILD_DIR)/.decompressed $(FIXESPROTO_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	fixesproto-$(FIXESPROTO_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(FIXESPROTO_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(FIXESPROTO_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_fixesproto:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(FIXESPROTO_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(FIXESPROTO_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(FIXESPROTO_PACKAGE) \
	$(FIXESPROTO_SITE)/$(FIXESPROTO_PACKAGE)

$(FIXESPROTO_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(FIXESPROTO_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(FIXESPROTO_PACKAGE)
	@touch $@

$(FIXESPROTO_BUILD_DIR)/.configured:
	$(Q)cd $(FIXESPROTO_BUILD_DIR); \
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

fixesproto_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup fixesproto-$(FIXESPROTO_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(FIXESPROTO_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(FIXESPROTO_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(FIXESPROTO_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(FIXESPROTO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(FIXESPROTO_PKGCONFIGS)
	$(Q)-rm -rf $(FIXESPROTO_BUILD_DIR)*

