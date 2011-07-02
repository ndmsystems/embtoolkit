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
# GNU General Public License kbprotor more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
################################################################################
#
# \file         kbproto.mk
# \brief	kbproto.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         February 2010
################################################################################

KBPROTO_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_KBPROTO_VERSION_STRING)))
KBPROTO_SITE := http://xorg.freedesktop.org/archive/individual/proto
KBPROTO_PACKAGE := kbproto-$(KBPROTO_VERSION).tar.bz2
KBPROTO_BUILD_DIR := $(PACKAGES_BUILD)/kbproto-$(KBPROTO_VERSION)

KBPROTO_BINS =
KBPROTO_SBINS =
KBPROTO_INCLUDES = X11/extensions/XKBgeom.h X11/extensions/XKB.h \
		X11/extensions/XKBproto.h X11/extensions/XKBsrv.h \
		X11/extensions/XKBstr.h
KBPROTO_LIBS =
KBPROTO_PKGCONFIGS = kbproto.pc

kbproto_install:
	@test -e $(KBPROTO_BUILD_DIR)/.installed || \
	$(MAKE) $(KBPROTO_BUILD_DIR)/.installed

$(KBPROTO_BUILD_DIR)/.installed: download_kbproto \
	$(KBPROTO_BUILD_DIR)/.decompressed $(KBPROTO_BUILD_DIR)/.configured
	$(call embtk_generic_message,"Compiling and installing \
	kbproto-$(KBPROTO_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(KBPROTO_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(KBPROTO_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_kbproto:
	$(call embtk_generic_message,"Downloading $(KBPROTO_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(KBPROTO_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(KBPROTO_PACKAGE) \
	$(KBPROTO_SITE)/$(KBPROTO_PACKAGE)

$(KBPROTO_BUILD_DIR)/.decompressed:
	$(call embtk_generic_message,"Decompressing $(KBPROTO_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(KBPROTO_PACKAGE)
	@touch $@

$(KBPROTO_BUILD_DIR)/.configured:
	$(Q)cd $(KBPROTO_BUILD_DIR); \
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

kbproto_clean:
	$(call embtk_generic_message,"cleanup kbproto...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(KBPROTO_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(KBPROTO_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(KBPROTO_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(KBPROTO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(KBPROTO_PKGCONFIGS)
	$(Q)-rm -rf $(KBPROTO_BUILD_DIR)*

