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
	$(call embtk_pinfo,"Compiling and installing \
	upstart-$(UPSTART_VERSION) in your root filesystem...")
	$(call __embtk_kill_lt_rpath,$(UPSTART_BUILD_DIR))
	$(Q)$(MAKE) -C $(UPSTART_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(UPSTART_BUILD_DIR) DESTDIR=$(embtk_rootfs)/ install
	$(Q)-rm -rf $(embtk_rootfs)/share
	@touch $@

download_upstart:
	$(call embtk_pinfo,"Downloading $(UPSTART_PACKAGE) \
	if necessary...")
	@test -e $(embtk_dldir)/$(UPSTART_PACKAGE) || \
	wget -O $(embtk_dldir)/$(UPSTART_PACKAGE) \
	$(UPSTART_SITE)/$(UPSTART_PACKAGE)
ifeq ($(CONFIG_EMBTK_UPSTART_NEED_PATCH),y)
	@test -e $(embtk_dldir)/upstart-$(UPSTART_VERSION).patch || \
	wget -O $(embtk_dldir)/upstart-$(UPSTART_VERSION).patch \
	$(UPSTART_PATCH_SITE)/upstart-$(UPSTART_VERSION)-*.patch
endif

$(UPSTART_BUILD_DIR)/.decompressed:
	$(call embtk_pinfo,"Decompressing $(UPSTART_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzf $(embtk_dldir)/$(UPSTART_PACKAGE)
ifeq ($(CONFIG_EMBTK_UPSTART_NEED_PATCH),y)
	@cd $(UPSTART_BUILD_DIR); \
	patch -p1 < $(embtk_dldir)/upstart-$(UPSTART_VERSION).patch
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
	LDFLAGS="-L$(embtk_sysroot)/$(LIBDIR) -L$(embtk_sysroot)/usr/$(LIBDIR)" \
	CPPFLAGS="-I$(embtk_sysroot)/usr/include" \
	PKG_CONFIG=$(PKGCONFIG_BIN) \
	PKG_CONFIG_PATH=$(EMBTK_PKG_CONFIG_PATH) \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) --libdir=/usr/$(LIBDIR) --disable-rpath \
	--prefix=/ --exec-prefix= --sysconfdir=/etc
	@touch $@

upstart_clean:
	$(call embtk_pinfo,"cleanup upstart...")
	$(Q)-cd $(embtk_sysroot)/usr/bin; rm -rf $(UPSTART_BINS)
	$(Q)-cd $(embtk_sysroot)/usr/sbin; rm -rf $(UPSTART_SBINS)
	$(Q)-cd $(embtk_sysroot)/usr/include; rm -rf $(UPSTART_INCLUDES)
	$(Q)-cd $(embtk_sysroot)/usr/$(LIBDIR); rm -rf $(UPSTART_LIBS)
	$(Q)-cd $(embtk_sysroot)/usr/$(LIBDIR)/pkgconfig; rm -rf $(UPSTART_PKGCONFIGS)
	$(Q)-rm -rf $(UPSTART_BUILD_DIR)*

$(UPSTART_BUILD_DIR)/.special:
	$(Q)-mkdir -p $(embtk_rootfs)/etc
	$(Q)-mkdir -p $(embtk_rootfs)/etc/dbus-1
	$(Q)-mkdir -p $(embtk_rootfs)/etc/dbus-1/system.d
	$(Q)-cp $(embtk_sysroot)/etc/dbus-1/system.d/Upstart.conf \
	$(embtk_rootfs)/etc/dbus-1/system.d
	$(Q)-cp -R $(embtk_sysroot)/etc/init $(embtk_rootfs)/etc/
