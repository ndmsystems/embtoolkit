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
# \file         mpc.mk
# \brief	mpch.mk of Embtoolkit for toolchain
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         Jan 2010
################################################################################

MPC_HOST_NAME		:= mpc
MPC_HOST_VERSION	:= $(call embtk_get_pkgversion,mpc_host)
MPC_HOST_SITE		:= http://www.multiprecision.org/mpc/download
MPC_HOST_PACKAGE	:= mpc-$(MPC_HOST_VERSION).tar.gz
MPC_HOST_SRC_DIR	:= $(embtk_toolsb)/mpc-$(MPC_HOST_VERSION)
MPC_HOST_BUILD_DIR	:= $(embtk_toolsb)/mpc-build
MPC_HOST_DIR		:= $(embtk_htools)/usr/local/mpc-host

export MPC_HOST_DIR

MPC_HOST_CONFIGURE_OPTS	:= --disable-shared --enable-static	\
				--with-gmp=$(GMP_HOST_DIR)	\
				--with-mpfr=$(MPFR_HOST_DIR)
MPC_HOST_PREFIX		:= $(MPC_HOST_DIR)

define embtk_cleanup_mpc_host
	rm -rf $(MPC_HOST_BUILD_DIR)
endef

mpc_host_clean:
	$(Q)$(embtk_cleanup_mpc_host)
