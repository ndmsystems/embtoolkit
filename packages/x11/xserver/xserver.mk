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
# \file         xserver.mk
# \brief	xserver.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         March 2010
################################################################################

XSERVER_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_XSERVER_VERSION_STRING)))
XSERVER_SITE := http://ftp.x.org/pub/individual/xserver
XSERVER_PACKAGE := xorg-server-$(XSERVER_VERSION).tar.bz2
XSERVER_BUILD_DIR := $(PACKAGES_BUILD)/xorg-server-$(XSERVER_VERSION)

XSERVER_BINS = Xfbdev
XSERVER_SBINS =
XSERVER_INCLUDES =
XSERVER_LIBS = xorg/protocol.txt
XSERVER_PKGCONFIGS =

XSERVER_DEPS := utilmacros_install bigreqsproto_install compositeproto_install \
		damageproto_install fixesproto_install fontsproto_install \
		inputproto_install kbproto_install randrproto_install \
		renderproto_install resourceproto_install videoproto_install \
		xcbproto_install xcmiscproto_install xextproto_install \
		xproto_install libxfont_install libxkbfile_install \
		xtrans_install openssl_install

XSERVER_CONFIGURE_OPTS := --enable-kdrive --with-sha1=libcrypto \
		--disable-xorg --disable-aiglx --disable-glx-tls --disable-dga \
		--disable-xdmcp --disable-xdm-auth-1 --disable-config-hal \
		--disable-xf86vidmode --disable-xf86bigfont --disable-xnest \
		--disable-xquartz --disable-xwin --disable-xfake \
		--disable-install-setuid --disable-xvfb --disable-dmx \
		--disable-glx --disable-xinerama --disable-xfree86-utils \
		--disable-screensaver --disable-dri --disable-tcp-transport \
		--disable-ipv6

xserver_install: $(XSERVER_BUILD_DIR)/.installed

$(XSERVER_BUILD_DIR)/.installed: $(XSERVER_DEPS) download_xserver \
	$(XSERVER_BUILD_DIR)/.decompressed $(XSERVER_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	xserver-$(XSERVER_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH,$(XSERVER_BUILD_DIR))
	$(Q)$(MAKE) -C $(XSERVER_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(XSERVER_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	$(Q)-cp -R $(SYSROOT)/usr/$(LIBDIR)/xorg $(ROOTFS)/usr/$(LIBDIR)/
	@touch $@

download_xserver:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(XSERVER_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(XSERVER_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(XSERVER_PACKAGE) \
	$(XSERVER_SITE)/$(XSERVER_PACKAGE)

$(XSERVER_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(XSERVER_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(XSERVER_PACKAGE)
	@touch $@

$(XSERVER_BUILD_DIR)/.configured:
	$(Q)cd $(XSERVER_BUILD_DIR); \
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
	XLIB_CFLAGS=`$(PKGCONFIG_BIN) xcb --cflags` \
	XLIB_LIBS=`$(PKGCONFIG_BIN) xcb --libs` \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) --libdir=/usr/$(LIBDIR) \
	--prefix=/usr $(XSERVER_CONFIGURE_OPTS) \
	--with-vendor-name="Embedded Systems Toolkit" \
	--with-vendor-name-short="EmbToolkit" \
	--with-vendor-web="http://www.embtoolkit.org" \
	--with-builderstring="embtoolkit-$(EMBTK_VERSION)" \
	--with-builder-addr="embtk-devel@embtoolkit.org" \
	--with-os-name=$(STRICT_GNU_TARGET) --with-os-vendor="embtoolkit.org"
	@touch $@

xserver_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup xserver-$(XSERVER_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(XSERVER_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(XSERVER_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(XSERVER_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(XSERVER_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(XSERVER_PKGCONFIGS)

