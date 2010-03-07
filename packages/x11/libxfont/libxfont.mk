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
# \file         libxfont.mk
# \brief	libxfont.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         March 2010
################################################################################

LIBXFONT_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_LIBXFONT_VERSION_STRING)))
LIBXFONT_SITE := http://xorg.freedesktop.org/archive/individual/lib
LIBXFONT_PACKAGE := libXfont-$(LIBXFONT_VERSION).tar.bz2
LIBXFONT_BUILD_DIR := $(PACKAGES_BUILD)/libXfont-$(LIBXFONT_VERSION)

LIBXFONT_BINS =
LIBXFONT_SBINS =
LIBXFONT_INCLUDES = X11/fonts/bdfint.h X11/fonts/bufio.h X11/fonts/fntfilio.h \
		X11/fonts/fontconf.h X11/fonts/fontmisc.h X11/fonts/fontutil.h \
		X11/fonts/ftfuncs.h X11/fonts/pcf.h X11/fonts/bitmap.h \
		X11/fonts/fntfil.h X11/fonts/fntfilst.h X11/fonts/fontencc.h \
		X11/fonts/fontshow.h X11/fonts/fontxlfd.h X11/fonts/ft.h
LIBXFONT_LIBS = libXfont.*
LIBXFONT_PKGCONFIGS = xfont.pc

LIBXFONT_DEPS = libfontenc_install freetype_install

libxfont_install: $(LIBXFONT_BUILD_DIR)/.installed

$(LIBXFONT_BUILD_DIR)/.installed: $(LIBXFONT_DEPS) download_libxfont \
	$(LIBXFONT_BUILD_DIR)/.decompressed $(LIBXFONT_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	libxfont-$(LIBXFONT_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH,$(LIBXFONT_BUILD_DIR))
	$(Q)$(MAKE) -C $(LIBXFONT_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBXFONT_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_libxfont:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(LIBXFONT_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(LIBXFONT_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(LIBXFONT_PACKAGE) \
	$(LIBXFONT_SITE)/$(LIBXFONT_PACKAGE)

$(LIBXFONT_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LIBXFONT_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(LIBXFONT_PACKAGE)
	@touch $@

$(LIBXFONT_BUILD_DIR)/.configured:
	$(Q)cd $(LIBXFONT_BUILD_DIR); \
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
	--prefix=/usr --libdir=/usr/$(LIBDIR)
	@touch $@

libxfont_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup libxfont-$(LIBXFONT_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(LIBXFONT_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(LIBXFONT_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(LIBXFONT_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(LIBXFONT_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(LIBXFONT_PKGCONFIGS)

