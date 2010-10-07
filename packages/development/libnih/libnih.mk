################################################################################
# Embtoolkit
# Copyright(C) 2009-2010 Abdoulaye Walsimou GAYE. All rights reserved.
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
# \file         libnih.mk
# \brief	libnih.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

LIBNIH_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_LIBNIH_VERSION_STRING)))
LIBNIH_MAJOR_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_LIBNIH_MAJOR_VERSION_STRING)))
LIBNIH_SITE := http://launchpad.net/libnih/$(LIBNIH_MAJOR_VERSION)/$(LIBNIH_VERSION)/+download
LIBNIH_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/libnih/$(LIBNIH_VERSION)
LIBNIH_PACKAGE := libnih-$(LIBNIH_VERSION).tar.gz
LIBNIH_BUILD_DIR := $(PACKAGES_BUILD)/libnih-$(LIBNIH_VERSION)

LIBNIH_BINS = nih-dbus-tool
LIBNIH_SBINS =
LIBNIH_INCLUDES = libnih-dbus.h libnih.h nih nih-dbus
LIBNIH_LIBS = libnih*
LIBNIH_PKGCONFIGS = libnih-dbus.pc libnih.pc

LIBNIH_DEPS := dbus_install

libnih_install:
	@test -e $(LIBNIH_BUILD_DIR)/.installed || \
	$(MAKE) $(LIBNIH_BUILD_DIR)/.installed

$(LIBNIH_BUILD_DIR)/.installed: $(LIBNIH_DEPS) download_libnih \
	$(LIBNIH_BUILD_DIR)/.decompressed $(LIBNIH_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	libnih-$(LIBNIH_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH,$(LIBNIH_BUILD_DIR))
	$(Q)$(MAKE) -C $(LIBNIH_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBNIH_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_libnih:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(LIBNIH_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(LIBNIH_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(LIBNIH_PACKAGE) \
	$(LIBNIH_SITE)/$(LIBNIH_PACKAGE)
ifeq ($(CONFIG_EMBTK_LIBNIH_NEED_PATCH),y)
	@test -e $(DOWNLOAD_DIR)/libnih-$(LIBNIH_VERSION).patch || \
	wget -O $(DOWNLOAD_DIR)/libnih-$(LIBNIH_VERSION).patch \
	$(LIBNIH_PATCH_SITE)/libnih-$(LIBNIH_VERSION)-*.patch
endif

$(LIBNIH_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LIBNIH_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzf $(DOWNLOAD_DIR)/$(LIBNIH_PACKAGE)
ifeq ($(CONFIG_EMBTK_LIBNIH_NEED_PATCH),y)
	@cd $(LIBNIH_BUILD_DIR); \
	patch -p1 < $(DOWNLOAD_DIR)/libnih-$(LIBNIH_VERSION).patch
endif
	@touch $@

$(LIBNIH_BUILD_DIR)/.configured:
	$(Q)cd $(LIBNIH_BUILD_DIR); \
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
	CPPFLAGS="-I$(SYSROOT)/usr/include" \
	PKG_CONFIG=$(PKGCONFIG_BIN) \
	PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
	NIH_DBUS_TOOL=nih-dbus-tool \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) --libdir=/usr/$(LIBDIR) \
	--prefix=/usr --disable-rpath
	@touch $@

libnih_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup libnih...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(LIBNIH_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(LIBNIH_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(LIBNIH_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(LIBNIH_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(LIBNIH_PKGCONFIGS)
	$(Q)-rm -rf $(LIBNIH_BUILD_DIR)*

