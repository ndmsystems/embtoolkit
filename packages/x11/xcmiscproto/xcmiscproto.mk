################################################################################
# Embtoolkit
# Copyright(C) 2010-2011 Abdoulaye Walsimou GAYE. All rights reserved.
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
# \file         xcmiscproto.mk
# \brief	xcmiscproto.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

XCMISCPROTO_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_XCMISCPROTO_VERSION_STRING)))
XCMISCPROTO_SITE := http://xorg.freedesktop.org/archive/individual/proto
XCMISCPROTO_PACKAGE := xcmiscproto-$(XCMISCPROTO_VERSION).tar.bz2
XCMISCPROTO_BUILD_DIR := $(PACKAGES_BUILD)/xcmiscproto-$(XCMISCPROTO_VERSION)

XCMISCPROTO_BINS =
XCMISCPROTO_SBINS =
XCMISCPROTO_INCLUDES = X11/extensions/xcmiscproto.h X11/extensions/xcmiscstr.h
XCMISCPROTO_LIBS =
XCMISCPROTO_PKGCONFIGS = xcmiscproto.pc

xcmiscproto_install:
	@test -e $(XCMISCPROTO_BUILD_DIR)/.installed || \
	$(MAKE) $(XCMISCPROTO_BUILD_DIR)/.installed

$(XCMISCPROTO_BUILD_DIR)/.installed: download_xcmiscproto \
	$(XCMISCPROTO_BUILD_DIR)/.decompressed $(XCMISCPROTO_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	xcmiscproto-$(XCMISCPROTO_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(XCMISCPROTO_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(XCMISCPROTO_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_xcmiscproto:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(XCMISCPROTO_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(XCMISCPROTO_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(XCMISCPROTO_PACKAGE) \
	$(XCMISCPROTO_SITE)/$(XCMISCPROTO_PACKAGE)

$(XCMISCPROTO_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(XCMISCPROTO_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(XCMISCPROTO_PACKAGE)
	@touch $@

$(XCMISCPROTO_BUILD_DIR)/.configured:
	$(Q)cd $(XCMISCPROTO_BUILD_DIR); \
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

xcmiscproto_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup xcmiscproto-$(XCMISCPROTO_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(XCMISCPROTO_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(XCMISCPROTO_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(XCMISCPROTO_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(XCMISCPROTO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(XCMISCPROTO_PKGCONFIGS)
	$(Q)-rm -rf $(XCMISCPROTO_BUILD_DIR)*

