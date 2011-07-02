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

OPENSSL_NAME := openssl
OPENSSL_VERSION := $(call embtk_get_pkgversion,OPENSSL)
OPENSSL_SITE := ftp://ftp.openssl.org/source
OPENSSL_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
OPENSSL_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/openssl/$(OPENSSL_VERSION)
OPENSSL_PACKAGE := openssl-$(OPENSSL_VERSION).tar.gz
OPENSSL_SRC_DIR := $(PACKAGES_BUILD)/openssl-$(OPENSSL_VERSION)
OPENSSL_BUILD_DIR := $(PACKAGES_BUILD)/openssl-$(OPENSSL_VERSION)

OPENSSL_ETC = ssl
OPENSSL_BINS = c_rehash openssl
OPENSSL_SBINS =
OPENSSL_INCLUDES = openssl
OPENSSL_LIBS = engines/lib4758cca.so engines/libaep.so engines/libatalla.so \
		engines/libcapi.so engines/libchil.so engines/libcswift.so \
		engines/libgmp.so engines/libnuron.so engines/libsureware.so \
		engines/libubsec.so libcrypto.* libssl.*
OPENSSL_PKGCONFIGS = libcrypto.pc libssl.pc openssl.pc

ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
OPENSSL_LINUX_TARGET := linux-generic32
else ifeq ($(CONFIG_EMBTK_64BITS_FS),y)
OPENSSL_LINUX_TARGET := linux-generic64
else
OPENSSL_LINUX_TARGET := linux-generic32
endif

openssl_install:
	@test -e $(OPENSSL_BUILD_DIR)/.installed || \
	$(MAKE) $(OPENSSL_BUILD_DIR)/.installed
	$(Q)$(MAKE) $(OPENSSL_BUILD_DIR)/.special

$(OPENSSL_BUILD_DIR)/.installed: download_openssl \
	$(OPENSSL_BUILD_DIR)/.decompressed $(OPENSSL_BUILD_DIR)/.configured
	$(call embtk_generic_message,"Compiling and installing \
	openssl-$(OPENSSL_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(OPENSSL_BUILD_DIR) CC=$(TARGETCC_CACHED)
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)$(MAKE) -C $(OPENSSL_BUILD_DIR) \
	INSTALL_PREFIX=$(SYSROOT)/ LIBDIR=lib32 MANDIR=/usr/share/man install
else
	$(Q)$(MAKE) -C $(OPENSSL_BUILD_DIR) \
	INSTALL_PREFIX=$(SYSROOT) LIBDIR=lib MANDIR=/usr/share/man install
endif
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_openssl:
	$(call embtk_download_pkg,OPENSSL)

$(OPENSSL_BUILD_DIR)/.decompressed:
	$(call embtk_decompress_pkg,OPENSSL)

$(OPENSSL_BUILD_DIR)/.configured:
	$(Q)cd $(OPENSSL_BUILD_DIR); \
	./Configure $(OPENSSL_LINUX_TARGET) \
	--openssldir=/etc/ssl --prefix=/usr shared
	@touch $@

openssl_clean:
	$(call embtk_cleanup_pkg,OPENSSL)

.PHONY: $(OPENSSL_BUILD_DIR)/.special

$(OPENSSL_BUILD_DIR)/.special:
	$(Q)-cp -R $(SYSROOT)/etc/ssl $(ROOTFS)/etc/
	@touch $@
