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
# \file         libx11.mk
# \brief	libx11.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

LIBX11_NAME := libX11
LIBX11_VERSION := $(call embtk_get_pkgversion,LIBX11)
LIBX11_SITE := http://xorg.freedesktop.org/archive/individual/lib
LIBX11_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
LIBX11_PACKAGE := libX11-$(LIBX11_VERSION).tar.bz2
LIBX11_SRC_DIR := $(PACKAGES_BUILD)/libX11-$(LIBX11_VERSION)
LIBX11_BUILD_DIR := $(PACKAGES_BUILD)/libX11-$(LIBX11_VERSION)

LIBX11_BINS =
LIBX11_SBINS =
LIBX11_INCLUDES = X11/cursorfont.h X11/ImUtil.h X11/Xcms.h X11/XKBlib.h \
		X11/XlibConf.h X11/Xlib.h X11/Xlibint.h X11/Xlib-xcb.h \
		X11/Xlocale.h X11/Xregion.h X11/Xresource.h X11/Xutil.h
LIBX11_LIBS = libX11* X11/Xcms.txt
LIBX11_PKGCONFIGS = x11.pc x11-xcb.pc

LIBX11_CONFIGURE_OPTS := --with-xcb --without-xmlto --without-ps2pdf \
	--without-groff --disable-malloc0returnsnull \
	--disable-loadable-xcursor

LIBX11_DEPS = utilmacros_install inputproto_install kbproto_install \
		xextproto_install xproto_install libxcb_install xtrans_install

libx11_install:
	@test -e $(LIBX11_BUILD_DIR)/.installed || \
	$(MAKE) $(LIBX11_BUILD_DIR)/.installed
	$(Q)$(MAKE) $(LIBX11_BUILD_DIR)/.special

$(LIBX11_BUILD_DIR)/.installed: $(LIBX11_DEPS) download_libx11 \
	$(LIBX11_BUILD_DIR)/.decompressed $(LIBX11_BUILD_DIR)/.configured
	$(call embtk_generic_message,"Compiling and installing \
	libx11-$(LIBX11_VERSION) in your root filesystem...")
	@cd $(LIBX11_BUILD_DIR)/src/util; \
	gcc makekeys.c -c -o makekeys-makekeys.o; gcc makekeys.c -o makekeys
	$(Q)$(MAKE) -C $(LIBX11_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBX11_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	$(Q)$(MAKE) $(LIBX11_BUILD_DIR)/.patchlibtool
	@touch $@

download_libx11:
	$(call embtk_download_pkg,LIBX11)

$(LIBX11_BUILD_DIR)/.decompressed:
	$(call embtk_decompress_pkg,LIBX11)

$(LIBX11_BUILD_DIR)/.configured:
	$(call embtk_configure_pkg,LIBX11)

libx11_clean:
	$(call embtk_cleanup_pkg,LIBX11)

$(LIBX11_BUILD_DIR)/.patchlibtool:
	@LIBX11_LT_FILES=`find $(SYSROOT)/usr/$(LIBDIR)/libX11-* -type f -name *.la`; \
	for i in $$LIBX11_LT_FILES; \
	do \
	sed \
	-i "s; /usr/$(LIBDIR)/libX11.la ; $(SYSROOT)/usr/$(LIBDIR)/libX11.la ;" $$i; \
	done

.PHONY: $(LIBX11_BUILD_DIR)/.special

$(LIBX11_BUILD_DIR)/.special:
	$(Q)-mkdir -p $(ROOTFS)/usr/share
	$(Q)-mkdir -p $(ROOTFS)/usr/share/X11
	$(Q)-cp $(SYSROOT)/usr/share/X11/XErrorDB $(ROOTFS)/usr/share/X11/
	$(Q)-cp $(SYSROOT)/usr/share/X11/XKeysymDB $(ROOTFS)/usr/share/X11/
	@touch $@
