################################################################################
# Embtoolkit
# Copyright(C) 2010-2013 Abdoulaye Walsimou GAYE.
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

NCURSES_NAME		:= ncurses
NCURSES_VERSION		:= $(call embtk_get_pkgversion,ncurses)
NCURSES_SITE		:= http://ftp.gnu.org/pub/gnu/ncurses
NCURSES_PACKAGE		:= ncurses-$(NCURSES_VERSION).tar.gz
NCURSES_SRC_DIR		:= $(embtk_pkgb)/ncurses-$(NCURSES_VERSION)
NCURSES_BUILD_DIR	:= $(embtk_pkgb)/ncurses-$(NCURSES_VERSION)

NCURSES_BINS		:= captoinfo clear infocmp infotocap ncurses5-config
NCURSES_BINS		+= reset tic toe tput tset

NCURSES_INCLUDES	:= cursesapp.h curses.h cursesp.h cursslk.h etip.h
NCURSES_INCLUDES	+= menu.h ncurses_dll.h panel.h term_entry.h tic.h
NCURSES_INCLUDES	+= cursesf.h cursesm.h cursesw.h eti.h form.h nc_tparm.h
NCURSES_INCLUDES	+= ncurses.h termcap.h term.h unctrl.h

NCURSES_LIBS		:= libcurses.a libform.a libform_g.a libmenu.a
NCURSES_LIBS		+= libmenu_g.a libncurses.a libncurses++.a
NCURSES_LIBS		+= libncurses_g.a libpanel.a libpanel_g.a terminfo

NCURSES_CFLAGS		:= -fPIC
NCURSES_CONFIGURE_ENV	:= ac_cv_header_locale_h=no

NCURSES_CONFIGURE_OPTS	:= --disable-rpath --without-cxx-binding --without-ada
NCURSES_CONFIGURE_OPTS	+= --disable-database --enable-termcap --without-progs
NCURSES_CONFIGURE_OPTS	+= --program-prefix="" --without-tests

define embtk_postinstall_ncurses
	$(Q)mkdir -p $(embtk_rootfs)/usr/share
	$(Q)-cp -R $(embtk_sysroot)/usr/share/tabset $(embtk_rootfs)/usr/share/
endef
