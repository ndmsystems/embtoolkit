################################################################################
# Embtoolkit
# Copyright(C) 2010-2014 Abdoulaye Walsimou GAYE.
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
# \file         libtool.mk
# \brief	libtool.mk of Embtoolkit.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

LIBTOOL_HOST_NAME	:= libtool
LIBTOOL_HOST_VERSION	:= $(call embtk_get_pkgversion,libtool_host)
LIBTOOL_HOST_SITE	:= http://ftp.gnu.org/gnu/libtool
LIBTOOL_HOST_PACKAGE	:= libtool-$(LIBTOOL_HOST_VERSION).tar.gz
LIBTOOL_HOST_SRC_DIR	:= $(embtk_toolsb)/libtool-$(LIBTOOL_HOST_VERSION)
LIBTOOL_HOST_BUILD_DIR	:= $(embtk_toolsb)/libtool-$(LIBTOOL_HOST_VERSION)
