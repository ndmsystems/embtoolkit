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
# \file         libxfixes.mk
# \brief	libxfixes.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         June 2010
################################################################################

LIBXFIXES_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_LIBXFIXES_VERSION_STRING)))
LIBXFIXES_SITE := http://xorg.freedesktop.org/archive/individual/lib
LIBXFIXES_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/libxfixes/$(LIBXFIXES_VERSION)
LIBXFIXES_PACKAGE := libXfixes-$(LIBXFIXES_VERSION).tar.bz2
LIBXFIXES_BUILD_DIR := $(PACKAGES_BUILD)/libXfixes-$(LIBXFIXES_VERSION)

LIBXFIXES_BINS =
LIBXFIXES_SBINS =
LIBXFIXES_INCLUDES = X11/extensions/Xfixes.h
LIBXFIXES_LIBS = libXfixes.*
LIBXFIXES_PKGCONFIGS =xfixes.pc

LIBXFIXES_DEPS = xproto_install fixesproto_install

libxfixes_install: $(LIBXFIXES_BUILD_DIR)/.installed

$(LIBXFIXES_BUILD_DIR)/.installed: $(LIBXFIXES_DEPS) download_libxfixes \
	$(LIBXFIXES_BUILD_DIR)/.decompressed $(LIBXFIXES_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	libxfixes-$(LIBXFIXES_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH,$(LIBXFIXES_BUILD_DIR))
	$(Q)$(MAKE) -C $(LIBXFIXES_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBXFIXES_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_libxfixes:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(LIBXFIXES_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(LIBXFIXES_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(LIBXFIXES_PACKAGE) \
	$(LIBXFIXES_SITE)/$(LIBXFIXES_PACKAGE)
ifeq ($(CONFIG_EMBTK_LIBXFIXES_NEED_PATCH),y)
	@test -e $(DOWNLOAD_DIR)/libxfixes-$(LIBXFIXES_VERSION).patch || \
	wget -O $(DOWNLOAD_DIR)/libxfixes-$(LIBXFIXES_VERSION).patch \
	$(LIBXFIXES_PATCH_SITE)/libxfixes-$(LIBXFIXES_VERSION)-*.patch
endif

$(LIBXFIXES_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LIBXFIXES_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjf $(DOWNLOAD_DIR)/$(LIBXFIXES_PACKAGE)
ifeq ($(CONFIG_EMBTK_LIBXFIXES_NEED_PATCH),y)
	@cd $(PACKAGES_BUILD)/libxfixes-$(LIBXFIXES_VERSION); \
	patch -p1 < $(DOWNLOAD_DIR)/libxfixes-$(LIBXFIXES_VERSION).patch
endif
	@touch $@

$(LIBXFIXES_BUILD_DIR)/.configured:
	$(Q)cd $(LIBXFIXES_BUILD_DIR); \
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

libxfixes_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup libxfixes-$(LIBXFIXES_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(LIBXFIXES_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(LIBXFIXES_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(LIBXFIXES_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(LIBXFIXES_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(LIBXFIXES_PKGCONFIGS)

