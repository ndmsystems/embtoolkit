################################################################################
# Embtoolkit
# Copyright(C) 2014 Abdoulaye Walsimou GAYE.
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
# \file         dropbear.mk
# \brief	dropbear.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         July 2014
################################################################################

DROPBEAR_NAME		:= dropbear
DROPBEAR_VERSION	:= $(call embtk_get_pkgversion,dropbear)
DROPBEAR_SITE		:= https://matt.ucc.asn.au/dropbear/releases
DROPBEAR_PACKAGE	:= dropbear-$(DROPBEAR_VERSION).tar.bz2
DROPBEAR_SRC_DIR	:= $(embtk_pkgb)/dropbear-$(DROPBEAR_VERSION)
DROPBEAR_BUILD_DIR	:= $(embtk_pkgb)/dropbear-$(DROPBEAR_VERSION)

DROPBEAR_BINS		:= dbclient dropbearconvert dropbearkey
DROPBEAR_SBINS		:= dropbear
DROPBEAR_SHARES		:= man/man1/dbclient.1 man/man1/dropbearconvert.1
DROPBEAR_SHARES		+= man/man1/dropbearkey.1
DROPBEAR_SHARES		+= man/man8/dropbear.8

DROPBEAR_CONFIGURE_OPTS	:= --disable-pam --enable-bundled-libtom

DROPBEAR_DEPS		:= zlib_install
