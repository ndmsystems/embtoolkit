#########################################################################################
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
#########################################################################################
#
# \file         gcc.mk
# \brief	gcc.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         May 2009
#########################################################################################

GCC_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_GCC_VERSION_STRING)))
GCC_SITE := ftp://ftp.lip6.fr/pub/gcc/releases/gcc-$(GCC_VERSION)
GCC_PACKAGE := gcc-$(GCC_VERSION).tar.bz2
GCC1_BUILD_DIR := $(TOOLS_BUILD)/gcc1
GCC2_BUILD_DIR := $(TOOLS_BUILD)/gcc2
GCC3_BUILD_DIR := $(TOOLS_BUILD)/gcc3

#Hard or soft floating point
ifeq ($(CONFIG_EMBTK_SOFTFLOAT),y)
GCC_FLOAT_TYPE := soft
else
GCC_FLOAT_TYPE := hard
endif

gcc1_install: $(GCC1_BUILD_DIR)/.built

gcc2_install: $(GCC2_BUILD_DIR)/.built

gcc3_install: $(GCC3_BUILD_DIR)/.installed

#Multilib or not?
ifeq ($(CONFIG_EMBTK_TOOLCHAIN_MULTILIB),y)
GCC_MULTILIB :=
else
GCC_MULTILIB := --disable-multilib
endif

#GCC first stage
$(GCC1_BUILD_DIR)/.built: download_gcc $(GCC1_BUILD_DIR)/.decompressed \
	$(GCC1_BUILD_DIR)/.configured
	PATH=$(PATH):$(TOOLS)/bin/ $(MAKE) -C $(GCC1_BUILD_DIR) && \
	PATH=$(PATH):$(TOOLS)/bin/ $(MAKE) -C $(GCC1_BUILD_DIR) install
	@touch $@
download_gcc:
	@test -e $(DOWNLOAD_DIR)/$(GCC_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(GCC_PACKAGE) $(GCC_SITE)/$(GCC_PACKAGE)

$(GCC1_BUILD_DIR)/.decompressed:
	$(call DECOMPRESS_MESSAGE,$(GCC_PACKAGE))
	@tar -C $(TOOLS_BUILD) -xjf $(DOWNLOAD_DIR)/$(GCC_PACKAGE)
	@mkdir -p $(GCC1_BUILD_DIR)
	@touch $@

$(GCC1_BUILD_DIR)/.configured:
	$(call CONFIGURE_MESSAGE,gcc-$(GCC_VERSION))
	cd $(GCC1_BUILD_DIR); CC=$(HOSTCC_CACHED) CXX=$(HOSTCXX_CACHED) \
	$(TOOLS_BUILD)/gcc-$(GCC_VERSION)/configure \
	--prefix=$(TOOLS) --with-sysroot=$(SYSROOT) --target=$(STRICT_GNU_TARGET) \
	--with-arch=$(GNU_TARGET_ARCH) --with-float=$(GCC_FLOAT_TYPE) \
	--host=$(HOST_ARCH) --build=$(HOST_BUILD) \
	--without-headers --with-newlib --disable-shared --disable-threads \
	--disable-libssp --disable-libgomp --disable-libmudflap --disable-nls \
	--enable-languages=c --with-gmp=$(GMP_HOST_DIR) --with-mpfr=$(MPFR_HOST_DIR) \
	$(GCC_MULTILIB) $(GCC_WITH_ABI)
	@touch $@

#GCC second stage
$(GCC2_BUILD_DIR)/.built: $(GCC2_BUILD_DIR)/.configured
	PATH=$(PATH):$(TOOLS)/bin/ $(MAKE) -C $(GCC2_BUILD_DIR) && \
	PATH=$(PATH):$(TOOLS)/bin/ $(MAKE) -C $(GCC2_BUILD_DIR) install
	@touch $@

$(GCC2_BUILD_DIR)/.configured:
	$(call CONFIGURE_MESSAGE,gcc-$(GCC_VERSION))
	@mkdir -p $(GCC2_BUILD_DIR)
	cd $(GCC2_BUILD_DIR); CC=$(HOSTCC_CACHED) CXX=$(HOSTCXX_CACHED) \
	$(TOOLS_BUILD)/gcc-$(GCC_VERSION)/configure \
	--prefix=$(TOOLS) --with-sysroot=$(SYSROOT) --target=$(STRICT_GNU_TARGET) \
	--with-arch=$(GNU_TARGET_ARCH) --with-float=$(GCC_FLOAT_TYPE) \
	--host=$(HOST_ARCH) --build=$(HOST_BUILD) \
	--disable-libssp --disable-libgomp --disable-libmudflap \
	--enable-languages=c --with-gmp=$(GMP_HOST_DIR) \
	--with-mpfr=$(MPFR_HOST_DIR) \
	$(GCC_MULTILIB) $(GCC_WITH_ABI)
	@touch $@

#GCC last stage
$(GCC3_BUILD_DIR)/.installed: $(GCC3_BUILD_DIR)/.configured
	PATH=$(PATH):$(TOOLS)/bin/ $(MAKE) -C $(GCC3_BUILD_DIR) && \
	PATH=$(PATH):$(TOOLS)/bin/ $(MAKE) -C $(GCC3_BUILD_DIR) install
	cp -d $(TOOLS)/$(STRICT_GNU_TARGET)/lib/libgcc_s.so* $(SYSROOT)/lib
	cp -d $(TOOLS)/$(STRICT_GNU_TARGET)/lib/libstdc++.so* $(SYSROOT)/lib
	@touch $@

$(GCC3_BUILD_DIR)/.configured:
	$(call CONFIGURE_MESSAGE,gcc-$(GCC_VERSION))
	@mkdir -p $(GCC3_BUILD_DIR)
	cd $(GCC3_BUILD_DIR); CC=$(HOSTCC_CACHED) CXX=$(HOSTCXX_CACHED) \
	$(TOOLS_BUILD)/gcc-$(GCC_VERSION)/configure \
	--prefix=$(TOOLS) --with-sysroot=$(SYSROOT) --target=$(STRICT_GNU_TARGET) \
	--with-arch=$(GNU_TARGET_ARCH) --with-float=$(GCC_FLOAT_TYPE) \
	--host=$(HOST_ARCH) --build=$(HOST_BUILD) --enable-__cxa_atexit \
	--disable-libssp --disable-libgomp --disable-libmudflap \
	--enable-threads --enable-shared --enable-languages=c,c++ \
	--with-gmp=$(GMP_HOST_DIR) --with-mpfr=$(MPFR_HOST_DIR) \
	$(GCC_MULTILIB) $(GCC_WITH_ABI)
	@touch $@

