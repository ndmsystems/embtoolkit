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
# \file         libpthreadstubs.mk
# \brief	libpthreadstubs.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

LIBPTHREADSTUBS_NAME		:= libpthread-stubs
LIBPTHREADSTUBS_VERSION		:= $(call embtk_get_pkgversion,libpthreadstubs)
LIBPTHREADSTUBS_SITE		:= http://xcb.freedesktop.org/dist
LIBPTHREADSTUBS_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
LIBPTHREADSTUBS_PACKAGE		:= libpthread-stubs-$(LIBPTHREADSTUBS_VERSION).tar.bz2
LIBPTHREADSTUBS_SRC_DIR		:= $(embtk_pkgb)/libpthread-stubs-$(LIBPTHREADSTUBS_VERSION)
LIBPTHREADSTUBS_BUILD_DIR	:= $(embtk_pkgb)/libpthread-stubs-$(LIBPTHREADSTUBS_VERSION)

LIBPTHREADSTUBS_BINS		=
LIBPTHREADSTUBS_SBINS		=
LIBPTHREADSTUBS_INCLUDES	=
LIBPTHREADSTUBS_LIBS		=
LIBPTHREADSTUBS_PKGCONFIGS	= pthread-stubs.pc
