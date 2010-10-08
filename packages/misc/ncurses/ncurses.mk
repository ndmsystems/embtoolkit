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
# \file         ncurses.mk
# \brief	ncurses.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
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

ncurses_install:
	@test -e $(NCURSES_BUILD_DIR)/.installed || \
	$(MAKE) $(NCURSES_BUILD_DIR)/.installed
	$(Q)$(MAKE) $(NCURSES_BUILD_DIR)/.special

$(NCURSES_BUILD_DIR)/.installed: download_ncurses \
	$(NCURSES_BUILD_DIR)/.decompressed $(NCURSES_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	ncurses-$(NCURSES_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(NCURSES_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(NCURSES_BUILD_DIR) DESTDIR=$(SYSROOT) install
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
	CPPFLAGS="-I$(SYSROOT)/usr/include" \
	PKG_CONFIG=$(PKGCONFIG_BIN) \
	PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) --program-prefix="" \
	--prefix=/usr --disable-rpath --without-cxx-binding --without-ada \
	--libdir=/usr/$(LIBDIR) --disable-database --enable-termcap
	@touch $@

ncurses_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup ncurses...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(NCURSES_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(NCURSES_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(NCURSES_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(NCURSES_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(NCURSES_PKGCONFIGS)
	$(Q)-rm -rf $(NCURSES_BUILD_DIR)*

.PHONY: $(NCURSES_BUILD_DIR)/.special

$(NCURSES_BUILD_DIR)/.special:
	$(Q)mkdir -p $(ROOTFS)/usr/share
	$(Q)-cp -R $(SYSROOT)/usr/share/tabset $(ROOTFS)/usr/share/
	@touch $@
