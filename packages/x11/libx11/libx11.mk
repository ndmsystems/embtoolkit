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
# \file         libx11.mk
# \brief	libx11.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         March 2010
################################################################################

LIBX11_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_LIBX11_VERSION_STRING)))
LIBX11_SITE := http://xorg.freedesktop.org/archive/individual/lib
LIBX11_PACKAGE := libX11-$(LIBX11_VERSION).tar.bz2
LIBX11_BUILD_DIR := $(PACKAGES_BUILD)/libX11-$(LIBX11_VERSION)

LIBX11_BINS =
LIBX11_SBINS =
LIBX11_INCLUDES = X11/cursorfont.h X11/ImUtil.h X11/Xcms.h X11/XKBlib.h \
		X11/XlibConf.h X11/Xlib.h X11/Xlibint.h X11/Xlib-xcb.h \
		X11/Xlocale.h X11/Xregion.h X11/Xresource.h X11/Xutil.h
LIBX11_LIBS = libX11* X11/Xcms.txt
LIBX11_PKGCONFIGS = x11.pc x11-xcb.pc

LIBX11_DEPS = utilmacros_install inputproto_install kbproto_install \
		xextproto_install xproto_install libxcb_install xtrans_install

libx11_install: $(LIBX11_BUILD_DIR)/.installed

$(LIBX11_BUILD_DIR)/.installed: $(LIBX11_DEPS) download_libx11 \
	$(LIBX11_BUILD_DIR)/.decompressed $(LIBX11_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	libx11-$(LIBX11_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH,$(LIBX11_BUILD_DIR))
	$(Q)$(MAKE) -C $(LIBX11_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBX11_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	$(Q)$(MAKE) $(LIBX11_BUILD_DIR)/.patchlibtool
	@touch $@

download_libx11:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(LIBX11_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(LIBX11_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(LIBX11_PACKAGE) \
	$(LIBX11_SITE)/$(LIBX11_PACKAGE)

$(LIBX11_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LIBX11_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(LIBX11_PACKAGE)
	@touch $@

$(LIBX11_BUILD_DIR)/.configured:
	$(Q)cd $(LIBX11_BUILD_DIR); \
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
	--target=$(STRICT_GNU_TARGET) \
	--prefix=/usr --libdir=/usr/$(LIBDIR) --with-xcb
	@touch $@

libx11_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup libx11-$(LIBX11_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(LIBX11_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(LIBX11_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(LIBX11_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(LIBX11_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(LIBX11_PKGCONFIGS)

$(LIBX11_BUILD_DIR)/.patchlibtool:
	@LIBX11_LT_FILES=`find $(SYSROOT)/usr/$(LIBDIR)/libX11-* -type f -name *.la`; \
	for i in $$LIBX11_LT_FILES; \
	do \
	sed \
	-i "s; /usr/$(LIBDIR)/libX11.la ; $(SYSROOT)/usr/$(LIBDIR)/libX11.la ;" $$i; \
	done