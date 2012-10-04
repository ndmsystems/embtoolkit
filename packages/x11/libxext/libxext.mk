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
# \file         libxext.mk
# \brief	libxext.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

LIBXEXT_NAME		:= libXext
LIBXEXT_VERSION		:= $(call embtk_get_pkgversion,libxext)
LIBXEXT_SITE		:= http://xorg.freedesktop.org/archive/individual/lib
LIBXEXT_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
LIBXEXT_PACKAGE		:= libXext-$(LIBXEXT_VERSION).tar.bz2
LIBXEXT_SRC_DIR		:= $(embtk_pkgb)/libXext-$(LIBXEXT_VERSION)
LIBXEXT_BUILD_DIR	:= $(embtk_pkgb)/libXext-$(LIBXEXT_VERSION)

LIBXEXT_BINS =
LIBXEXT_SBINS =
LIBXEXT_INCLUDES = X11/extensions/dpms.h X11/extensions/lbxbuf.h \
		X11/extensions/lbximage.h X11/extensions/multibuf.h \
		X11/extensions/shape.h X11/extensions/Xag.h \
		X11/extensions/Xdbe.h X11/extensions/Xext.h \
		X11/extensions/XLbx.h X11/extensions/xtestext1.h \
		X11/extensions/extutil.h X11/extensions/lbxbufstr.h \
		X11/extensions/MITMisc.h X11/extensions/security.h \
		X11/extensions/sync.h X11/extensions/Xcup.h \
		X11/extensions/XEVI.h X11/extensions/Xge.h X11/extensions/XShm.h
LIBXEXT_LIBS = libXext.*
LIBXEXT_PKGCONFIGS =

LIBXEXT_CONFIGURE_OPTS := --disable-malloc0returnsnull

LIBXEXT_DEPS = libx11_install
