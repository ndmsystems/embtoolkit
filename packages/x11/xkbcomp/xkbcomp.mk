################################################################################
# Embtoolkit
# Copyright(C) 2010 Abdoulaye Walsimou GAYE. All rights reserved.
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
# \file         xkbcomp.mk
# \brief	xkbcomp.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

XKBCOMP_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_XKBCOMP_VERSION_STRING)))
XKBCOMP_SITE := http://xorg.freedesktop.org/archive/individual/app
XKBCOMP_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/xkbcomp/$(XKBCOMP_VERSION)
XKBCOMP_PACKAGE := xkbcomp-$(XKBCOMP_VERSION).tar.bz2
XKBCOMP_BUILD_DIR := $(PACKAGES_BUILD)/xkbcomp-$(XKBCOMP_VERSION)

XKBCOMP_BINS = xkbcomp
XKBCOMP_SBINS =
XKBCOMP_INCLUDES =
XKBCOMP_LIBS =
XKBCOMP_PKGCONFIGS =

XKBCOMP_DEPS = libxkbfile_install

xkbcomp_install:
	@test -e $(XKBCOMP_BUILD_DIR)/.installed || \
	$(MAKE) $(XKBCOMP_BUILD_DIR)/.installed

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
ifeq ($(CONFIG_EMBTK_XKBCOMP_NEED_PATCH),y)
	@test -e $(DOWNLOAD_DIR)/xkbcomp-$(XKBCOMP_VERSION).patch || \
	wget -O $(DOWNLOAD_DIR)/xkbcomp-$(XKBCOMP_VERSION).patch \
	$(XKBCOMP_PATCH_SITE)/xkbcomp-$(XKBCOMP_VERSION)-*.patch
endif

$(XKBCOMP_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(XKBCOMP_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjf $(DOWNLOAD_DIR)/$(XKBCOMP_PACKAGE)
ifeq ($(CONFIG_EMBTK_XKBCOMP_NEED_PATCH),y)
	@cd $(XKBCOMP_BUILD_DIR); \
	patch -p1 < $(DOWNLOAD_DIR)/xkbcomp-$(XKBCOMP_VERSION).patch
endif
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
	$(call EMBTK_GENERIC_MESSAGE,"cleanup xkbcomp...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(XKBCOMP_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(XKBCOMP_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(XKBCOMP_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(XKBCOMP_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(XKBCOMP_PKGCONFIGS)
	$(Q)-rm -rf $(XKBCOMP_BUILD_DIR)*

