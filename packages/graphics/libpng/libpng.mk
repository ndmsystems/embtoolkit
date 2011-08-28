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
# \file         libpng.mk
# \brief	libpng.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         October 2009
################################################################################

LIBPNG_NAME		:= libpng
LIBPNG_VERSION		:= $(call embtk_get_pkgversion,libpng)
LIBPNG_SITE		:= http://download.sourceforge.net/libpng
LIBPNG_PACKAGE		:= libpng-$(LIBPNG_VERSION).tar.gz
LIBPNG_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
LIBPNG_SRC_DIR		:= $(PACKAGES_BUILD)/libpng-$(LIBPNG_VERSION)
LIBPNG_BUILD_DIR	:= $(PACKAGES_BUILD)/libpng-$(LIBPNG_VERSION)

LIBPNG_BINS		= libpng*
LIBPNG_SBINS		=
LIBPNG_INCLUDES		= libpng* png*
LIBPNG_LIBS		= libpng*
LIBPNG_PKGCONFIGS	= libpng*

LIBPNG_CONFIGURE_OPTS	:= --with-libpng-compat=no
LIBPNG_DEPS		:= zlib_install

#
# libpng for host development machine
#

LIBPNG_HOST_NAME		:= $(LIBPNG_NAME)
LIBPNG_HOST_VERSION		:= $(LIBPNG_VERSION)
LIBPNG_HOST_SITE		:= $(LIBPNG_SITE)
LIBPNG_HOST_PACKAGE		:= $(LIBPNG_PACKAGE)
LIBPNG_HOST_SITE_MIRROR1	:= $(LIBPNG_SITE_MIRROR1)
LIBPNG_HOST_SITE_MIRROR2	:= $(LIBPNG_SITE_MIRROR2)
LIBPNG_HOST_SITE_MIRROR3	:= $(LIBPNG_SITE_MIRROR3)
LIBPNG_HOST_SRC_DIR		:= $(TOOLS_BUILD)/libpng-$(LIBPNG_VERSION)
LIBPNG_HOST_BUILD_DIR		:= $(TOOLS_BUILD)/libpng-$(LIBPNG_VERSION)

LIBPNG_HOST_CONFIGURE_OPTS	:= --with-libpng-compat=no
LIBPNG_HOST_DEPS		:= zlib_host_install

