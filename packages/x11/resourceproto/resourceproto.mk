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
# \file         resourceproto.mk
# \brief	resourceproto.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

RESOURCEPROTO_NAME	:= resourceproto
RESOURCEPROTO_VERSION	:= $(call embtk_get_pkgversion,resourceproto)
RESOURCEPROTO_SITE	:= http://ftp.x.org/pub/individual/proto
RESOURCEPROTO_PACKAGE	:= resourceproto-$(RESOURCEPROTO_VERSION).tar.bz2
RESOURCEPROTO_SRC_DIR	:= $(embtk_pkgb)/resourceproto-$(RESOURCEPROTO_VERSION)
RESOURCEPROTO_BUILD_DIR	:= $(embtk_pkgb)/resourceproto-$(RESOURCEPROTO_VERSION)

RESOURCEPROTO_BINS =
RESOURCEPROTO_SBINS =
RESOURCEPROTO_INCLUDES = X11/extensions/XResproto.h
RESOURCEPROTO_LIBS =
RESOURCEPROTO_PKGCONFIGS = resourceproto.pc

