################################################################################
# Embtoolkit
# Copyright(C) 2009-2010 Abdoulaye Walsimou GAYE. All rights reserved.
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
# \file         libxml.mk
# \brief	libxml.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
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

libxml2_install:
	@test -e $(LIBXML2_BUILD_DIR)/.installed || \
	$(MAKE) $(LIBXML2_BUILD_DIR)/.installed

$(LIBXML2_BUILD_DIR)/.installed: download_libxml2 \
	$(LIBXML2_BUILD_DIR)/.decompressed $(LIBXML2_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	libxml2-$(LIBXML2_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH, $(LIBXML2_BUILD_DIR))
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
	CC=$(TARGETCC_CACHED) \
	CXX=$(TARGETCXX_CACHED) \
	AR=$(TARGETAR) \
	RANLIB=$(TARGETRANLIB) \
	AS=$(CROSS_COMPILE)as \
	LD=$(TARGETLD) \
	NM=$(TARGETNM) \
	STRIP=$(TARGETSTRIP) \
	OBJDUMP=$(TARGETOBJDUMP) \
	OBJCOPY=$(TARGETOBJCOPY) \
	CFLAGS="$(TARGET_CFLAGS)" \
	CXXFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="-L$(SYSROOT)/$(LIBDIR) -L$(SYSROOT)/usr/$(LIBDIR)" \
	CPPFLAGS="-I$(SYSROOT)/usr/include" \
	PKG_CONFIG=$(PKGCONFIG_BIN) \
	PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) --libdir=/usr/$(LIBDIR) \
	--prefix=/usr --disable-rpath --without-python
	@touch $@

libxml2_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup fontconfig-$(FONTCONFIG_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(LIBXML2_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(LIBXML2_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(LIBXML2_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(LIBXML2_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(LIBXML2_PKGCONFIGS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(LIBXML2_LIBTOOLS)
	$(Q)-rm -rf $(LIBXML2_BUILD_DIR)*

