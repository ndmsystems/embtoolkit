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
# \file         renderproto.mk
# \brief	renderproto.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

RENDERPROTO_NAME	:= renderproto
RENDERPROTO_VERSION	:= $(call embtk_get_pkgversion,renderproto)
RENDERPROTO_SITE	:= http://xorg.freedesktop.org/archive/individual/proto
RENDERPROTO_PACKAGE	:= renderproto-$(RENDERPROTO_VERSION).tar.bz2
RENDERPROTO_SRC_DIR	:= $(embtk_pkgb)/renderproto-$(RENDERPROTO_VERSION)
RENDERPROTO_BUILD_DIR	:= $(embtk_pkgb)/renderproto-$(RENDERPROTO_VERSION)

RENDERPROTO_BINS	=
RENDERPROTO_SBINS	=
RENDERPROTO_INCLUDES	= X11/extensions/render.h X11/extensions/renderproto.h
RENDERPROTO_LIBS	=
RENDERPROTO_PKGCONFIGS	= renderproto.pc

