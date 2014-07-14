################################################################################
# Embtoolkit
# Copyright(C) 2009-2014 Abdoulaye Walsimou GAYE.
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
# \file         libsigcpp.mk
# \brief        libsigcpp.mk of Embtoolkit
# \author       Ricardo Crudo <ricardo.crudo@gmail.com>
# \date         July 2014
################################################################################

LIBSIGCPP_NAME		:= libsigcpp
LIBSIGCPP_MAJOR_VERSION := $(call embtk_get_pkgversion,libsigcpp_major)
LIBSIGCPP_VERSION	:= $(call embtk_get_pkgversion,libsigcpp)
LIBSIGCPP_SITE		:= http://ftp.gnome.org/pub/GNOME/sources/libsigc++/$(LIBSIGCPP_MAJOR_VERSION)
LIBSIGCPP_PACKAGE	:= libsigc++-$(LIBSIGCPP_VERSION).tar.xz
LIBSIGCPP_SRC_DIR	:= $(embtk_pkgb)/libsigc++-$(LIBSIGCPP_VERSION)
LIBSIGCPP_BUILD_DIR	:= $(embtk_pkgb)/libsigc++-$(LIBSIGCPP_VERSION)

LIBSIGCPP_INCLUDES	:= sigc++-2.0
LIBSIGCPP_LIBS		:= libsigc* sigc++-2.0
LIBSIGCPP_PKGCONFIGS	:= sigc++*.pc
LIBSIGCPP_SHARES	:= doc/libsigc++-2.0 devhelp/books/libsigc++-2.0
