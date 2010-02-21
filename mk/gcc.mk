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
# \file         gcc.mk
# \brief	gcc.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         May 2009
################################################################################

GCC_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_GCC_VERSION_STRING)))
ifeq ($(CONFIG_EMBTK_GCC_HAVE_MIRROR),y)
GCC_SITE := $(subst ",,$(strip $(CONFIG_EMBTK_GCC_HAVE_MIRROR_SITE)))
else
GCC_SITE := ftp://ftp.gnu.org/gnu/gcc/gcc-$(GCC_VERSION)
endif
GCC_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/gcc/$(GCC_VERSION)
GCC_PACKAGE := gcc-$(GCC_VERSION).tar.bz2
GCC1_BUILD_DIR := $(TOOLS_BUILD)/gcc1
GCC2_BUILD_DIR := $(TOOLS_BUILD)/gcc2
GCC3_BUILD_DIR := $(TOOLS_BUILD)/gcc3

GCC_MULTILIB := --disable-multilib

GCC_LANGUAGES =c
ifeq ($(CONFIG_EMBTK_GCC_LANGUAGE_CPP),y)
GCC_LANGUAGES +=,c++
endif
ifeq ($(CONFIG_EMBTK_GCC_LANGUAGE_JAVA),y)
GCC_LANGUAGES +=,java
GCC3_CONFIGURE_EXTRA_OPTIONS += --enable-java-home
endif
ifeq ($(CONFIG_EMBTK_GCC_LANGUAGE_OBJECTIVEC),y)
GCC_LANGUAGES +=,objc
endif
ifeq ($(CONFIG_EMBTK_GCC_LANGUAGE_OBJECTIVECPP),y)
GCC_LANGUAGES +=,obj-c++
endif
ifeq ($(CONFIG_EMBTK_GCC_LANGUAGE_FORTRAN),y)
GCC_LANGUAGES +=,fortran
endif
ifeq ($(CONFIG_EMBTK_GCC_LANGUAGE_ADA),y)
GCC_LANGUAGES +=,ada
endif
GCC_LANGUAGES :=$(patsubst "",,$(GCC_LANGUAGES))

#Disable tls when creating uClibc toolchain
ifeq ($(CONFIG_EMBTK_CLIB_UCLIBC),y)
GCC3_CONFIGURE_EXTRA_OPTIONS += --disable-tls
endif

gcc1_install: $(GCC1_BUILD_DIR)/.built

gcc2_install: $(GCC2_BUILD_DIR)/.built

gcc3_install: $(GCC3_BUILD_DIR)/.installed

#GCC first stage
$(GCC1_BUILD_DIR)/.built: download_gcc $(GCC1_BUILD_DIR)/.decompressed \
	$(GCC1_BUILD_DIR)/.configured
	PATH=$(PATH):$(TOOLS)/bin/ $(MAKE) -C $(GCC1_BUILD_DIR) $(J)
	PATH=$(PATH):$(TOOLS)/bin/ $(MAKE) -C $(GCC1_BUILD_DIR) install
	@touch $@
download_gcc:
	@test -e $(DOWNLOAD_DIR)/$(GCC_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(GCC_PACKAGE) $(GCC_SITE)/$(GCC_PACKAGE)
ifeq ($(CONFIG_EMBTK_GCC_NEED_PATCH),y)
	@test -e $(DOWNLOAD_DIR)/gcc-$(GCC_VERSION).patch || \
	wget -O $(DOWNLOAD_DIR)/gcc-$(GCC_VERSION).patch \
	$(GCC_PATCH_SITE)/gcc-$(GCC_VERSION)-*.patch
endif

$(GCC1_BUILD_DIR)/.decompressed:
	$(call DECOMPRESS_MESSAGE,$(GCC_PACKAGE))
	@tar -C $(TOOLS_BUILD) -xjf $(DOWNLOAD_DIR)/$(GCC_PACKAGE)
ifeq ($(CONFIG_EMBTK_GCC_NEED_PATCH),y)
	cd $(TOOLS_BUILD)/gcc-$(GCC_VERSION); \
	patch -p1 < $(DOWNLOAD_DIR)/gcc-$(GCC_VERSION).patch
endif
	@mkdir -p $(GCC1_BUILD_DIR)
	@touch $@

$(GCC1_BUILD_DIR)/.configured:
	$(call CONFIGURE_MESSAGE,gcc-$(GCC_VERSION))
	cd $(GCC1_BUILD_DIR); CC=$(HOSTCC_CACHED) CXX=$(HOSTCXX_CACHED) \
	$(TOOLS_BUILD)/gcc-$(GCC_VERSION)/configure \
	--prefix=$(TOOLS) --with-sysroot=$(SYSROOT) \
	--target=$(STRICT_GNU_TARGET) $(GCC_WITH_ABI) $(GCC_WITH_ARCH) \
	$(GCC_WITH_CPU) $(GCC_WITH_FLOAT) $(GCC_MULTILIB) $(GCC_WITH_TUNE) \
	--host=$(HOST_ARCH) --build=$(HOST_BUILD) \
	--without-headers --with-newlib --disable-shared --disable-threads \
	--disable-libssp --disable-libgomp --disable-libmudflap --disable-nls \
	--enable-languages=c --enable-target-optspace \
	--with-gmp=$(GMP_HOST_DIR) --with-mpfr=$(MPFR_HOST_DIR) \
	--with-mpc=$(MPC_HOST_DIR) \
	--with-pkgversion=embtoolkit-$(EMBTK_VERSION)
	@touch $@

#GCC second stage
$(GCC2_BUILD_DIR)/.built: $(GCC2_BUILD_DIR)/.configured
	PATH=$(PATH):$(TOOLS)/bin/ $(MAKE) -C $(GCC2_BUILD_DIR) $(J)
	PATH=$(PATH):$(TOOLS)/bin/ $(MAKE) -C $(GCC2_BUILD_DIR) install
	@touch $@

$(GCC2_BUILD_DIR)/.configured:
	$(call CONFIGURE_MESSAGE,gcc-$(GCC_VERSION))
	@mkdir -p $(GCC2_BUILD_DIR)
	cd $(GCC2_BUILD_DIR); CC=$(HOSTCC_CACHED) CXX=$(HOSTCXX_CACHED) \
	$(TOOLS_BUILD)/gcc-$(GCC_VERSION)/configure \
	--prefix=$(TOOLS) --with-sysroot=$(SYSROOT) \
	--target=$(STRICT_GNU_TARGET) $(GCC_WITH_ABI) $(GCC_WITH_ARCH) \
	$(GCC_WITH_CPU) $(GCC_WITH_FLOAT) $(GCC_MULTILIB) $(GCC_WITH_TUNE) \
	--host=$(HOST_ARCH) --build=$(HOST_BUILD) \
	--disable-libssp --disable-libgomp --disable-libmudflap --disable-nls \
	--enable-languages=c --enable-target-optspace \
	--with-gmp=$(GMP_HOST_DIR) --with-mpfr=$(MPFR_HOST_DIR) \
	--with-mpc=$(MPC_HOST_DIR) \
	--with-pkgversion=embtoolkit-$(EMBTK_VERSION)
	@touch $@

#GCC last stage
$(GCC3_BUILD_DIR)/.installed: $(GCC3_BUILD_DIR)/.configured
	PATH=$(PATH):$(TOOLS)/bin/ $(MAKE) -C $(GCC3_BUILD_DIR) $(J)
	PATH=$(PATH):$(TOOLS)/bin/ $(MAKE) -C $(GCC3_BUILD_DIR) install
ifeq ($(CONFIG_EMBTK_32BITS_FS),y)
	-cp -d $(TOOLS)/$(STRICT_GNU_TARGET)/lib/*.so* $(SYSROOT)/lib/
else ifeq ($(CONFIG_EMBTK_64BITS_FS),y)
	cp -d $(TOOLS)/$(STRICT_GNU_TARGET)/lib64/*.so* $(SYSROOT)/lib/
else ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	cp -d $(TOOLS)/$(STRICT_GNU_TARGET)/lib32/*.so* $(SYSROOT)/lib32/
endif
ifeq ($(CONFIG_EMBTK_TARGET_ARCH_64BITS),y)
ifeq ($(CONFIG_EMBTK_CLIB_UCLIBC),y)
	$(Q)cd $(SYSROOT)/lib/; \
	ln -s ld-uClibc.so.0 ld64-uClibc.so.0
endif
endif
	@touch $@

$(GCC3_BUILD_DIR)/.configured:
	$(call CONFIGURE_MESSAGE,gcc-$(GCC_VERSION))
	@mkdir -p $(GCC3_BUILD_DIR)
	cd $(GCC3_BUILD_DIR); CC=$(HOSTCC_CACHED) CXX=$(HOSTCXX_CACHED) \
	$(TOOLS_BUILD)/gcc-$(GCC_VERSION)/configure \
	--prefix=$(TOOLS) --with-sysroot=$(SYSROOT) \
	--target=$(STRICT_GNU_TARGET) $(GCC_WITH_ABI) $(GCC_WITH_ARCH) \
	$(GCC_WITH_CPU) $(GCC_WITH_FLOAT) $(GCC_MULTILIB) $(GCC_WITH_TUNE) \
	--host=$(HOST_ARCH) --build=$(HOST_BUILD) --enable-__cxa_atexit \
	--disable-libssp --disable-libgomp --disable-libmudflap --disable-nls \
	--enable-threads --enable-shared --enable-target-optspace \
	--with-gmp=$(GMP_HOST_DIR) --with-mpfr=$(MPFR_HOST_DIR) \
	--with-mpc=$(MPC_HOST_DIR) \
	--enable-languages=`echo $(GCC_LANGUAGES) | sed 's/ //g'` \
	$(GCC3_CONFIGURE_EXTRA_OPTIONS) \
	--with-pkgversion=embtoolkit-$(EMBTK_VERSION)
	@touch $@

