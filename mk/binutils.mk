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
# \file         binutils.mk
# \brief	binutils.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

BINUTILS_NAME		:= binutils
BINUTILS_VERSION	:= $(call embtk_get_pkgversion,binutils)
BINUTILS_SITE		:= http://ftp.gnu.org/gnu/binutils
BINUTILS_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
BINUTILS_PACKAGE	:= binutils-$(BINUTILS_VERSION).tar.bz2
BINUTILS_SRC_DIR	:= $(TOOLS_BUILD)/binutils-$(BINUTILS_VERSION)
BINUTILS_BUILD_DIR	:= $(TOOLS_BUILD)/binutils-build

BINUTILS_CONFIGURE_OPTS	:= --with-sysroot=$(SYSROOT) --disable-werror	\
			--disable-nls --disable-multilib		\
			--with-gmp=$(GMP_HOST_DIR)			\
			--with-mpfr=$(MPFR_HOST_DIR)			\
			--with-mpc=$(MPC_HOST_DIR)			\
			--target=$(STRICT_GNU_TARGET)
BINUTILS_PREFIX		:= $(TOOLS)

binutils_install:
	$(call embtk_install_hostpkg,binutils)
