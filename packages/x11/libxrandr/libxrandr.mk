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
# \file         libxrandr.mk
# \brief	libxrandr.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         June 2010
################################################################################

LIBXRANDR_NAME		:= libXrandr
LIBXRANDR_VERSION	:= $(call embtk_get_pkgversion,libxrandr)
LIBXRANDR_SITE		:= http://xorg.freedesktop.org/archive/individual/lib
LIBXRANDR_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
LIBXRANDR_PACKAGE	:= libXrandr-$(LIBXRANDR_VERSION).tar.bz2
LIBXRANDR_SRC_DIR	:= $(embtk_pkgb)/libXrandr-$(LIBXRANDR_VERSION)
LIBXRANDR_BUILD_DIR	:= $(embtk_pkgb)/libXrandr-$(LIBXRANDR_VERSION)

LIBXRANDR_BINS		=
LIBXRANDR_SBINS		=
LIBXRANDR_INCLUDES	= X11/extensions/Xrandr.h
LIBXRANDR_LIBS		= libXrandr.*
LIBXRANDR_PKGCONFIGS	= xrandr.pc

LIBXRANDR_CONFIGURE_OPTS := --disable-malloc0returnsnull

LIBXRANDR_DEPS = xproto_install randrproto_install
