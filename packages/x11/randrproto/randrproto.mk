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
# \file         randrproto.mk
# \brief	randrproto.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         February 2010
################################################################################

RANDRPROTO_NAME		:= randrproto
RANDRPROTO_VERSION	:= $(call embtk_get_pkgversion,randrproto)
RANDRPROTO_SITE		:= http://xorg.freedesktop.org/archive/individual/proto
RANDRPROTO_PACKAGE	:= randrproto-$(RANDRPROTO_VERSION).tar.bz2
RANDRPROTO_SRC_DIR	:= $(embtk_pkgb)/randrproto-$(RANDRPROTO_VERSION)
RANDRPROTO_BUILD_DIR	:= $(embtk_pkgb)/randrproto-$(RANDRPROTO_VERSION)

RANDRPROTO_BINS =
RANDRPROTO_SBINS =
RANDRPROTO_INCLUDES = X11/extensions/randr.h X11/extensions/randrproto.h
RANDRPROTO_LIBS =
RANDRPROTO_PKGCONFIGS = randrproto.pc

