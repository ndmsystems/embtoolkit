################################################################################
# GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# Copyright(C) 2009 GAYE Abdoulaye Walsimou. All rights reserved.
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
# \file         libxml.mk
# \brief	libxml.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         December 2009
################################################################################

LIBXML2_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_LIBXML2_VERSION_STRING)))
LIBXML2_SITE := ftp://xmlsoft.org/libxml2
LIBXML2_PACKAGE := libxml2-$(LIBXML2_VERSION).tar.gz
LIBXML2_BUILD_DIR := $(PACKAGES_BUILD)/libxml2-$(LIBXML2_VERSION)

LIBXML2_BINS = xml2-config xmlcatalog xmllint
LIBXML2_SBINS =
LIBXML2_INCLUDES = libxml2
LIBXML2_LIBS = libxml2* xml2Conf.sh
LIBXML2_PKGCONFIGS = libxml*.pc
LIBXML2_LIBTOOLS = libxml2.la

libxml2_install: $(LIBXML2_BUILD_DIR)/.installed

$(LIBXML2_BUILD_DIR)/.installed: download_libxml2 \
	$(LIBXML2_BUILD_DIR)/.decompressed $(LIBXML2_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	libxml2-$(LIBXML2_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(LIBXML2_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBXML2_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_libxml2:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(LIBXML2_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(LIBXML2_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(LIBXML2_PACKAGE) \
	$(LIBXML2_SITE)/$(LIBXML2_PACKAGE)

$(LIBXML2_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LIBXML2_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzvf $(DOWNLOAD_DIR)/$(LIBXML2_PACKAGE)
	@touch $@

$(LIBXML2_BUILD_DIR)/.configured:
	$(Q)cd $(LIBXML2_BUILD_DIR); \
	CC=$(TARGETCC_CACHED) CXX=$(TARGETCXX_CACHED) \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="-L$(SYSROOT)/lib -L$(SYSROOT)/usr/lib \
	-L$(SYSROOT)/lib32 -L$(SYSROOT)/usr/lib32" \
	CPPFLGAS="-I$(SYSROOT)/usr/include" \
	PKG_CONFIG=$(PKGCONFIG_BIN) \
	PKG_CONFIG_PATH=$(SYSROOT)/usr \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) \
	--prefix=/usr
	@touch $@

libxml2_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup fontconfig-$(FONTCONFIG_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(LIBXML2_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(LIBXML2_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(LIBXML2_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/lib; rm -rf $(LIBXML2_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib/pkgconfig; rm -rf $(LIBXML2_PKGCONFIGS)
	$(Q)-cd $(SYSROOT)/usr/lib/pkgconfig; rm -rf $(LIBXML2_LIBTOOLS)
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cd $(SYSROOT)/usr/lib32; rm -rf $(LIBXML2_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib32/pkgconfig; rm -rf $(LIBXML2_PKGCONFIGS)
	$(Q)-cd $(SYSROOT)/usr/lib32/pkgconfig; rm -rf $(LIBXML2_LIBTOOLS)
endif

