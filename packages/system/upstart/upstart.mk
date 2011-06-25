################################################################################
# Embtoolkit
# Copyright(C) 2010-2011 Abdoulaye Walsimou GAYE.
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
# \file         upstart.mk
# \brief	upstart.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         October 2010
################################################################################

UPSTART_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_UPSTART_VERSION_STRING)))
UPSTART_MAJOR_VERSION :=  $(subst ",,$(strip $(CONFIG_EMBTK_UPSTART_MAJOR_VERSION_STRING)))
UPSTART_SITE := http://upstart.ubuntu.com/download/$(UPSTART_MAJOR_VERSION)
UPSTART_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/upstart/$(UPSTART_VERSION)
UPSTART_PACKAGE := upstart-$(UPSTART_VERSION).tar.gz
UPSTART_BUILD_DIR := $(PACKAGES_BUILD)/upstart-$(UPSTART_VERSION)

UPSTART_BINS =
UPSTART_SBINS =
UPSTART_INCLUDES =
UPSTART_LIBS =
UPSTART_PKGCONFIGS =

UPSTART_DEPS := libnih_install

upstart_install: $(UPSTART_BUILD_DIR)/.installed

$(UPSTART_BUILD_DIR)/.installed: $(UPSTART_DEPS) download_upstart \
	$(UPSTART_BUILD_DIR)/.decompressed $(UPSTART_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	upstart-$(UPSTART_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH,$(UPSTART_BUILD_DIR))
	$(Q)$(MAKE) -C $(UPSTART_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(UPSTART_BUILD_DIR) DESTDIR=$(ROOTFS)/ install
	$(Q)-rm -rf $(ROOTFS)/share
	@touch $@

download_upstart:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(UPSTART_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(UPSTART_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(UPSTART_PACKAGE) \
	$(UPSTART_SITE)/$(UPSTART_PACKAGE)
ifeq ($(CONFIG_EMBTK_UPSTART_NEED_PATCH),y)
	@test -e $(DOWNLOAD_DIR)/upstart-$(UPSTART_VERSION).patch || \
	wget -O $(DOWNLOAD_DIR)/upstart-$(UPSTART_VERSION).patch \
	$(UPSTART_PATCH_SITE)/upstart-$(UPSTART_VERSION)-*.patch
endif

$(UPSTART_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(UPSTART_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzf $(DOWNLOAD_DIR)/$(UPSTART_PACKAGE)
ifeq ($(CONFIG_EMBTK_UPSTART_NEED_PATCH),y)
	@cd $(UPSTART_BUILD_DIR); \
	patch -p1 < $(DOWNLOAD_DIR)/upstart-$(UPSTART_VERSION).patch
endif
	@touch $@

$(UPSTART_BUILD_DIR)/.configured:
	$(Q)cd $(UPSTART_BUILD_DIR); \
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
	PKG_CONFIG_PATH=$(EMBTK_PKG_CONFIG_PATH) \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) --libdir=/usr/$(LIBDIR) --disable-rpath \
	--prefix=/ --exec-prefix= --sysconfdir=/etc
	@touch $@

upstart_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup upstart...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(UPSTART_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(UPSTART_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(UPSTART_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(UPSTART_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(UPSTART_PKGCONFIGS)
	$(Q)-rm -rf $(UPSTART_BUILD_DIR)*

$(UPSTART_BUILD_DIR)/.special:
	$(Q)-mkdir -p $(ROOTFS)/etc
	$(Q)-mkdir -p $(ROOTFS)/etc/dbus-1
	$(Q)-mkdir -p $(ROOTFS)/etc/dbus-1/system.d
	$(Q)-cp $(SYSROOT)/etc/dbus-1/system.d/Upstart.conf \
	$(ROOTFS)/etc/dbus-1/system.d
	$(Q)-cp -R $(SYSROOT)/etc/init $(ROOTFS)/etc/
