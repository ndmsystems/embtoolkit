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
# \file         atk.mk
# \brief	atk.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         December 2009
################################################################################

ATK_MAJOR_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_ATK_MAJOR_VERSION_STRING)))
ATK_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_ATK_VERSION_STRING)))
ATK_SITE := http://ftp.gnome.org/pub/gnome/sources/atk/$(ATK_MAJOR_VERSION)
ATK_PACKAGE := atk-$(ATK_VERSION).tar.bz2
ATK_BUILD_DIR := $(PACKAGES_BUILD)/atk-$(ATK_VERSION)

ATK_BINS =
ATK_SBINS =
ATK_INCLUDES = atk-*
ATK_LIBS = libatk-*
ATK_PKGCONFIGS = atk.pc

ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
PKG_CONFIG_PATH=$(SYSROOT)/usr/lib32/pkgconfig
else
PKG_CONFIG_PATH=$(SYSROOT)/usr/lib/pkgconfig
endif

atk_install: $(ATK_BUILD_DIR)/.installed

$(ATK_BUILD_DIR)/.installed: glib_install download_atk \
	$(ATK_BUILD_DIR)/.decompressed $(ATK_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	atk-$(ATK_VERSION) in your root filesystem...")
	$(call KILL_LT_RPATH, $(ATK_BUILD_DIR))
	$(Q)$(MAKE) -C $(ATK_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(ATK_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_atk:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(ATK_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(ATK_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(ATK_PACKAGE) \
	$(ATK_SITE)/$(ATK_PACKAGE)

$(ATK_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(ATK_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjf $(DOWNLOAD_DIR)/$(ATK_PACKAGE)
	@touch $@

$(ATK_BUILD_DIR)/.configured:
	$(Q)cd $(ATK_BUILD_DIR); \
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
	LDFLAGS="-L$(SYSROOT)/lib -L$(SYSROOT)/usr/lib \
	-L$(SYSROOT)/lib32 -L$(SYSROOT)/usr/lib32" \
	CPPFLGAS="-I$(SYSROOT)/usr/include" \
	PKG_CONFIG=$(PKGCONFIG_BIN) \
	PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) \
	--prefix=/usr
	@touch $@

atk_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup atk-$(ATK_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(ATK_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(ATK_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(ATK_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/lib; rm -rf $(ATK_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib/pkgconfig; rm -rf $(ATK_PKGCONFIGS)
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cd $(SYSROOT)/usr/lib32; rm -rf $(ATK_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib32/pkgconfig; rm -rf $(ATK_PKGCONFIGS)
endif

