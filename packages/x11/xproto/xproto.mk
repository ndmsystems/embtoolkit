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
# \file         xproto.mk
# \brief	xproto.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

XPROTO_NAME		:= xproto
XPROTO_VERSION		:= $(call embtk_get_pkgversion,xproto)
XPROTO_SITE		:= http://ftp.x.org/pub/individual/proto
XPROTO_PACKAGE		:= xproto-$(XPROTO_VERSION).tar.bz2
XPROTO_SRC_DIR		:= $(embtk_pkgb)/xproto-$(XPROTO_VERSION)
XPROTO_BUILD_DIR	:= $(embtk_pkgb)/xproto-$(XPROTO_VERSION)

XPROTO_BINS	=
XPROTO_SBINS	=
XPROTO_INCLUDES	= X11/keysymdef.h X11/Xalloca.h X11/Xatom.h X11/XF86keysym.h \
		X11/Xfuncs.h Xmd.h X11/Xos.h X11/Xpoll.h X11/Xprotostr.h \
		X11/keysym.h X11/Xarch.h X11/Xdefs.h X11/Xfuncproto.h X11/X.h \
		X11/Xosdefs.h  X11/Xos_r.h X11/Xproto.h X11/Xthreads.h
XPROTO_LIBS	=
XPROTO_PKGCONFIGS = xproto.pc

