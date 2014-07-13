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
# \file         libressl.mk
# \brief	libressl.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
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

#
# remove -Werror and -O2 compiler switches
#
define embtk_beforeinstall_libressl
	find $(LIBRESSL_SRC_DIR) -type f -name '*.m4' -exec chmod 0664 {} +
	for f in $$(grep -Rl '\-Werror' $(LIBRESSL_SRC_DIR)/*); do \
		sed -e 's/-Werror//g' < $$f > $$f.tmp; mv $$f.tmp $$f; \
	done
	for f in $$(grep -Rl '\-O2' $(LIBRESSL_SRC_DIR)/*); do \
		sed -e 's/-O2//g' < $$f > $$f.tmp; mv $$f.tmp $$f; \
	done
endef
