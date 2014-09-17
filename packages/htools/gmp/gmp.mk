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
# \brief	gmp.mk of Embtoolkit for toolchain
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

GMP_HOST_NAME		:= gmp
GMP_HOST_VERSION	:= $(call embtk_get_pkgversion,gmp_host)
GMP_HOST_SITE		:= ftp://ftp.gmplib.org/pub/gmp-$(GMP_HOST_VERSION)
GMP_HOST_PACKAGE	:= gmp-$(GMP_HOST_VERSION).tar.xz
GMP_HOST_SRC_DIR	:= $(embtk_toolsb)/gmp-$(GMP_HOST_VERSION)
GMP_HOST_BUILD_DIR	:= $(embtk_toolsb)/gmp-$(GMP_HOST_VERSION)-build

GMP_HOST_CONFIGURE_OPTS	:= --disable-shared --enable-static
