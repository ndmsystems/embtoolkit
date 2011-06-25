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
# \file         compositeproto.mk
# \brief	compositeproto.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@wembtoolkit.org>
# \date         March 2010
################################################################################

COMPOSITEPROTO_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_COMPOSITEPROTO_VERSION_STRING)))
COMPOSITEPROTO_SITE := http://ftp.x.org/pub/individual/proto
COMPOSITEPROTO_PACKAGE := compositeproto-$(COMPOSITEPROTO_VERSION).tar.bz2
COMPOSITEPROTO_BUILD_DIR := $(PACKAGES_BUILD)/compositeproto-$(COMPOSITEPROTO_VERSION)

COMPOSITEPROTO_BINS =
COMPOSITEPROTO_SBINS =
COMPOSITEPROTO_INCLUDES = X11/extensions/compositeproto.h \
			X11/extensions/composite.h
COMPOSITEPROTO_LIBS =
COMPOSITEPROTO_PKGCONFIGS = compositeproto.pc

compositeproto_install:
	@test -e $(COMPOSITEPROTO_BUILD_DIR)/.installed || \
	$(MAKE) $(COMPOSITEPROTO_BUILD_DIR)/.installed

$(COMPOSITEPROTO_BUILD_DIR)/.installed: download_compositeproto \
	$(COMPOSITEPROTO_BUILD_DIR)/.decompressed $(COMPOSITEPROTO_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	compositeproto-$(COMPOSITEPROTO_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(COMPOSITEPROTO_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(COMPOSITEPROTO_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_compositeproto:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(COMPOSITEPROTO_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(COMPOSITEPROTO_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(COMPOSITEPROTO_PACKAGE) \
	$(COMPOSITEPROTO_SITE)/$(COMPOSITEPROTO_PACKAGE)

$(COMPOSITEPROTO_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(COMPOSITEPROTO_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(COMPOSITEPROTO_PACKAGE)
	@touch $@

$(COMPOSITEPROTO_BUILD_DIR)/.configured:
	$(Q)cd $(COMPOSITEPROTO_BUILD_DIR); \
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
	--target=$(STRICT_GNU_TARGET) --libdir=/usr/$(LIBDIR) --prefix=/usr \
	--disable-malloc0returnsnull
	@touch $@

compositeproto_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup compositeproto-$(COMPOSITEPROTO_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(COMPOSITEPROTO_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(COMPOSITEPROTO_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(COMPOSITEPROTO_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(COMPOSITEPROTO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(COMPOSITEPROTO_PKGCONFIGS)
	$(Q)-rm -rf $(COMPOSITEPROTO_BUILD_DIR)*

