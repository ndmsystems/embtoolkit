################################################################################
# Embtoolkit
# Copyright(C) 2011 Abdoulaye Walsimou GAYE.
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
# \file         libsigsegv.mk
# \brief	libsigsegv.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2011
################################################################################

LIBSIGSEGV_NAME		:= libsigsegv
LIBSIGSEGV_VERSION	:= $(call embtk_get_pkgversion,libsigsegv)
LIBSIGSEGV_SITE		:= ftp://ftp.gnu.org/pub/gnu/libsigsegv
LIBSIGSEGV_SITE_MIRROR1	:= http://ftp.gnu.org/gnu/libsigsegv
LIBSIGSEGV_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
LIBSIGSEGV_PACKAGE	:= libsigsegv-$(LIBSIGSEGV_VERSION).tar.gz
LIBSIGSEGV_SRC_DIR	:= $(embtk_pkgb)/libsigsegv-$(LIBSIGSEGV_VERSION)
LIBSIGSEGV_BUILD_DIR	:= $(embtk_pkgb)/libsigsegv-$(LIBSIGSEGV_VERSION)

LIBSIGSEGV_BINS		=
LIBSIGSEGV_SBINS	=
LIBSIGSEGV_INCLUDES	= sigsegv.h
LIBSIGSEGV_LIBS		= libsigsegv.*
LIBSIGSEGV_LIBEXECS	=
LIBSIGSEGV_PKGCONFIGS	=
