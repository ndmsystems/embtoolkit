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
# GNU General Public License kbprotor more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
################################################################################
#
# \file         kbproto.mk
# \brief	kbproto.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         February 2010
################################################################################

KBPROTO_NAME		:= kbproto
KBPROTO_VERSION		:= $(call embtk_get_pkgversion,kbproto)
KBPROTO_SITE		:= http://xorg.freedesktop.org/archive/individual/proto
KBPROTO_PACKAGE		:= kbproto-$(KBPROTO_VERSION).tar.bz2
KBPROTO_SRC_DIR		:= $(embtk_pkgb)/kbproto-$(KBPROTO_VERSION)
KBPROTO_BUILD_DIR	:= $(embtk_pkgb)/kbproto-$(KBPROTO_VERSION)

KBPROTO_BINS		=
KBPROTO_SBINS		=
KBPROTO_INCLUDES	= X11/extensions/XKBgeom.h X11/extensions/XKB.h		\
			X11/extensions/XKBproto.h X11/extensions/XKBsrv.h	\
			X11/extensions/XKBstr.h
KBPROTO_LIBS		=
KBPROTO_PKGCONFIGS	= kbproto.pc

