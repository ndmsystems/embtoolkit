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
# \file         gcc.mk
# \brief	gcc.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

GCC_NAME	:= gcc
GCC_VERSION	:= $(call embtk_get_pkgversion,gcc)
GCC_SITE	:= $(strip $(if $(CONFIG_EMBTK_GCC_HAVE_MIRROR),		\
		$(subst ",,$(strip $(CONFIG_EMBTK_GCC_HAVE_MIRROR_SITE))),	\
		http://ftp.gnu.org/gnu/gcc/gcc-$(GCC_VERSION)))
GCC_PACKAGE	:= gcc-$(GCC_VERSION).tar.bz2
GCC_SRC_DIR	:= $(TOOLS_BUILD)/gcc-$(GCC_VERSION)

GCC_MULTILIB	:= --disable-multilib

#
# Selected languages to support in the toolchain
#
__GCC_LANGUAGES	:= c
__GCC_LANGUAGES	+= $(if $(CONFIG_EMBTK_GCC_LANGUAGE_CPP),c++)
__GCC_LANGUAGES	+= $(if $(CONFIG_EMBTK_GCC_LANGUAGE_JAVA),java)
__GCC_LANGUAGES	+= $(if $(CONFIG_EMBTK_GCC_LANGUAGE_OBJECTIVEC),objc)
__GCC_LANGUAGES	+= $(if $(CONFIG_EMBTK_GCC_LANGUAGE_OBJECTIVECPP),obj-c++)
__GCC_LANGUAGES	+= $(if $(CONFIG_EMBTK_GCC_LANGUAGE_FORTRAN),fortran)
__GCC_LANGUAGES	+= $(if $(CONFIG_EMBTK_GCC_LANGUAGE_ADA),ada)
GCC_LANGUAGES	:= $(shell echo $(__GCC_LANGUAGES) | sed 's/ /,/g')


#
# Final GCC extra configure options
#
GCC3_CONFIGURE_EXTRA_OPTIONS += $(if $(CONFIG_EMBTK_GCC_LANGUAGE_JAVA),		\
						--enable-java-home)
# Disable tls when creating uClibc toolchain with linuxthreads
ifeq ($(CONFIG_EMBTK_CLIB_UCLIBC),y)
GCC3_CONFIGURE_EXTRA_OPTIONS += \
	$(if $(CONFIG_KEMBTK_UCLIBC_UCLIBC_HAS_THREADS_NATIVE),,--disable-tls)
endif

gcc%_install:
	$(call embtk_install_hostpkg,$(patsubst %_install,%,$@))

#
# GCC first stage
#
GCC1_NAME		:= $(GCC_NAME)
GCC1_VERSION		:= $(GCC_VERSION)
GCC1_SITE		:= $(GCC_SITE)
GCC1_PACKAGE		:= $(GCC_PACKAGE)
GCC1_SRC_DIR		:= $(GCC_SRC_DIR)
GCC1_BUILD_DIR		:= $(TOOLS_BUILD)/gcc1-build
GCC1_KCONFIGS_NAME	:= GCC

GCC1_MAKE_ENV		:= PATH=$(PATH):$(TOOLS)/bin
GCC1_PREFIX		:= $(TOOLS)
GCC1_CONFIGURE_OPTS	:= --with-sysroot=$(SYSROOT)				\
	--target=$(STRICT_GNU_TARGET) $(GCC_WITH_ABI) $(GCC_WITH_ARCH)		\
	$(GCC_WITH_CPU) $(GCC_WITH_FLOAT) $(GCC_MULTILIB) $(GCC_WITH_TUNE)	\
	--with-gmp=$(GMP_HOST_DIR) --with-mpfr=$(MPFR_HOST_DIR)			\
	--with-mpc=$(MPC_HOST_DIR) --with-bugurl=$(EMBTK_BUGURL)		\
	--with-pkgversion=embtoolkit-$(EMBTK_VERSION)				\
	--without-headers --with-newlib --disable-shared --disable-threads	\
	--disable-libssp --disable-libgomp --disable-libmudflap --disable-nls	\
	--enable-languages=c --enable-target-optspace --disable-libquadmath

#
# GCC second stage
#
GCC2_NAME		:= $(GCC_NAME)
GCC2_VERSION		:= $(GCC_VERSION)
GCC2_SITE		:= $(GCC_SITE)
GCC2_PACKAGE		:= $(GCC_PACKAGE)
GCC2_SRC_DIR		:= $(GCC_SRC_DIR)
GCC2_BUILD_DIR		:= $(TOOLS_BUILD)/gcc2-build
GCC2_KCONFIGS_NAME	:= GCC

GCC2_MAKE_ENV		:= PATH=$(PATH):$(TOOLS)/bin
GCC2_PREFIX		:= $(TOOLS)
GCC2_CONFIGURE_OPTS	:= --with-sysroot=$(SYSROOT)				\
	--target=$(STRICT_GNU_TARGET) $(GCC_WITH_ABI) $(GCC_WITH_ARCH)		\
	$(GCC_WITH_CPU) $(GCC_WITH_FLOAT) $(GCC_MULTILIB) $(GCC_WITH_TUNE)	\
	--with-gmp=$(GMP_HOST_DIR) --with-mpfr=$(MPFR_HOST_DIR)			\
	--with-mpc=$(MPC_HOST_DIR) --with-bugurl=$(EMBTK_BUGURL)		\
	--with-pkgversion=embtoolkit-$(EMBTK_VERSION)				\
	--disable-libssp --disable-libgomp --disable-libmudflap --disable-nls	\
	--enable-languages=c --enable-target-optspace --disable-libquadmath

#
# GCC last stage
#
GCC3_NAME		:= $(GCC_NAME)
GCC3_VERSION		:= $(GCC_VERSION)
GCC3_SITE		:= $(GCC_SITE)
GCC3_PACKAGE		:= $(GCC_PACKAGE)
GCC3_SRC_DIR		:= $(GCC_SRC_DIR)
GCC3_BUILD_DIR		:= $(TOOLS_BUILD)/gcc3-build
GCC3_KCONFIGS_NAME	:= GCC

GCC3_MAKE_ENV		:= PATH=$(PATH):$(TOOLS)/bin
GCC3_PREFIX		:= $(TOOLS)
GCC3_CONFIGURE_OPTS	:= --with-sysroot=$(SYSROOT)				\
	--target=$(STRICT_GNU_TARGET) $(GCC_WITH_ABI) $(GCC_WITH_ARCH)		\
	$(GCC_WITH_CPU) $(GCC_WITH_FLOAT) $(GCC_MULTILIB) $(GCC_WITH_TUNE)	\
	--with-gmp=$(GMP_HOST_DIR) --with-mpfr=$(MPFR_HOST_DIR)			\
	--with-mpc=$(MPC_HOST_DIR) --with-bugurl=$(EMBTK_BUGURL)		\
	--with-pkgversion=embtoolkit-$(EMBTK_VERSION)				\
	--enable-languages=$(GCC_LANGUAGES) --enable-__cxa_atexit		\
	--disable-libssp --disable-libgomp --disable-libmudflap --disable-nls	\
	--enable-threads --enable-shared --enable-target-optspace		\
	--disable-libquadmath $(GCC3_CONFIGURE_EXTRA_OPTIONS)

define embtk_postinstall_gcc3
	$(Q)test -e $(GCC3_BUILD_DIR)/.gcc3_post_install ||			\
	$(MAKE) $(GCC3_BUILD_DIR)/.gcc3_post_install
endef

$(GCC3_BUILD_DIR)/.gcc3_post_install:
ifeq ($(CONFIG_EMBTK_32BITS_FS),y)
	$(Q)-cp -d $(TOOLS)/$(STRICT_GNU_TARGET)/lib/*.so* $(SYSROOT)/lib/
else ifeq ($(CONFIG_EMBTK_64BITS_FS),y)
	$(Q)cp -d $(TOOLS)/$(STRICT_GNU_TARGET)/lib64/*.so* $(SYSROOT)/lib/
else ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)cp -d $(TOOLS)/$(STRICT_GNU_TARGET)/lib32/*.so* $(SYSROOT)/lib32/
endif
ifeq ($(CONFIG_EMBTK_64BITS_FS)$(CONFIG_EMBTK_CLIB_UCLIBC),yy)
	$(Q)cd $(SYSROOT)/lib/; ln -sf ld-uClibc.so.0 ld64-uClibc.so.0
endif
	$(Q)touch $@

