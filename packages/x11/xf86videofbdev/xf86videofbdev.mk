################################################################################
# Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
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
# \file         xf86videofbdev.mk
# \brief	xf86videofbdev.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         July 2010
################################################################################

XF86VIDEOFBDEV_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_XF86VIDEOFBDEV_VERSION_STRING)))
XF86VIDEOFBDEV_SITE := http://xorg.freedesktop.org/archive/individual/driver
XF86VIDEOFBDEV_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/xf86-video-fbdev/$(XF86VIDEOFBDEV_VERSION)
XF86VIDEOFBDEV_PACKAGE := xf86-video-fbdev-$(XF86VIDEOFBDEV_VERSION).tar.bz2
XF86VIDEOFBDEV_BUILD_DIR := $(PACKAGES_BUILD)/xf86-video-fbdev-$(XF86VIDEOFBDEV_VERSION)

XF86VIDEOFBDEV_BINS =
XF86VIDEOFBDEV_SBINS =
XF86VIDEOFBDEV_INCLUDES =
XF86VIDEOFBDEV_LIBS = xorg
XF86VIDEOFBDEV_PKGCONFIGS =

XF86VIDEOFBDEV_DEPS = xserver_install

xf86videofbdev_install: $(XF86VIDEOFBDEV_BUILD_DIR)/.installed

$(XF86VIDEOFBDEV_BUILD_DIR)/.installed: $(XF86VIDEOFBDEV_DEPS) \
	download_xf86videofbdev $(XF86VIDEOFBDEV_BUILD_DIR)/.decompressed \
	$(XF86VIDEOFBDEV_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	xf86videofbdev-$(XF86VIDEOFBDEV_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH,$(XF86VIDEOFBDEV_BUILD_DIR))
	$(Q)$(MAKE) -C $(XF86VIDEOFBDEV_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(XF86VIDEOFBDEV_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	$(Q)-cp -R $(SYSROOT)/usr/$(LIBDIR)/xorg $(ROOTFS)/usr/$(LIBDIR)/
	@touch $@

download_xf86videofbdev:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(XF86VIDEOFBDEV_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(XF86VIDEOFBDEV_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(XF86VIDEOFBDEV_PACKAGE) \
	$(XF86VIDEOFBDEV_SITE)/$(XF86VIDEOFBDEV_PACKAGE)
ifeq ($(CONFIG_EMBTK_XF86VIDEOFBDEV_NEED_PATCH),y)
	@test -e $(DOWNLOAD_DIR)/xf86-video-fbdev-$(XF86VIDEOFBDEV_VERSION).patch || \
	wget -O $(DOWNLOAD_DIR)/xf86-video-fbdev-$(XF86VIDEOFBDEV_VERSION).patch \
	$(XF86VIDEOFBDEV_PATCH_SITE)/xf86-video-fbdev-$(XF86VIDEOFBDEV_VERSION)-*.patch
endif

$(XF86VIDEOFBDEV_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(XF86VIDEOFBDEV_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjf $(DOWNLOAD_DIR)/$(XF86VIDEOFBDEV_PACKAGE)
ifeq ($(CONFIG_EMBTK_XF86VIDEOFBDEV_NEED_PATCH),y)
	@cd $(PACKAGES_BUILD)/xf86-video-fbdev-$(XF86VIDEOFBDEV_VERSION); \
	patch -p1 < $(DOWNLOAD_DIR)/xf86-video-fbdev-$(XF86VIDEOFBDEV_VERSION).patch
endif
	@touch $@

$(XF86VIDEOFBDEV_BUILD_DIR)/.configured:
	$(Q)cd $(XF86VIDEOFBDEV_BUILD_DIR); \
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

xf86videofbdev_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup xf86videofbdev-$(XF86VIDEOFBDEV_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(XF86VIDEOFBDEV_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(XF86VIDEOFBDEV_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(XF86VIDEOFBDEV_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(XF86VIDEOFBDEV_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(XF86VIDEOFBDEV_PKGCONFIGS)

