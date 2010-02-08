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
# \file         libelf.mk
# \brief	libelf.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
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

ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
PKG_CONFIG_PATH=$(SYSROOT)/usr/lib32/pkgconfig
else
PKG_CONFIG_PATH=$(SYSROOT)/usr/lib/pkgconfig
endif

libelf_install: $(LIBELF_BUILD_DIR)/.installed

$(LIBELF_BUILD_DIR)/.installed: gettext_install download_libelf \
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
	$(Q)test -e $(DOWNLOAD_DIR)/libelf-$(LIBELF_VERSION).patch || \
	wget -O $(DOWNLOAD_DIR)/libelf-$(LIBELF_VERSION).patch \
	$(LIBELF_PATCH_SITE)/libelf-$(LIBELF_VERSION)-*.patch
endif

$(LIBELF_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LIBELF_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzf $(DOWNLOAD_DIR)/$(LIBELF_PACKAGE)
ifeq ($(CONFIG_EMBTK_LIBELF_NEED_PATCH),y)
	cd $(PACKAGES_BUILD)/libelf-$(LIBELF_VERSION); \
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
	LDFLAGS="-L$(SYSROOT)/lib -L$(SYSROOT)/usr/lib \
	-L$(SYSROOT)/lib32 -L$(SYSROOT)/usr/lib32" \
	CPPFLGAS="-I$(SYSROOT)/usr/include" \
	PKG_CONFIG=$(PKGCONFIG_BIN) \
	PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
	./configure --build=$(HOST_BUILD) \
	--host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) \
	--prefix=$(SYSROOT)/usr --enable-elf64
	@touch $@

libelf_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup libelf-$(LIBELF_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(LIBELF_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(LIBELF_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(LIBELF_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/lib; rm -rf $(LIBELF_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib/pkgconfig; rm -rf $(LIBELF_PKGCONFIGS)
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cd $(SYSROOT)/usr/lib32; rm -rf $(LIBELF_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib32/pkgconfig; rm -rf $(LIBELF_PKGCONFIGS)
endif

