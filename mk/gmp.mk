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
# \file         gmp.mk
# \brief	gmp.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

GMP_HOST_NAME		:= gmp
GMP_HOST_VERSION	:= $(call embtk_get_pkgversion,gmp)
GMP_HOST_SITE		:= ftp://ftp.gmplib.org/pub/gmp-$(GMP_HOST_VERSION)
GMP_HOST_PACKAGE	:= gmp-$(GMP_HOST_VERSION).tar.bz2
GMP_HOST_SRC_DIR	:= $(TOOLS_BUILD)/gmp-$(GMP_HOST_VERSION)
GMP_HOST_BUILD_DIR	:= $(TOOLS_BUILD)/gmp-build
GMP_HOST_DIR		:= $(HOSTTOOLS)/usr/local/gmp-host

export GMP_HOST_DIR

GMP_HOST_CONFIGURE_OPTS	:= --disable-shared --enable-static
GMP_HOST_PREFIX		:= $(GMP_HOST_DIR)
