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
# \file         inputproto.mk
# \brief	inputproto.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         February 2010
################################################################################

INPUTPROTO_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_INPUTPROTO_VERSION_STRING)))
INPUTPROTO_SITE := http://xorg.freedesktop.org/archive/individual/proto
INPUTPROTO_PACKAGE := inputproto-$(INPUTPROTO_VERSION).tar.bz2
INPUTPROTO_BUILD_DIR := $(PACKAGES_BUILD)/inputproto-$(INPUTPROTO_VERSION)

INPUTPROTO_BINS =
INPUTPROTO_SBINS =
INPUTPROTO_INCLUDES = X11/extensions/XI2.h X11/extensions/XI2proto.h \
		X11/extensions/XI.h X11/extensions/XIproto.h
INPUTPROTO_LIBS =
INPUTPROTO_PKGCONFIGS = inputproto.pc

inputproto_install:
	@test -e $(INPUTPROTO_BUILD_DIR)/.installed || \
	$(MAKE) $(INPUTPROTO_BUILD_DIR)/.installed

$(INPUTPROTO_BUILD_DIR)/.installed: download_inputproto \
	$(INPUTPROTO_BUILD_DIR)/.decompressed $(INPUTPROTO_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	inputproto-$(INPUTPROTO_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(INPUTPROTO_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(INPUTPROTO_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_inputproto:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(INPUTPROTO_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(INPUTPROTO_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(INPUTPROTO_PACKAGE) \
	$(INPUTPROTO_SITE)/$(INPUTPROTO_PACKAGE)

$(INPUTPROTO_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(INPUTPROTO_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(INPUTPROTO_PACKAGE)
	@touch $@

$(INPUTPROTO_BUILD_DIR)/.configured:
	$(Q)cd $(INPUTPROTO_BUILD_DIR); \
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

inputproto_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup inputproto-$(INPUTPROTO_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(INPUTPROTO_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(INPUTPROTO_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(INPUTPROTO_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(INPUTPROTO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(INPUTPROTO_PKGCONFIGS)
	$(Q)-rm -rf $(INPUTPROTO_BUILD_DIR)*

