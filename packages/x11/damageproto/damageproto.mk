################################################################################
# GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# Copyright(C) 2009 GAYE Abdoulaye Walsimou. All rights reserved.
#
# This program is free software; you can distribute it and/or modify it
# under the terms of the GNU General Public License
# (Version 2 or later) published by the Free Software Foundation.
#
# This program is distributed in the hope it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
################################################################################
#
# \file         damageproto.mk
# \brief	damageproto.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
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

damageproto_install: $(DAMAGEPROTO_BUILD_DIR)/.installed

$(DAMAGEPROTO_BUILD_DIR)/.installed: download_damageproto \
	$(DAMAGEPROTO_BUILD_DIR)/.decompressed $(DAMAGEPROTO_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	damageproto-$(DAMAGEPROTO_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(DAMAGEPROTO_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(DAMAGEPROTO_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_damageproto:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(DAMAGEPROTO_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(DAMAGEPROTO_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(DAMAGEPROTO_PACKAGE) \
	$(DAMAGEPROTO_SITE)/$(DAMAGEPROTO_PACKAGE)

$(DAMAGEPROTO_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(DAMAGEPROTO_PACKAGE) ...")
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
	PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) \
	--prefix=/usr --libdir=/usr/$(LIBDIR)
	@touch $@

damageproto_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup damageproto-$(DAMAGEPROTO_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(DAMAGEPROTO_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(DAMAGEPROTO_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(DAMAGEPROTO_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/lib; rm -rf $(DAMAGEPROTO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib/pkgconfig; rm -rf $(DAMAGEPROTO_PKGCONFIGS)
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cd $(SYSROOT)/usr/lib32; rm -rf $(DAMAGEPROTO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib32/pkgconfig; rm -rf $(DAMAGEPROTO_PKGCONFIGS)
endif

