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
# \file         libressl.mk
# \brief	libressl.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         July 2014
################################################################################

LIBRESSL_NAME		:= libressl
LIBRESSL_VERSION	:= $(call embtk_get_pkgversion,libressl)
LIBRESSL_SITE		:= http://ftp.openbsd.org/pub/OpenBSD/LibreSSL
LIBRESSL_PACKAGE	:= libressl-$(LIBRESSL_VERSION).tar.gz
LIBRESSL_SRC_DIR	:= $(embtk_pkgb)/libressl-$(LIBRESSL_VERSION)
LIBRESSL_BUILD_DIR	:= $(embtk_pkgb)/libressl-$(LIBRESSL_VERSION)-build

LIBRESSL_BINS		:= openssl
LIBRESSL_INCLUDES	:= openssl
LIBRESSL_LIBS		:= libcrypto.* libssl.*

LIBRESSL_CONFIGURE_OPTS	:= --program-transform-name='s;$(STRICT_GNU_TARGET)-;;'
