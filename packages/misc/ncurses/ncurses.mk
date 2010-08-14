################################################################################
# Embtoolkit
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
# \file         ncurses.mk
# \brief	ncurses.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         January 2010
################################################################################

NCURSES_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_NCURSES_VERSION_STRING)))
NCURSES_SITE := http://ftp.gnu.org/pub/gnu/ncurses
NCURSES_PACKAGE := ncurses-$(NCURSES_VERSION).tar.gz
NCURSES_BUILD_DIR := $(PACKAGES_BUILD)/ncurses-$(NCURSES_VERSION)

NCURSES_BINS = captoinfo clear infocmp infotocap ncurses5-config reset tic toe \
		tput tset
NCURSES_SBINS =
NCURSES_INCLUDES = cursesapp.h curses.h cursesp.h cursslk.h etip.h menu.h \
		ncurses_dll.h panel.h term_entry.h tic.h cursesf.h cursesm.h \
		cursesw.h eti.h form.h nc_tparm.h ncurses.h termcap.h term.h \
		unctrl.h
NCURSES_LIBS = libcurses.a libform.a libform_g.a libmenu.a libmenu_g.a \
		libncurses.a libncurses++.a libncurses_g.a libpanel.a \
		libpanel_g.a terminfo
NCURSES_PKGCONFIGS =

ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
PKG_CONFIG_PATH=$(SYSROOT)/usr/lib32/pkgconfig
else
PKG_CONFIG_PATH=$(SYSROOT)/usr/lib/pkgconfig
endif

ncurses_install: $(NCURSES_BUILD_DIR)/.installed

$(NCURSES_BUILD_DIR)/.installed: download_ncurses \
	$(NCURSES_BUILD_DIR)/.decompressed $(NCURSES_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	ncurses-$(NCURSES_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(NCURSES_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(NCURSES_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)-cp -R $(SYSROOT)/usr/share/tabset $(ROOTFS)/usr/share/
	@touch $@

download_ncurses:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(NCURSES_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(NCURSES_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(NCURSES_PACKAGE) \
	$(NCURSES_SITE)/$(NCURSES_PACKAGE)

$(NCURSES_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(NCURSES_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzf $(DOWNLOAD_DIR)/$(NCURSES_PACKAGE)
	@touch $@

$(NCURSES_BUILD_DIR)/.configured:
	$(Q)cd $(NCURSES_BUILD_DIR); \
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
	CFLAGS="$(TARGET_CFLAGS) -fPIC" \
	CXXFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="-L$(SYSROOT)/$(LIBDIR) -L$(SYSROOT)/usr/$(LIBDIR)" \
	CPPFLGAS="-I$(SYSROOT)/usr/include" \
	PKG_CONFIG=$(PKGCONFIG_BIN) \
	PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) --program-prefix="" \
	--prefix=/usr --disable-rpath --without-cxx-binding --without-ada \
	--libdir=/usr/$(LIBDIR) --disable-database --enable-termcap
	@touch $@

ncurses_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup ncurses-$(NCURSES_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(NCURSES_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(NCURSES_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(NCURSES_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/lib; rm -rf $(NCURSES_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib/pkgconfig; rm -rf $(NCURSES_PKGCONFIGS)
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cd $(SYSROOT)/usr/lib32; rm -rf $(NCURSES_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib32/pkgconfig; rm -rf $(NCURSES_PKGCONFIGS)
endif

