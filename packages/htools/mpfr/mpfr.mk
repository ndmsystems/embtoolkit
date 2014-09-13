################################################################################
# Embtoolkit
# Copyright(C) 2009-2012 Abdoulaye Walsimou GAYE.
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
# \file         mpfr.mk
# \brief	mpfr.mk of Embtoolkit for toolchain
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

MPFR_HOST_NAME		:= mpfr
MPFR_HOST_VERSION	:= $(call embtk_get_pkgversion,mpfr_host)
MPFR_HOST_SITE		:= http://www.mpfr.org/mpfr-$(MPFR_HOST_VERSION)
MPFR_HOST_PACKAGE	:= mpfr-$(MPFR_HOST_VERSION).tar.bz2
MPFR_HOST_SRC_DIR	:= $(embtk_toolsb)/mpfr-$(MPFR_HOST_VERSION)
MPFR_HOST_BUILD_DIR	:= $(embtk_toolsb)/mpfr-$(MPFR_HOST_VERSION)-build

MPFR_HOST_DEPS	:= gmp_host_install

MPFR_HOST_CONFIGURE_OPTS	:= --disable-shared --enable-static
MPFR_HOST_CONFIGURE_OPTS	+= --with-gmp=$(embtk_htools)/usr
