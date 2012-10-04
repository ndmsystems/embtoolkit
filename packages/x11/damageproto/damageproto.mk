################################################################################
# Embtoolkit
# Copyright(C) 2009-2011 Abdoulaye Walsimou GAYE.
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
# \file         damageproto.mk
# \brief	damageproto.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

DAMAGEPROTO_NAME	:= damageproto
DAMAGEPROTO_VERSION	:= $(call embtk_get_pkgversion,damageproto)
DAMAGEPROTO_SITE	:= http://xorg.freedesktop.org/archive/individual/proto
DAMAGEPROTO_PACKAGE	:= damageproto-$(DAMAGEPROTO_VERSION).tar.bz2
DAMAGEPROTO_SRC_DIR	:= $(embtk_pkgb)/damageproto-$(DAMAGEPROTO_VERSION)
DAMAGEPROTO_BUILD_DIR	:= $(embtk_pkgb)/damageproto-$(DAMAGEPROTO_VERSION)

DAMAGEPROTO_BINS =
DAMAGEPROTO_SBINS =
DAMAGEPROTO_INCLUDES = X11/extnsions/damageproto.h damagewire.h
DAMAGEPROTO_LIBS =
DAMAGEPROTO_PKGCONFIGS = damageproto.pc

