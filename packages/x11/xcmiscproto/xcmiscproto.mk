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
# \file         xcmiscproto.mk
# \brief	xcmiscproto.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

XCMISCPROTO_NAME	:= xcmiscproto
XCMISCPROTO_VERSION	:= $(call embtk_get_pkgversion,xcmiscproto)
XCMISCPROTO_SITE	:= http://xorg.freedesktop.org/archive/individual/proto
XCMISCPROTO_PACKAGE	:= xcmiscproto-$(XCMISCPROTO_VERSION).tar.bz2
XCMISCPROTO_SRC_DIR	:= $(embtk_pkgb)/xcmiscproto-$(XCMISCPROTO_VERSION)
XCMISCPROTO_BUILD_DIR	:= $(embtk_pkgb)/xcmiscproto-$(XCMISCPROTO_VERSION)

XCMISCPROTO_BINS	=
XCMISCPROTO_SBINS	=
XCMISCPROTO_INCLUDES	= X11/extensions/xcmiscproto.h X11/extensions/xcmiscstr.h
XCMISCPROTO_LIBS	=
XCMISCPROTO_PKGCONFIGS	= xcmiscproto.pc

