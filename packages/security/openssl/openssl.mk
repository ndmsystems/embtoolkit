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
# \file         openssl.mk
# \brief	openssl.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         February 2010
################################################################################

OPENSSL_NAME		:= openssl
OPENSSL_VERSION		:= $(call embtk_get_pkgversion,openssl)
OPENSSL_SITE		:= ftp://ftp.openssl.org/source
OPENSSL_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
OPENSSL_PACKAGE		:= openssl-$(OPENSSL_VERSION).tar.gz
OPENSSL_SRC_DIR		:= $(embtk_pkgb)/openssl-$(OPENSSL_VERSION)
OPENSSL_BUILD_DIR	:= $(embtk_pkgb)/openssl-$(OPENSSL_VERSION)

OPENSSL_NODESTDIR	:= y
OPENSSL_MAKE_OPTS	:= CC=$(TARGETCC_CACHED) INSTALL_PREFIX=$(embtk_sysroot)
OPENSSL_MAKE_OPTS	+= LIBDIR=$(LIBDIR) MANDIR=/usr/share/man -j1

OPENSSL_ETC		= ssl
OPENSSL_BINS		= c_rehash openssl
OPENSSL_SBINS		=
OPENSSL_INCLUDES	= openssl
OPENSSL_PKGCONFIGS	= libcrypto.pc libssl.pc openssl.pc
OPENSSL_LIBS		= engines/lib4758cca.so engines/libaep.so		\
			engines/libatalla.so engines/libcapi.so			\
			engines/libchil.so engines/libcswift.so			\
			engines/libgmp.so engines/libnuron.so			\
			engines/libsureware.so engines/libubsec.so libcrypto.*	\
			libssl.*

ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
OPENSSL_LINUX_TARGET := linux-generic32
else ifeq ($(CONFIG_EMBTK_64BITS_FS),y)
OPENSSL_LINUX_TARGET := linux-generic64
else
OPENSSL_LINUX_TARGET := linux-generic32
endif

define embtk_install_openssl
	$(call embtk_makeinstall_pkg,openssl)
endef

define embtk_beforeinstall_openssl
	$(Q)rm -rf $(OPENSSL_BUILD_DIR)/.postinstalled
	$(Q)cd $(OPENSSL_BUILD_DIR);						\
	$(CONFIG_EMBTK_SHELL) $(OPENSSL_SRC_DIR)/Configure $(OPENSSL_LINUX_TARGET)	\
	--openssldir=/etc/ssl --prefix=/usr shared
endef

define embtk_postinstallonce_openssl
	$(MAKE) libtool_files_adapt
endef

define embtk_postinstall_openssl
	$(Q)mkdir -p $(embtk_rootfs)
	$(Q)mkdir -p $(embtk_rootfs)/etc
	$(Q)-cp -R $(embtk_sysroot)/etc/ssl $(embtk_rootfs)/etc/
endef
