################################################################################
# Embtoolkit
# Copyright(C) 2009-2010 Abdoulaye Walsimou GAYE. All rights reserved.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
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

OPENSSL_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_OPENSSL_VERSION_STRING)))
OPENSSL_SITE := ftp://ftp.openssl.org/source
OPENSSL_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/openssl/$(OPENSSL_VERSION)
OPENSSL_PACKAGE := openssl-$(OPENSSL_VERSION).tar.gz
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
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	openssl-$(OPENSSL_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(OPENSSL_BUILD_DIR) CC=$(TARGETCC_CACHED)
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)$(MAKE) -C $(OPENSSL_BUILD_DIR) \
	INSTALL_PREFIX=$(SYSROOT)/ LIBDIR=lib32 MANDIR=/usr/share/man install
else
	$(Q)$(MAKE) -C $(OPENSSL_BUILD_DIR) \
	INSTALL_PREFIX=$(SYSROOT)/ LIBDIR=lib MANDIR=/usr/share/man install
endif
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_openssl:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(OPENSSL_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(OPENSSL_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(OPENSSL_PACKAGE) \
	$(OPENSSL_SITE)/$(OPENSSL_PACKAGE)
ifeq	($(CONFIG_EMBTK_OPENSSL_NEED_PATCH),y)
	@test -e $(DOWNLOAD_DIR)/openssl-$(OPENSSL_VERSION).patch || \
	wget $(OPENSSL_PATCH_SITE)/openssl-$(OPENSSL_VERSION)-*.patch \
	-O $(DOWNLOAD_DIR)/openssl-$(OPENSSL_VERSION).patch
endif


$(OPENSSL_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(OPENSSL_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzf $(DOWNLOAD_DIR)/$(OPENSSL_PACKAGE)
ifeq	($(CONFIG_EMBTK_OPENSSL_NEED_PATCH),y)
	cd $(OPENSSL_BUILD_DIR); \
	patch -p1 < $(DOWNLOAD_DIR)/openssl-$(OPENSSL_VERSION).patch
endif
	@touch $@

$(OPENSSL_BUILD_DIR)/.configured:
	$(Q)cd $(OPENSSL_BUILD_DIR); \
	./Configure $(OPENSSL_LINUX_TARGET) \
	--openssldir=/etc/ssl --prefix=/usr shared
	@touch $@

openssl_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup openssl-$(OPENSSL_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(OPENSSL_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(OPENSSL_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(OPENSSL_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(OPENSSL_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(OPENSSL_PKGCONFIGS)
	$(Q)-cd $(SYSROOT)/etc; rm -rf $(OPENSSL_ETC)
	$(Q)-rm -rf $(OPENSSL_BUILD_DIR)*

.PHONY: $(OPENSSL_BUILD_DIR)/.special

$(OPENSSL_BUILD_DIR)/.special:
	$(Q)-cp -R $(SYSROOT)/etc/ssl $(ROOTFS)/etc/
	@touch $@
