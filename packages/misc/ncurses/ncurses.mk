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
# \file         ncurses.mk
# \brief	ncurses.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         January 2010
################################################################################

NCURSES_NAME := ncurses
NCURSES_VERSION := $(call EMBTK_GET_PKG_VERSION,NCURSES)
NCURSES_SITE := http://ftp.gnu.org/pub/gnu/ncurses
NCURSES_PACKAGE := ncurses-$(NCURSES_VERSION).tar.gz
NCURSES_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
NCURSES_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/ncurses/$(NCURSES_VERSION)
NCURSES_SRC_DIR := $(PACKAGES_BUILD)/ncurses-$(NCURSES_VERSION)
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

NCURSES_CONFIGURE_OPTS := --disable-rpath --without-cxx-binding		\
			--without-ada --disable-database		\
			--enable-termcap --without-progs		\
			--program-prefix=""

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
	$(call EMBTK_DOWNLOAD_PKG,NCURSES)

$(NCURSES_BUILD_DIR)/.decompressed:
	$(call EMBTK_DECOMPRESS_PKG,NCURSES)

$(NCURSES_BUILD_DIR)/.configured:
	$(call EMBTK_CONFIGURE_PKG,NCURSES)

ncurses_clean:
	$(call EMBTK_CLEANUP_PKG,NCURSES)

.PHONY: $(NCURSES_BUILD_DIR)/.special ncurses_clean

$(NCURSES_BUILD_DIR)/.special:
	$(Q)mkdir -p $(ROOTFS)/usr/share
	$(Q)-cp -R $(SYSROOT)/usr/share/tabset $(ROOTFS)/usr/share/
	@touch $@
