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
# \file         dbus.mk
# \brief	dbus.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         July 2010
################################################################################

DBUS_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_DBUS_VERSION_STRING)))
DBUS_SITE := http://dbus.freedesktop.org/releases/dbus
DBUS_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/dbus/$(DBUS_VERSION)
DBUS_PACKAGE := dbus-$(DBUS_VERSION).tar.gz
DBUS_BUILD_DIR := $(PACKAGES_BUILD)/dbus-$(DBUS_VERSION)

DBUS_BINS = dbus-cleanup-sockets dbus-daemon dbus-launch dbus-monitor \
		dbus-send dbus-uuidgen
DBUS_SBINS =
DBUS_INCLUDES = dbus-*
DBUS_LIBS = dbus-* libdbus*
DBUS_PKGCONFIGS = dbus*.pc

DBUS_DEPS = expat_install

DBUS_CONFIGURE_OPTS := --enable-abstract-sockets \
	$(if $(CONFIG_EMBTK_HAVE_LIBX11),--with-x,--without-x)

dbus_install:
	test -e $(DBUS_BUILD_DIR)/.installed || \
	$(MAKE) $(DBUS_BUILD_DIR)/.installed
	$(Q)$(MAKE) $(DBUS_BUILD_DIR)/.special

$(DBUS_BUILD_DIR)/.installed: $(DBUS_DEPS) download_dbus \
	$(DBUS_BUILD_DIR)/.decompressed $(DBUS_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	dbus-$(DBUS_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH,$(DBUS_BUILD_DIR))
	$(Q)$(MAKE) -C $(DBUS_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(DBUS_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	$(Q)$(MAKE) $(DBUS_BUILD_DIR)/.special
	@touch $@

download_dbus:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(DBUS_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(DBUS_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(DBUS_PACKAGE) \
	$(DBUS_SITE)/$(DBUS_PACKAGE)
ifeq ($(CONFIG_EMBTK_DBUS_NEED_PATCH),y)
	@test -e $(DOWNLOAD_DIR)/dbus-$(DBUS_VERSION).patch || \
	wget -O $(DOWNLOAD_DIR)/dbus-$(DBUS_VERSION).patch \
	$(DBUS_PATCH_SITE)/dbus-$(DBUS_VERSION)-*.patch
endif

$(DBUS_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(DBUS_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzf $(DOWNLOAD_DIR)/$(DBUS_PACKAGE)
ifeq ($(CONFIG_EMBTK_DBUS_NEED_PATCH),y)
	@cd $(PACKAGES_BUILD)/dbus-$(DBUS_VERSION); \
	patch -p1 < $(DOWNLOAD_DIR)/dbus-$(DBUS_VERSION).patch
endif
	@touch $@

$(DBUS_BUILD_DIR)/.configured:
	$(Q)cd $(DBUS_BUILD_DIR); \
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
	--prefix=/usr $(DBUS_CONFIGURE_OPTS)
	@touch $@

dbus_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup dbus...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(DBUS_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(DBUS_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(DBUS_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(DBUS_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(DBUS_PKGCONFIGS)
	$(Q)-rm -rf $(DBUS_BUILD_DIR)*

.PHONY: $(DBUS_BUILD_DIR)/.special

$(DBUS_BUILD_DIR)/.special:
	$(Q)-mkdir -p $(ROOTFS)/usr
	$(Q)-mkdir -p $(ROOTFS)/usr/etc
	$(Q)-cp -R $(SYSROOT)/usr/etc/dbus* $(ROOTFS)/usr/etc/
	$(Q)-mkdir -p $(ROOTFS)/usr/libexec
	$(Q)-cp -R $(SYSROOT)/usr/libexec/dbus* $(ROOTFS)/usr/libexec/

