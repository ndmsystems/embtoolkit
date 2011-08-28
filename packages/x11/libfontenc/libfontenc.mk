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
# \file         libfontenc.mk
# \brief	libfontenc.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

LIBFONTENC_NAME		:= libfontenc
LIBFONTENC_VERSION	:= $(call embtk_get_pkgversion,libfontenc)
LIBFONTENC_SITE		:= http://xorg.freedesktop.org/archive/individual/lib
LIBFONTENC_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
LIBFONTENC_PACKAGE	:= libfontenc-$(LIBFONTENC_VERSION).tar.bz2
LIBFONTENC_SRC_DIR	:= $(PACKAGES_BUILD)/libfontenc-$(LIBFONTENC_VERSION)
LIBFONTENC_BUILD_DIR	:= $(PACKAGES_BUILD)/libfontenc-$(LIBFONTENC_VERSION)

LIBFONTENC_BINS =
LIBFONTENC_SBINS =
LIBFONTENC_INCLUDES = X11/fonts/fontenc.h
LIBFONTENC_LIBS = libfontenc.*
LIBFONTENC_PKGCONFIGS = libfontenc.pc

LIBFONTENC_CONFIGURE_OPTS	:= --disable-malloc0returnsnull
LIBFONTENC_DEPS			:= zlib_install

