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
# \file         fixesproto.mk
# \brief	fixesproto.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         February 2010
################################################################################

FIXESPROTO_NAME		:= fixesproto
FIXESPROTO_VERSION	:= $(call embtk_get_pkgversion,fixesproto)
FIXESPROTO_SITE		:= http://xorg.freedesktop.org/archive/individual/proto
FIXESPROTO_PACKAGE	:= fixesproto-$(FIXESPROTO_VERSION).tar.bz2
FIXESPROTO_SRC_DIR	:= $(embtk_pkgb)/fixesproto-$(FIXESPROTO_VERSION)
FIXESPROTO_BUILD_DIR	:= $(embtk_pkgb)/fixesproto-$(FIXESPROTO_VERSION)

FIXESPROTO_BINS		=
FIXESPROTO_SBINS	=
FIXESPROTO_INCLUDES	= X11/extensions/xfixesproto.h X11/extensions/xfixeswire.h
FIXESPROTO_LIBS		=
FIXESPROTO_PKGCONFIGS	= fixesproto.pc

