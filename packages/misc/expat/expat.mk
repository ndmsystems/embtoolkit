################################################################################
# Embtoolkit
# Copyright(C) 2010 Abdoulaye Walsimou GAYE. All rights reserved.
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
# \file         expat.mk
# \brief	expat.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         July 2010
################################################################################

EXPAT_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_EXPAT_VERSION_STRING)))
EXPAT_SITE := http://downloads.sourceforge.net/expat
EXPAT_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/expat/$(EXPAT_VERSION)
EXPAT_PACKAGE := expat-$(EXPAT_VERSION).tar.gz
EXPAT_BUILD_DIR := $(PACKAGES_BUILD)/expat-$(EXPAT_VERSION)

EXPAT_BINS = xmlwf
EXPAT_SBINS =
EXPAT_INCLUDES = expat_external.h expat.h
EXPAT_LIBS = libexpat.*
EXPAT_PKGCONFIGS =

EXPAT_DEPS =

expat_install:
	@test -e $(EXPAT_BUILD_DIR)/.installed || \
	$(MAKE) $(EXPAT_BUILD_DIR)/.installed

$(EXPAT_BUILD_DIR)/.installed: $(EXPAT_DEPS) download_expat \
	$(EXPAT_BUILD_DIR)/.decompressed $(EXPAT_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	expat-$(EXPAT_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(EXPAT_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(EXPAT_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_expat:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(EXPAT_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(EXPAT_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(EXPAT_PACKAGE) \
	$(EXPAT_SITE)/$(EXPAT_PACKAGE)
ifeq ($(CONFIG_EMBTK_EXPAT_NEED_PATCH),y)
	@test -e $(DOWNLOAD_DIR)/expat-$(EXPAT_VERSION).patch || \
	wget -O $(DOWNLOAD_DIR)/expat-$(EXPAT_VERSION).patch \
	$(EXPAT_PATCH_SITE)/expat-$(EXPAT_VERSION)-*.patch
endif

$(EXPAT_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(EXPAT_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzf $(DOWNLOAD_DIR)/$(EXPAT_PACKAGE)
ifeq ($(CONFIG_EMBTK_EXPAT_NEED_PATCH),y)
	@cd $(PACKAGES_BUILD)/expat-$(EXPAT_VERSION); \
	patch -p1 < $(DOWNLOAD_DIR)/expat-$(EXPAT_VERSION).patch
endif
	@touch $@

$(EXPAT_BUILD_DIR)/.configured:
	$(Q)cd $(EXPAT_BUILD_DIR); \
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
	--prefix=/usr
	@touch $@

expat_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup expat...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(EXPAT_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(EXPAT_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(EXPAT_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(EXPAT_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(EXPAT_PKGCONFIGS)
	$(Q)-rm -rf $(EXPAT_BUILD_DIR)*

