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
# \file         libxrender.mk
# \brief	libxrender.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

LIBXRENDER_NAME		:= libXrender
LIBXRENDER_VERSION	:= $(call embtk_get_pkgversion,libxrender)
LIBXRENDER_SITE		:= http://xorg.freedesktop.org/archive/individual/lib
LIBXRENDER_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
LIBXRENDER_PACKAGE	:= libXrender-$(LIBXRENDER_VERSION).tar.bz2
LIBXRENDER_SRC_DIR	:= $(PACKAGES_BUILD)/libXrender-$(LIBXRENDER_VERSION)
LIBXRENDER_BUILD_DIR	:= $(PACKAGES_BUILD)/libXrender-$(LIBXRENDER_VERSION)

LIBXRENDER_BINS		=
LIBXRENDER_SBINS	=
LIBXRENDER_INCLUDES	= X11/extensions/Xrender.h
LIBXRENDER_LIBS		= libXrender.*
LIBXRENDER_PKGCONFIGS	= xrender.pc

LIBXRENDER_CONFIGURE_OPTS := --disable-malloc0returnsnull

LIBXRENDER_DEPS = renderproto_install libx11_install
