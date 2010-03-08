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
# \file         xkbcomp.mk
# \brief	xkbcomp.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         March 2010
################################################################################

XKBCOMP_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_XKBCOMP_VERSION_STRING)))
XKBCOMP_SITE := http://xorg.freedesktop.org/archive/individual/app/
XKBCOMP_PACKAGE := xkbcomp-$(XKBCOMP_VERSION).tar.bz2
XKBCOMP_BUILD_DIR := $(PACKAGES_BUILD)/xkbcomp-$(XKBCOMP_VERSION)

XKBCOMP_BINS = xkbcomp
XKBCOMP_SBINS =
XKBCOMP_INCLUDES =
XKBCOMP_LIBS =
XKBCOMP_PKGCONFIGS =

XKBCOMP_DEPS = libxkbfile_install
xkbcomp_install: $(XKBCOMP_BUILD_DIR)/.installed

$(XKBCOMP_BUILD_DIR)/.installed: $(XKBCOMP_DEPS) download_xkbcomp \
	$(XKBCOMP_BUILD_DIR)/.decompressed $(XKBCOMP_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	xkbcomp-$(XKBCOMP_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(XKBCOMP_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(XKBCOMP_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_xkbcomp:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(XKBCOMP_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(XKBCOMP_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(XKBCOMP_PACKAGE) \
	$(XKBCOMP_SITE)/$(XKBCOMP_PACKAGE)

$(XKBCOMP_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(XKBCOMP_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjf $(DOWNLOAD_DIR)/$(XKBCOMP_PACKAGE)
	@touch $@

$(XKBCOMP_BUILD_DIR)/.configured:
	$(Q)cd $(XKBCOMP_BUILD_DIR); \
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

xkbcomp_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup xkbcomp-$(XKBCOMP_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(XKBCOMP_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(XKBCOMP_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(XKBCOMP_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(XKBCOMP_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(XKBCOMP_PKGCONFIGS)

