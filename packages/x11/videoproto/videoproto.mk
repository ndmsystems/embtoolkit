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
# \file         videoproto.mk
# \brief	videoproto.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

VIDEOPROTO_NAME		:= videoproto
VIDEOPROTO_VERSION	:= $(call embtk_get_pkgversion,videoproto)
VIDEOPROTO_SITE		:= http://ftp.x.org/pub/individual/proto
VIDEOPROTO_PACKAGE	:= videoproto-$(VIDEOPROTO_VERSION).tar.bz2
VIDEOPROTO_SRC_DIR	:= $(embtk_pkgb)/videoproto-$(VIDEOPROTO_VERSION)
VIDEOPROTO_BUILD_DIR	:= $(embtk_pkgb)/videoproto-$(VIDEOPROTO_VERSION)

VIDEOPROTO_BINS		=
VIDEOPROTO_SBINS	=
VIDEOPROTO_INCLUDES	= X11/extensions/vldXvMC.h X11/extensions/Xv.h		\
			X11/extensions/XvMC.h X11/extensions/XvMCproto.h	\
			X11/extensions/Xvproto.h
VIDEOPROTO_LIBS		=
VIDEOPROTO_PKGCONFIGS	= videoproto.pc

