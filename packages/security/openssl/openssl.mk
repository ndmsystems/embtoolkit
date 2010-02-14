################################################################################
# GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# Copyright(C) 2010 GAYE Abdoulaye Walsimou. All rights reserved.
#
# This program is free software; you can distribute it and/or modify it
# under the terms of the GNU General Public License
# (Version 2 or later) published by the Free Software Foundation.
#
# This program is distributed in the hope it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
################################################################################
#
# \file         openssl.mk
# \brief	openssl.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
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

openssl_install: $(OPENSSL_BUILD_DIR)/.installed

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
	$(Q)-cp -R $(SYSROOT)/etc/ssl $(ROOTFS)/etc/
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
	$(Q)-cd $(SYSROOT)/usr/lib; rm -rf $(OPENSSL_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib/pkgconfig; rm -rf $(OPENSSL_PKGCONFIGS)
	$(Q)-cd $(SYSROOT)/etc; rm -rf $(OPENSSL_ETC)
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cd $(SYSROOT)/usr/lib32; rm -rf $(OPENSSL_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib32/pkgconfig; rm -rf $(OPENSSL_PKGCONFIGS)
endif

