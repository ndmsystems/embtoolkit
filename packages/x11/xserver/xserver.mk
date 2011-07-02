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
# \file         xserver.mk
# \brief	xserver.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

XSERVER_NAME := xorg-server
XSERVER_VERSION := $(call embtk_get_pkgversion,XSERVER)
XSERVER_SITE := http://ftp.x.org/pub/individual/xserver
XSERVER_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
XSERVER_PACKAGE := xorg-server-$(XSERVER_VERSION).tar.bz2
XSERVER_SRC_DIR := $(PACKAGES_BUILD)/xorg-server-$(XSERVER_VERSION)
XSERVER_BUILD_DIR := $(PACKAGES_BUILD)/xorg-server-$(XSERVER_VERSION)

XSERVER_BINS = Xfbdev X Xorg
XSERVER_SBINS =
XSERVER_INCLUDES = xorg
XSERVER_LIBS = xorg
XSERVER_PKGCONFIGS = xorg-server.pc

ifeq ($(CONFIG_EMBTK_HAVE_XSERVER_KDRIVE),y)
XSERVER_VARIANT := --enable-kdrive --disable-xorg
else
XSERVER_VARIANT := --disable-kdrive --enable-xorg
endif

XSERVER_DEPS := utilmacros_install bigreqsproto_install compositeproto_install \
		damageproto_install fixesproto_install fontsproto_install \
		inputproto_install kbproto_install randrproto_install \
		recordproto_install renderproto_install resourceproto_install \
		videoproto_install xcbproto_install xcmiscproto_install \
		xextproto_install xproto_install libxfont_install \
		libxkbfile_install xtrans_install openssl_install

ifeq ($(CONFIG_EMBTK_HAVE_XSERVER_XORG),y)
XSERVER_DEPS += libpciaccess_install
endif

XSERVER_CONFIGURE_OPTS := $(XSERVER_VARIANT) --with-sha1=libcrypto \
		--disable-dga --disable-dri --disable-xvmc --disable-fontserver \
		--disable-xdmcp --disable-xdm-auth-1 --disable-config-hal \
		--disable-xf86vidmode --disable-xf86bigfont --disable-xnest \
		--disable-xquartz --disable-xwin --disable-xfake \
		--disable-install-setuid --disable-xvfb --disable-dmx \
		--disable-glx --disable-aiglx --disable-glx-tls --disable-libdrm \
		--disable-xinerama --disable-xace --disable-dbe --disable-dpms \
		--disable-vgahw --disable-xfree86-utils --disable-vbe \
		--disable-int10-module --disable-xaa --disable-screensaver \
		--disable-tcp-transport --disable-ipv6 --disable-secure-rpc \
		--with-vendor-name="Embedded Systems Toolkit" \
		--with-vendor-name-short="EmbToolkit" \
		--with-vendor-web=$(EMBTK_HOMEURL) \
		--with-builderstring="embtoolkit-$(EMBTK_VERSION)" \
		--with-builder-addr="embtk-dev@embtoolkit.org" \
		--with-os-name=$(STRICT_GNU_TARGET) \
		--with-os-vendor="embtoolkit.org"

XSERVER_CONFIGURE_ENV := XLIB_CFLAGS=`$(PKGCONFIG_BIN) xcb --cflags`
XSERVER_CONFIGURE_ENV += XLIB_LIBS=`$(PKGCONFIG_BIN) xcb --libs`
XSERVER_CONFIGURE_ENV += TSLIB_CFLAGS=`$(PKGCONFIG_BIN) tslib --cflags`
XSERVER_CONFIGURE_ENV += TSLIB_LIBS=`$(PKGCONFIG_BIN) tslib --libs`

ifeq ($(CONFIG_EMBTK_HAVE_XSERVER_WITH_TSLIB),y)
XSERVER_DEPS += tslib_install
XSERVER_CONFIGURE_OPTS += --enable-tslib
else
XSERVER_CONFIGURE_OPTS += --disable-tslib
endif

xserver_install:
	$(call embtk_install_pkg,XSERVER)
	$(Q)$(MAKE) $(XSERVER_BUILD_DIR)/.special

download_xserver:
	$(call embtk_download_pkg,XSERVER)

xserver_clean:
	$(call embtk_cleanup_pkg,XSERVER)

.PHONY: $(XSERVER_BUILD_DIR)/.special

$(XSERVER_BUILD_DIR)/.special:
	$(Q)-cp -R $(SYSROOT)/usr/$(LIBDIR)/xorg $(ROOTFS)/usr/$(LIBDIR)/
	@touch $@
