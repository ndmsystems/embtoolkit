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
# \file         libpciaccess.mk
# \brief	libpciaccess.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

LIBPCIACCESS_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_LIBPCIACCESS_VERSION_STRING)))
LIBPCIACCESS_SITE := http://xorg.freedesktop.org/archive/individual/lib
LIBPCIACCESS_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/libpciaccess/$(LIBPCIACCESS_VERSION)
LIBPCIACCESS_PACKAGE := libpciaccess-$(LIBPCIACCESS_VERSION).tar.gz
LIBPCIACCESS_BUILD_DIR := $(PACKAGES_BUILD)/libpciaccess-$(LIBPCIACCESS_VERSION)

LIBPCIACCESS_BINS =
LIBPCIACCESS_SBINS =
LIBPCIACCESS_INCLUDES = pciaccess.h
LIBPCIACCESS_LIBS = libpciaccess.*
LIBPCIACCESS_PKGCONFIGS = pciaccess.pc

LIBPCIACCESS_DEPS =

libpciaccess_install:
	@test -e $(LIBPCIACCESS_BUILD_DIR)/.installed || \
	$(MAKE) $(LIBPCIACCESS_BUILD_DIR)/.installed

$(LIBPCIACCESS_BUILD_DIR)/.installed: $(LIBPCIACCESS_DEPS) \
	download_libpciaccess $(LIBPCIACCESS_BUILD_DIR)/.decompressed \
	$(LIBPCIACCESS_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	libpciaccess-$(LIBPCIACCESS_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH,$(LIBPCIACCESS_BUILD_DIR))
	$(Q)$(MAKE) -C $(LIBPCIACCESS_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBPCIACCESS_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_libpciaccess:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(LIBPCIACCESS_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(LIBPCIACCESS_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(LIBPCIACCESS_PACKAGE) \
	$(LIBPCIACCESS_SITE)/$(LIBPCIACCESS_PACKAGE)
ifeq ($(CONFIG_EMBTK_LIBPCIACCESS_NEED_PATCH),y)
	@test -e $(DOWNLOAD_DIR)/libpciaccess-$(LIBPCIACCESS_VERSION).patch || \
	wget -O $(DOWNLOAD_DIR)/libpciaccess-$(LIBPCIACCESS_VERSION).patch \
	$(LIBPCIACCESS_PATCH_SITE)/libpciaccess-$(LIBPCIACCESS_VERSION)-*.patch
endif

$(LIBPCIACCESS_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LIBPCIACCESS_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzf $(DOWNLOAD_DIR)/$(LIBPCIACCESS_PACKAGE)
ifeq ($(CONFIG_EMBTK_LIBPCIACCESS_NEED_PATCH),y)
	@cd $(PACKAGES_BUILD)/libpciaccess-$(LIBPCIACCESS_VERSION); \
	patch -p1 < $(DOWNLOAD_DIR)/libpciaccess-$(LIBPCIACCESS_VERSION).patch
endif
	@touch $@

$(LIBPCIACCESS_BUILD_DIR)/.configured:
	$(Q)cd $(LIBPCIACCESS_BUILD_DIR); \
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

libpciaccess_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup libpciaccess...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(LIBPCIACCESS_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(LIBPCIACCESS_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(LIBPCIACCESS_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(LIBPCIACCESS_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(LIBPCIACCESS_PKGCONFIGS)
	$(Q)-rm -rf $(LIBPCIACCESS_BUILD_DIR)*

