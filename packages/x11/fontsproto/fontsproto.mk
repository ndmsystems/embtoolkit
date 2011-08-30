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
# \file         fontsproto.mk
# \brief	fontsproto.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         February 2010
################################################################################

FONTSPROTO_NAME		:= fontsproto
FONTSPROTO_VERSION	:= $(call embtk_get_pkgversion,fontsproto)
FONTSPROTO_SITE		:= http://xorg.freedesktop.org/archive/individual/proto
FONTSPROTO_PACKAGE	:= fontsproto-$(FONTSPROTO_VERSION).tar.bz2
FONTSPROTO_SRC_DIR	:= $(PACKAGES_BUILD)/fontsproto-$(FONTSPROTO_VERSION)
FONTSPROTO_BUILD_DIR	:= $(PACKAGES_BUILD)/fontsproto-$(FONTSPROTO_VERSION)

FONTSPROTO_BINS		=
FONTSPROTO_SBINS	=
FONTSPROTO_INCLUDES	= X11/fonts/font.h X11/fonts/fontproto.h		\
			X11/fonts/fontstruct.h X11/fonts/FS.h			\
			X11/fonts/fsmasks.h X11/fonts/FSproto.h
FONTSPROTO_LIBS		=
FONTSPROTO_PKGCONFIGS	= fontsproto.pc

