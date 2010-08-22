################################################################################
# Embtoolkit
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
# \file         xkeyboardconfig.mk
# \brief	xkeyboardconfig.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
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

xkeyboardconfig_install:
	@test -e $(XKEYBOARDCONFIG_BUILD_DIR)/.installed || \
	$(MAKE) $(XKEYBOARDCONFIG_BUILD_DIR)/.installed
	$(MAKE) $(XKEYBOARDCONFIG_BUILD_DIR)/.special

$(XKEYBOARDCONFIG_BUILD_DIR)/.installed: $(XKEYBOARDCONFIG_DEPS) \
	download_xkeyboardconfig $(XKEYBOARDCONFIG_BUILD_DIR)/.decompressed \
	$(XKEYBOARDCONFIG_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	xkeyboardconfig-$(XKEYBOARDCONFIG_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(XKEYBOARDCONFIG_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(XKEYBOARDCONFIG_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
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
	$(call EMBTK_GENERIC_MESSAGE,"cleanup xkeyboardconfig...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(XKEYBOARDCONFIG_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(XKEYBOARDCONFIG_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(XKEYBOARDCONFIG_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(XKEYBOARDCONFIG_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(XKEYBOARDCONFIG_PKGCONFIGS)
	$(Q)-rm -rf $(XKEYBOARDCONFIG_BUILD_DIR)

.PHONY: $(XKEYBOARDCONFIG_BUILD_DIR)/.special

$(XKEYBOARDCONFIG_BUILD_DIR)/.special:
	$(Q)-mkdir -p $(ROOTFS)/usr/share
	$(Q)-mkdir -p $(ROOTFS)/usr/share/X11
	$(Q)-cp -R $(SYSROOT)/usr/share/X11/xkb $(ROOTFS)/usr/share/X11/
	@touch $@
