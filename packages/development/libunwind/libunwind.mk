################################################################################
# Embtoolkit
# Copyright(C) 2009-2012 Abdoulaye Walsimou GAYE.
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
# \file         libunwind.mk
# \brief	libunwind.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

LIBUNWIND_NAME		:= libunwind
LIBUNWIND_VERSION	:= $(call embtk_get_pkgversion,libunwind)
LIBUNWIND_SITE		:= http://download.savannah.nongnu.org/releases/libunwind
LIBUNWIND_PACKAGE	:= libunwind-$(LIBUNWIND_VERSION).tar.gz
LIBUNWIND_SRC_DIR	:= $(embtk_pkgb)/libunwind-$(LIBUNWIND_VERSION)
LIBUNWIND_BUILD_DIR	:= $(embtk_pkgb)/libunwind-$(LIBUNWIND_VERSION)

LIBUNWIND_INCLUDES	:= libunwind*.h
LIBUNWIND_LIBS		:= libunwind*
LIBUNWIND_PKGCONFIGS	:= libunwind*.pc

LIBUNWIND_CONFIGURE_OPTS	:= --enable-cxx-exceptions --disable-coredump
LIBUNWIND_CONFIGURE_OPTS	+= --enable-static --disable-shared
