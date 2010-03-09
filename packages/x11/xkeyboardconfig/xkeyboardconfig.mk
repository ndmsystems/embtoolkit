################################################################################
# GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# Copyright(C) 2010 GAYE Abdoulaye Walsimou. All rights reserved.
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
# \file         xkeyboardconfig.mk
# \brief	xkeyboardconfig.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         March 2010
################################################################################

XKEYBOARDCONFIG_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_XKEYBOARDCONFIG_VERSION_STRING)))
XKEYBOARDCONFIG_SITE := http://xlibs.freedesktop.org/xkbdesc
XKEYBOARDCONFIG_PACKAGE := xkeyboard-config-$(XKEYBOARDCONFIG_VERSION).tar.bz2
XKEYBOARDCONFIG_BUILD_DIR := $(PACKAGES_BUILD)/xkeyboard-config-$(XKEYBOARDCONFIG_VERSION)

XKEYBOARDCONFIG_BINS =
XKEYBOARDCONFIG_SBINS =
XKEYBOARDCONFIG_INCLUDES =
XKEYBOARDCONFIG_LIBS =
XKEYBOARDCONFIG_PKGCONFIGS =

XKEYBOARDCONFIG_DEPS = xkbcomp_install

xkeyboardconfig_install: $(XKEYBOARDCONFIG_BUILD_DIR)/.installed

$(XKEYBOARDCONFIG_BUILD_DIR)/.installed: $(XKEYBOARDCONFIG_DEPS) \
	download_xkeyboardconfig $(XKEYBOARDCONFIG_BUILD_DIR)/.decompressed \
	$(XKEYBOARDCONFIG_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	xkeyboardconfig-$(XKEYBOARDCONFIG_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(XKEYBOARDCONFIG_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(XKEYBOARDCONFIG_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	$(Q)-mkdir -p $(ROOTFS)/usr/share/X11
	$(Q)-cp -R $(SYSROOT)/usr/share/X11/xkb $(ROOTFS)/usr/share/X11/
	@touch $@

download_xkeyboardconfig:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(XKEYBOARDCONFIG_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(XKEYBOARDCONFIG_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(XKEYBOARDCONFIG_PACKAGE) \
	$(XKEYBOARDCONFIG_SITE)/$(XKEYBOARDCONFIG_PACKAGE)

$(XKEYBOARDCONFIG_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(XKEYBOARDCONFIG_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjf $(DOWNLOAD_DIR)/$(XKEYBOARDCONFIG_PACKAGE)
	@touch $@

$(XKEYBOARDCONFIG_BUILD_DIR)/.configured:
	$(Q)cd $(XKEYBOARDCONFIG_BUILD_DIR); \
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
	--target=$(STRICT_GNU_TARGET) --libdir=/usr/$(LIBDIR) \
	--prefix=/usr
	@touch $@

xkeyboardconfig_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup xkeyboardconfig-$(XKEYBOARDCONFIG_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(XKEYBOARDCONFIG_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(XKEYBOARDCONFIG_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(XKEYBOARDCONFIG_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(XKEYBOARDCONFIG_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(XKEYBOARDCONFIG_PKGCONFIGS)

