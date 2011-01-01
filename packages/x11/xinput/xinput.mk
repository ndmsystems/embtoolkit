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
# \file         xinput.mk
# \brief	xinput.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         September 2010
################################################################################

XINPUT_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_XINPUT_VERSION_STRING)))
XINPUT_SITE := http://xorg.freedesktop.org/archive/individual/app
XINPUT_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/xinput/$(XINPUT_VERSION)
XINPUT_PACKAGE := xinput-$(XINPUT_VERSION).tar.bz2
XINPUT_BUILD_DIR := $(PACKAGES_BUILD)/xinput-$(XINPUT_VERSION)

XINPUT_BINS = xinput
XINPUT_SBINS =
XINPUT_INCLUDES =
XINPUT_LIBS =
XINPUT_PKGCONFIGS =

XINPUT_DEPS := xproto_install inputproto_install libx11_install \
	libxext_install libxi_install

xinput_install:
	@test -e $(XINPUT_BUILD_DIR)/.installed || \
	$(MAKE) $(XINPUT_BUILD_DIR)/.installed

$(XINPUT_BUILD_DIR)/.installed: $(XINPUT_DEPS) download_xinput \
	$(XINPUT_BUILD_DIR)/.decompressed $(XINPUT_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	xinput-$(XINPUT_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH,$(XINPUT_BUILD_DIR))
	$(Q)$(MAKE) -C $(XINPUT_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(XINPUT_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_xinput:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(XINPUT_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(XINPUT_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(XINPUT_PACKAGE) \
	$(XINPUT_SITE)/$(XINPUT_PACKAGE)
ifeq ($(CONFIG_EMBTK_XINPUT_NEED_PATCH),y)
	@test -e $(DOWNLOAD_DIR)/xinput-$(XINPUT_VERSION).patch || \
	wget -O $(DOWNLOAD_DIR)/xinput-$(XINPUT_VERSION).patch \
	$(XINPUT_PATCH_SITE)/xinput-$(XINPUT_VERSION)-*.patch
endif

$(XINPUT_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(XINPUT_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjf $(DOWNLOAD_DIR)/$(XINPUT_PACKAGE)
ifeq ($(CONFIG_EMBTK_XINPUT_NEED_PATCH),y)
	@cd $(XINPUT_BUILD_DIR); \
	patch -p1 < $(DOWNLOAD_DIR)/xinput-$(XINPUT_VERSION).patch
endif
	@touch $@

$(XINPUT_BUILD_DIR)/.configured:
	$(Q)cd $(XINPUT_BUILD_DIR); \
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

xinput_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup xinput...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(XINPUT_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(XINPUT_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(XINPUT_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(XINPUT_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(XINPUT_PKGCONFIGS)
	$(Q)-rm -rf $(XINPUT_BUILD_DIR)*

