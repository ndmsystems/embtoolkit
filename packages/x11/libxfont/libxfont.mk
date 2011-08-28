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
# \file         libxfont.mk
# \brief	libxfont.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

LIBXFONT_NAME		:= libXfont
LIBXFONT_VERSION	:= $(call embtk_get_pkgversion,libxfont)
LIBXFONT_SITE		:= http://xorg.freedesktop.org/archive/individual/lib
LIBXFONT_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
LIBXFONT_PACKAGE	:= libXfont-$(LIBXFONT_VERSION).tar.bz2
LIBXFONT_SRC_DIR	:= $(PACKAGES_BUILD)/libXfont-$(LIBXFONT_VERSION)
LIBXFONT_BUILD_DIR	:= $(PACKAGES_BUILD)/libXfont-$(LIBXFONT_VERSION)

LIBXFONT_BINS =
LIBXFONT_SBINS =
LIBXFONT_INCLUDES = X11/fonts/bdfint.h X11/fonts/bufio.h X11/fonts/fntfilio.h \
		X11/fonts/fontconf.h X11/fonts/fontmisc.h X11/fonts/fontutil.h \
		X11/fonts/ftfuncs.h X11/fonts/pcf.h X11/fonts/bitmap.h \
		X11/fonts/fntfil.h X11/fonts/fntfilst.h X11/fonts/fontencc.h \
		X11/fonts/fontshow.h X11/fonts/fontxlfd.h X11/fonts/ft.h
LIBXFONT_LIBS = libXfont.*
LIBXFONT_PKGCONFIGS = xfont.pc

LIBXFONT_CONFIGURE_OPTS := --disable-malloc0returnsnull

LIBXFONT_DEPS = libfontenc_install freetype_install
