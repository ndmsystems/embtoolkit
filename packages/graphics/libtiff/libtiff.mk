################################################################################
# Embtoolkit
# Copyright(C) 2009-2011 Abdoulaye Walsimou GAYE.
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
# \file         libtiff.mk
# \brief	libtiff.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

LIBTIFF_NAME		:= libtiff
LIBTIFF_VERSION		:= $(call embtk_get_pkgversion,libtiff)
LIBTIFF_SITE		:= ftp://ftp.remotesensing.org/pub/libtiff
LIBTIFF_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
LIBTIFF_PACKAGE		:= tiff-$(LIBTIFF_VERSION).tar.gz
LIBTIFF_SRC_DIR		:= $(embtk_pkgb)/tiff-$(LIBTIFF_VERSION)
LIBTIFF_BUILD_DIR	:= $(embtk_pkgb)/tiff-$(LIBTIFF_VERSION)

LIBTIFF_BINS =	vbmp2tiff fax2tiff pal2rgb  ras2tiff rgb2ycbcr tiff2bw tiff2ps	\
		tiffcmp tiffcrop tiffdump tiffmedian tiffsplit fax2ps gif2tiff	\
		ppm2tiff raw2tiff thumbnail tiff2pdf tiff2rgba tiffcp		\
		tiffdither tiffinfo tiffset bmp2tiff
LIBTIFF_SBINS		=
LIBTIFF_INCLUDES	= tiffconf.h tiff.h tiffio.h tiffio.hxx tiffvers.h
LIBTIFF_LIBS		= libtiff*
LIBTIFF_PKGCONFIGS	=

LIBTIFF_CONFIGURE_OPTS	:= --disable-cxx --program-prefix=""

#
# libtiff for host development machine
#
LIBTIFF_HOST_NAME		:= $(LIBTIFF_NAME)
LIBTIFF_HOST_VERSION		:= $(LIBTIFF_VERSION)
LIBTIFF_HOST_SITE		:= $(LIBTIFF_SITE)
LIBTIFF_HOST_SITE_MIRROR1	:= $(LIBTIFF_SITE_MIRROR1)
LIBTIFF_HOST_SITE_MIRROR2	:= $(LIBTIFF_SITE_MIRROR2)
LIBTIFF_HOST_SITE_MIRROR3	:= $(LIBTIFF_SITE_MIRROR3)
LIBTIFF_HOST_PACKAGE		:= $(LIBTIFF_PACKAGE)
LIBTIFF_HOST_SRC_DIR		:= $(embtk_toolsb)/tiff-$(LIBTIFF_VERSION)
LIBTIFF_HOST_BUILD_DIR		:= $(embtk_toolsb)/tiff-$(LIBTIFF_VERSION)

LIBTIFF_HOST_CONFIGURE_OPTS	:= --disable-cxx --program-prefix=""

