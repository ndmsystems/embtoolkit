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
# \file         inputproto.mk
# \brief	inputproto.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         February 2010
################################################################################

INPUTPROTO_NAME		:= inputproto
INPUTPROTO_VERSION	:= $(call embtk_get_pkgversion,inputproto)
INPUTPROTO_SITE		:= http://xorg.freedesktop.org/archive/individual/proto
INPUTPROTO_PACKAGE	:= inputproto-$(INPUTPROTO_VERSION).tar.bz2
INPUTPROTO_SRC_DIR	:= $(embtk_pkgb)/inputproto-$(INPUTPROTO_VERSION)
INPUTPROTO_BUILD_DIR	:= $(embtk_pkgb)/inputproto-$(INPUTPROTO_VERSION)

INPUTPROTO_BINS		=
INPUTPROTO_SBINS	=
INPUTPROTO_INCLUDES	= X11/extensions/XI2.h X11/extensions/XI2proto.h	\
			X11/extensions/XI.h X11/extensions/XIproto.h
INPUTPROTO_LIBS		=
INPUTPROTO_PKGCONFIGS	= inputproto.pc

