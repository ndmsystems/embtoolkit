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
# \file         libelf.mk
# \brief	libelf.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         January 2010
################################################################################

LIBELF_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_LIBELF_VERSION_STRING)))
LIBELF_SITE := http://www.mr511.de/software
LIBELF_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/libelf/$(LIBELF_VERSION)
LIBELF_PACKAGE := libelf-$(LIBELF_VERSION).tar.gz
LIBELF_BUILD_DIR := $(PACKAGES_BUILD)/libelf-$(LIBELF_VERSION)

LIBELF_BINS =
LIBELF_SBINS =
LIBELF_INCLUDES = libelf gelf.h libelf.h nlist.h
LIBELF_LIBS = libelf.a
LIBELF_PKGCONFIGS = libelf.pc

LIBELF_DEPS := gettext_install

libelf_install:
	@test -e $(LIBELF_BUILD_DIR)/.installed || \
	$(MAKE) $(LIBELF_BUILD_DIR)/.installed

$(LIBELF_BUILD_DIR)/.installed: $(LIBELF_DEPS) download_libelf \
	$(LIBELF_BUILD_DIR)/.decompressed $(LIBELF_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	libelf-$(LIBELF_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(LIBELF_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBELF_BUILD_DIR) install
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_libelf:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(LIBELF_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(LIBELF_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(LIBELF_PACKAGE) \
	$(LIBELF_SITE)/$(LIBELF_PACKAGE)
ifeq ($(CONFIG_EMBTK_LIBELF_NEED_PATCH),y)
	@test -e $(DOWNLOAD_DIR)/libelf-$(LIBELF_VERSION).patch || \
	wget -O $(DOWNLOAD_DIR)/libelf-$(LIBELF_VERSION).patch \
	$(LIBELF_PATCH_SITE)/libelf-$(LIBELF_VERSION)-*.patch
endif

$(LIBELF_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LIBELF_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzf $(DOWNLOAD_DIR)/$(LIBELF_PACKAGE)
ifeq ($(CONFIG_EMBTK_LIBELF_NEED_PATCH),y)
	cd $(LIBELF_BUILD_DIR); \
	patch -p1 < $(DOWNLOAD_DIR)/libelf-$(LIBELF_VERSION).patch
endif
	@touch $@

$(LIBELF_BUILD_DIR)/.configured:
	$(Q)cd $(LIBELF_BUILD_DIR); \
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
	./configure --build=$(HOST_BUILD) \
	--host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) \
	--prefix=$(SYSROOT)/usr --enable-elf64 --libdir=$(SYSROOT)/usr/$(LIBDIR)
	@touch $@

libelf_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup libelf...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(LIBELF_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(LIBELF_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(LIBELF_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(LIBELF_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(LIBELF_PKGCONFIGS)
	$(Q)-rm -rf $(LIBELF_BUILD_DIR)*

