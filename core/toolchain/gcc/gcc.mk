################################################################################
# Embtoolkit
# Copyright(C) 2009-2014 Abdoulaye Walsimou GAYE.
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

include core/toolchain/gcc/common.mk

#
# GCC first stage
#
GCC1_NAME		:= $(GCC_NAME)
GCC1_VERSION		:= $(GCC_VERSION)
GCC1_SITE		:= $(GCC_SITE)
GCC1_GIT_SITE		:= $(GCC_GIT_SITE)
GCC1_PACKAGE		:= $(GCC_PACKAGE)
GCC1_SRC_DIR		:= $(GCC_SRC_DIR)
GCC1_BUILD_DIR		:= $(embtk_toolsb)/gcc1-$(GCC_VERSION)-build
GCC1_KEEP_SRC_DIR	:= y

GCC1_DEPS		:= $(GCC_DEPS)

GCC1_MAKE_ENV		:= PATH=$(PATH):$(embtk_tools)/bin
GCC1_PREFIX		:= $(embtk_tools)

GCC1_CONFIGURE_OPTS	:= $(pembtk_gcc_common_opts) --enable-languages=c
GCC1_CONFIGURE_OPTS	+= --without-headers
GCC1_CONFIGURE_OPTS	+= --with-newlib
GCC1_CONFIGURE_OPTS	+= --disable-shared
GCC1_CONFIGURE_OPTS	+= --disable-threads
GCC1_CONFIGURE_OPTS	+= --disable-libatomic

GCC1_CONFIGURE_ENV	:= $(GCC_CONFIGURE_ENV)

GCC1_CFLAGS		:= $(GCC_CFLAGS)
GCC1_CXXFLAGS		:= $(GCC_CXXFLAGS)

GCC1_MAKE_OPTS		:= $(GCC_MAKE_OPTS)

define embtk_install_gcc1
	$(call embtk_makeinstall_hostpkg,gcc1,autotooled)
endef

#
# GCC second stage
#
GCC2_NAME		:= $(GCC_NAME)
GCC2_VERSION		:= $(GCC_VERSION)
GCC2_SITE		:= $(GCC_SITE)
GCC2_GIT_SITE		:= $(GCC_GIT_SITE)
GCC2_PACKAGE		:= $(GCC_PACKAGE)
GCC2_SRC_DIR		:= $(GCC_SRC_DIR)
GCC2_BUILD_DIR		:= $(embtk_toolsb)/gcc2-$(GCC_VERSION)-build
GCC2_KEEP_SRC_DIR	:= y

GCC2_DEPS		:= $(GCC_DEPS)

GCC2_MAKE_ENV		:= PATH=$(PATH):$(embtk_tools)/bin
GCC2_PREFIX		:= $(embtk_tools)

GCC2_CONFIGURE_OPTS	:= $(pembtk_gcc_common_opts) --enable-languages=c
GCC2_CONFIGURE_OPTS	+= --enable-threads
GCC2_CONFIGURE_OPTS	+= --disable-libatomic
GCC2_CONFIGURE_OPTS	+= --disable-symvers
GCC2_CONFIGURE_OPTS	+= $(GCC_CXA_ATEXIT-y)

GCC2_CONFIGURE_ENV	:= $(GCC_CONFIGURE_ENV)

GCC2_CFLAGS		:= $(GCC_CFLAGS)
GCC2_CXXFLAGS		:= $(GCC_CXXFLAGS)

GCC2_MAKE_OPTS		:= $(GCC_MAKE_OPTS)

define embtk_install_gcc2
	$(call embtk_makeinstall_hostpkg,gcc2,autotooled)
endef

define embtk_postinstallonce_gcc2
	$(if $(CONFIG_EMBTK_LLVM_ONLY_TOOLCHAIN),				\
		$(pembtk_postinstall_gcc2_gcc3))
endef

#
# GCC last stage
#
GCC3_NAME		:= $(GCC_NAME)
GCC3_VERSION		:= $(GCC_VERSION)
GCC3_SITE		:= $(GCC_SITE)
GCC3_GIT_SITE		:= $(GCC_GIT_SITE)
GCC3_PACKAGE		:= $(GCC_PACKAGE)
GCC3_SRC_DIR		:= $(GCC_SRC_DIR)
GCC3_BUILD_DIR		:= $(embtk_toolsb)/gcc3-$(GCC_VERSION)-build
GCC3_KCONFIGS_NAME	:= GCC

# extra gcc3 configure options
pembtk_gcc3_extraopts-y := --disable-symvers
pembtk_gcc3_extraopts-$(CONFIG_EMBTK_GCC_LANGUAGE_JAVA)        += --enable-java-home
pembtk_gcc3_extraopts-$(CONFIG_KEMBTK_UCLIBC_LINUXTHREADS_OLD) += --disable-tls
pembtk_gcc3_extraopts-$(CONFIG_EMBTK_CLIB_UCLIBC)              += --disable-libsanitizer
# FIXME: remove this when c++ exceptions will be fixed (in musl,libgcc?)
ifeq ($(CONFIG_EMBTK_CLIB_MUSL)$(CONFIG_EMBTK_ARCH_MIPS),yy)
pembtk_gcc3_extraopts-y += --disable-tls
endif
pembtk_gcc3_extraopts-$(CONFIG_EMBTK_CLIB_MUSL) += --disable-libsanitizer

GCC3_CONFIGURE_EXTRA_OPTIONS += $(pembtk_gcc3_extraopts-y)

# Selected languages to support in the toolchain
pembtk_gcc_langopts-y	:= c
pembtk_gcc_langopts-$(CONFIG_EMBTK_GCC_LANGUAGE_CPP)          += c++
pembtk_gcc_langopts-$(CONFIG_EMBTK_GCC_LANGUAGE_JAVA)         += java
pembtk_gcc_langopts-$(CONFIG_EMBTK_GCC_LANGUAGE_OBJECTIVEC)   += objc
pembtk_gcc_langopts-$(CONFIG_EMBTK_GCC_LANGUAGE_OBJECTIVECPP) += obj-c++
pembtk_gcc_langopts-$(CONFIG_EMBTK_GCC_LANGUAGE_FORTRAN)      += fortran
pembtk_gcc_langopts-$(CONFIG_EMBTK_GCC_LANGUAGE_ADA)          += ada
pembtk_gcc_langopts	:= $(subst $(embtk_space),$(embtk_comma),$(pembtk_gcc_langopts-y))

GCC3_DEPS		:= $(GCC_DEPS)

GCC3_MAKE_ENV		:= PATH=$(PATH):$(embtk_tools)/bin
GCC3_PREFIX		:= $(embtk_tools)

GCC3_CONFIGURE_OPTS	:= $(pembtk_gcc_common_opts)
GCC3_CONFIGURE_OPTS	+= --enable-languages=$(pembtk_gcc_langopts)
GCC3_CONFIGURE_OPTS	+= --enable-threads
GCC3_CONFIGURE_OPTS	+= --enable-shared
GCC3_CONFIGURE_OPTS	+= $(GCC_CXA_ATEXIT-y)
GCC3_CONFIGURE_OPTS	+= $(GCC3_CONFIGURE_EXTRA_OPTIONS)

GCC3_CONFIGURE_ENV	:= $(GCC_CONFIGURE_ENV)

GCC3_CFLAGS		:= $(GCC_CFLAGS)
GCC3_CXXFLAGS		:= $(GCC_CXXFLAGS)

GCC3_MAKE_OPTS		:= $(GCC_MAKE_OPTS)

define embtk_install_gcc3
	$(call embtk_makeinstall_hostpkg,gcc3,autotooled)
endef

define embtk_postinstallonce_gcc3
	$(pembtk_postinstall_gcc2_gcc3)
	$(if $(CONFIG_EMBTK_WIPEOUTWORKSPACES),
		$(embtk_cleanup_gcc1)
		$(embtk_cleanup_gcc2)
		$(embtk_cleanup_gcc3))
endef

#
# clean up macros and targets
#
define embtk_cleanup_gcc1
	rm -rf $(GCC1_BUILD_DIR)
endef

define embtk_cleanup_gcc2
	rm -rf $(GCC2_BUILD_DIR)
endef

define embtk_cleanup_gcc3
	rm -rf $(GCC3_BUILD_DIR)
endef
