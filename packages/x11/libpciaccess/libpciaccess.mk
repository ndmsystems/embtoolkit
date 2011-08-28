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
# \file         libpciaccess.mk
# \brief	libpciaccess.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

LIBPCIACCESS_NAME		:= libpciaccess
LIBPCIACCESS_VERSION		:= $(call embtk_get_pkgversion,libpciaccess)
LIBPCIACCESS_SITE		:= http://xorg.freedesktop.org/archive/individual/lib
LIBPCIACCESS_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
LIBPCIACCESS_PACKAGE		:= libpciaccess-$(LIBPCIACCESS_VERSION).tar.gz
LIBPCIACCESS_SRC_DIR		:= $(PACKAGES_BUILD)/libpciaccess-$(LIBPCIACCESS_VERSION)
LIBPCIACCESS_BUILD_DIR		:= $(PACKAGES_BUILD)/libpciaccess-$(LIBPCIACCESS_VERSION)

LIBPCIACCESS_BINS	=
LIBPCIACCESS_SBINS	=
LIBPCIACCESS_INCLUDES	= pciaccess.h
LIBPCIACCESS_LIBS	= libpciaccess.*
LIBPCIACCESS_PKGCONFIGS	= pciaccess.pc

