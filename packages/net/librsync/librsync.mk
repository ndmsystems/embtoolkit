################################################################################
# Embtoolkit
# Copyright(C) 2014 Abdoulaye Walsimou GAYE.
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
# \file         librsync.mk
# \brief	librsync.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         January 2014
################################################################################

LIBRSYNC_NAME		:= librsync
LIBRSYNC_VERSION	:= $(call embtk_get_pkgversion,librsync)
LIBRSYNC_SITE		:= http://prdownloads.sourceforge.net/librsync
LIBRSYNC_PACKAGE	:= librsync-$(LIBRSYNC_VERSION).tar.gz
LIBRSYNC_SRC_DIR	:= $(embtk_pkgb)/librsync-$(LIBRSYNC_VERSION)
LIBRSYNC_BUILD_DIR	:= $(embtk_pkgb)/librsync-$(LIBRSYNC_VERSION)

LIBRSYNC_BINS		:= rdiff
LIBRSYNC_INCLUDES	:= librsync-config.h librsync.h
LIBRSYNC_LIBS		:= librsync.*
LIBRSYNC_CONFIGURE_OPTS	:= --enable-shared --disable-trace

LIBRSYNC_DEPS		:= popt_install
