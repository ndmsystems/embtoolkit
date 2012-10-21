################################################################################
# Embtoolkit
# Copyright(C) 2012 Abdoulaye Walsimou GAYE.
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
# \file         libtirpc.mk
# \brief	libtirpc.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         October 2012
################################################################################

LIBTIRPC_NAME		:= libtirpc
LIBTIRPC_VERSION	:= $(call embtk_get_pkgversion,libtirpc)
LIBTIRPC_SITE		:= http://downloads.sourceforge.net/project/libtirpc/libtirpc/$(LIBTIRPC_VERSION)
LIBTIRPC_PACKAGE	:= libtirpc-$(LIBTIRPC_VERSION).tar.bz2
LIBTIRPC_SRC_DIR	:= $(embtk_pkgb)/libtirpc-$(LIBTIRPC_VERSION)
LIBTIRPC_BUILD_DIR	:= $(embtk_pkgb)/libtirpc-$(LIBTIRPC_VERSION)

LIBTIRPC_BINS		:=
LIBTIRPC_ETC		:= netconfig
LIBTIRPC_SBINS		:=
LIBTIRPC_INCLUDES	:= tirpc
LIBTIRPC_LIBS		:= libtirpc.*
LIBTIRPC_LIBEXECS	:=
LIBTIRPC_PKGCONFIGS	:= libtirpc.pc
