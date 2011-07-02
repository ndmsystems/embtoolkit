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
# \file         damageproto.mk
# \brief	damageproto.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

DAMAGEPROTO_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_DAMAGEPROTO_VERSION_STRING)))
DAMAGEPROTO_SITE := http://xorg.freedesktop.org/archive/individual/proto
DAMAGEPROTO_PACKAGE := damageproto-$(DAMAGEPROTO_VERSION).tar.bz2
DAMAGEPROTO_BUILD_DIR := $(PACKAGES_BUILD)/damageproto-$(DAMAGEPROTO_VERSION)

DAMAGEPROTO_BINS =
DAMAGEPROTO_SBINS =
DAMAGEPROTO_INCLUDES = X11/extnsions/damageproto.h damagewire.h
DAMAGEPROTO_LIBS =
DAMAGEPROTO_PKGCONFIGS = damageproto.pc

damageproto_install:
	@test -e $(DAMAGEPROTO_BUILD_DIR)/.installed || \
	$(MAKE) $(DAMAGEPROTO_BUILD_DIR)/.installed

$(DAMAGEPROTO_BUILD_DIR)/.installed: download_damageproto \
	$(DAMAGEPROTO_BUILD_DIR)/.decompressed $(DAMAGEPROTO_BUILD_DIR)/.configured
	$(call embtk_generic_message,"Compiling and installing \
	damageproto-$(DAMAGEPROTO_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(DAMAGEPROTO_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(DAMAGEPROTO_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_damageproto:
	$(call embtk_generic_message,"Downloading $(DAMAGEPROTO_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(DAMAGEPROTO_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(DAMAGEPROTO_PACKAGE) \
	$(DAMAGEPROTO_SITE)/$(DAMAGEPROTO_PACKAGE)

$(DAMAGEPROTO_BUILD_DIR)/.decompressed:
	$(call embtk_generic_message,"Decompressing $(DAMAGEPROTO_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(DAMAGEPROTO_PACKAGE)
	@touch $@

$(DAMAGEPROTO_BUILD_DIR)/.configured:
	$(Q)cd $(DAMAGEPROTO_BUILD_DIR); \
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

damageproto_clean:
	$(call embtk_generic_message,"cleanup damageproto-$(DAMAGEPROTO_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(DAMAGEPROTO_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(DAMAGEPROTO_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(DAMAGEPROTO_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(DAMAGEPROTO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(DAMAGEPROTO_PKGCONFIGS)
	$(Q)-rm -rf $(DAMAGEPROTO_BUILD_DIR)*

