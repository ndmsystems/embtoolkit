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
# \file         libxau.mk
# \brief	libxau.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         February 2010
################################################################################

LIBXAU_NAME		:= libXau
LIBXAU_VERSION		:= $(call embtk_get_pkgversion,libxau)
LIBXAU_SITE		:= http://xorg.freedesktop.org/archive/individual/lib
LIBXAU_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
LIBXAU_PACKAGE		:= libXau-$(LIBXAU_VERSION).tar.bz2
LIBXAU_SRC_DIR		:= $(PACKAGES_BUILD)/libXau-$(LIBXAU_VERSION)
LIBXAU_BUILD_DIR	:= $(PACKAGES_BUILD)/libXau-$(LIBXAU_VERSION)

LIBXAU_BINS		=
LIBXAU_SBINS		=
LIBXAU_INCLUDES		= X11/Xauth.h
LIBXAU_LIBS		= libXau.*
LIBXAU_PKGCONFIGS	= xau.pc

LIBXAU_DEPS = xproto_install
