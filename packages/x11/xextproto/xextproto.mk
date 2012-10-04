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
# \file         xextproto.mk
# \brief	xextproto.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

XEXTPROTO_NAME		:= xextproto
XEXTPROTO_VERSION	:= $(call embtk_get_pkgversion,xextproto)
XEXTPROTO_SITE		:= http://xorg.freedesktop.org/archive/individual/proto
XEXTPROTO_PACKAGE	:= xextproto-$(XEXTPROTO_VERSION).tar.bz2
XEXTPROTO_SRC_DIR	:= $(embtk_pkgb)/xextproto-$(XEXTPROTO_VERSION)
XEXTPROTO_BUILD_DIR	:= $(embtk_pkgb)/xextproto-$(XEXTPROTO_VERSION)

XEXTPROTO_BINS =
XEXTPROTO_SBINS =
XEXTPROTO_INCLUDES = X11/extensions/ag.h X11/extensions/cupproto.h \
		X11/extensions/dpmsconst.h X11/extensions/EVIproto.h \
		X11/extensions/lbx.h X11/extensions/mitmiscproto.h \
		X11/extensions/secur.h X11/extensions/shapeproto.h \
		X11/extensions/syncconst.h X11/extensions/xtestext1const.h \
		X11/extensions/agproto.h X11/extensions/dbe.h \
		X11/extensions/dpmsproto.h X11/extensions/ge.h \
		X11/extensions/lbxproto.h X11/extensions/multibufconst.h \
		X11/extensions/securproto.h X11/extensions/shm.h \
		X11/extensions/syncproto.h X11/extensions/xtestext1proto.h \
		X11/extensions/cup.h X11/extensions/dbeproto.h \
		X11/extensions/EVI.h X11/extensions/geproto.h \
		X11/extensions/mitmiscconst.h X11/extensions/multibufproto.h \
		X11/extensions/shapeconst.h X11/extensions/shmproto.h \
		X11/extensions/xtestconst.h X11/extensions/xtestproto.h
XEXTPROTO_LIBS =
XEXTPROTO_PKGCONFIGS = xextproto.pc

