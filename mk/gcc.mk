################################################################################
# Embtoolkit
# Copyright(C) 2009-2012 Abdoulaye Walsimou GAYE.
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
GCC_SITE	:= http://ftp.gnu.org/gnu/gcc/gcc-$(GCC_VERSION)
GCC_GIT_SITE	:= git://gcc.gnu.org/git/gcc.git
GCC_PACKAGE	:= gcc-$(GCC_VERSION).tar.bz2
GCC_SRC_DIR	:= $(embtk_toolsb)/gcc-$(GCC_VERSION)

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
GCC_LANGUAGES	:= $(subst $(embtk_space),$(embtk_comma),$(strip $(__GCC_LANGUAGES)))


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

define embtk_install_gcc1
	$(call __embtk_install_hostpkg,gcc1)
endef

define embtk_install_gcc2
	$(call __embtk_install_hostpkg,gcc2)
endef

define embtk_install_gcc3
	$(call __embtk_install_hostpkg,gcc3)
endef

#
# GCC first stage
#
GCC1_NAME		:= $(GCC_NAME)
GCC1_VERSION		:= $(GCC_VERSION)
GCC1_SITE		:= $(GCC_SITE)
GCC1_GIT_SITE		:= $(GCC_GIT_SITE)
GCC1_PACKAGE		:= $(GCC_PACKAGE)
GCC1_SRC_DIR		:= $(GCC_SRC_DIR)
GCC1_BUILD_DIR		:= $(embtk_toolsb)/gcc1-build
GCC1_KCONFIGS_NAME	:= GCC

GCC1_MAKE_ENV		:= PATH=$(PATH):$(embtk_tools)/bin
GCC1_PREFIX		:= $(embtk_tools)
GCC1_CONFIGURE_OPTS	:= --with-sysroot=$(embtk_sysroot)			\
	--target=$(STRICT_GNU_TARGET) $(GCC_WITH_ABI) $(GCC_WITH_ARCH)		\
	$(GCC_WITH_CPU) $(GCC_WITH_FLOAT) $(GCC_WITH_FPU) $(GCC_WITH_TUNE)	\
	$(GCC_MULTILIB)								\
	--with-gmp=$(GMP_HOST_DIR) --with-mpfr=$(MPFR_HOST_DIR)			\
	--with-mpc=$(MPC_HOST_DIR) --with-bugurl=$(EMBTK_BUGURL)		\
	--with-pkgversion=embtoolkit-$(EMBTK_VERSION)				\
	--without-headers --with-newlib --disable-shared --disable-threads	\
	--disable-libssp --disable-libgomp --disable-libmudflap --disable-nls	\
	--enable-languages=c --enable-target-optspace --disable-libquadmath

CONFIG_EMBTK_GCC1_VERSION_GIT	:= $(CONFIG_EMBTK_GCC_VERSION_GIT)
CONFIG_EMBTK_GCC1_REFSPEC	:= $(CONFIG_EMBTK_GCC_REFSPEC)

#
# GCC second stage
#
GCC2_NAME		:= $(GCC_NAME)
GCC2_VERSION		:= $(GCC_VERSION)
GCC2_SITE		:= $(GCC_SITE)
GCC2_GIT_SITE		:= $(GCC_GIT_SITE)
GCC2_PACKAGE		:= $(GCC_PACKAGE)
GCC2_SRC_DIR		:= $(GCC_SRC_DIR)
GCC2_BUILD_DIR		:= $(embtk_toolsb)/gcc2-build
GCC2_KCONFIGS_NAME	:= GCC

GCC2_MAKE_ENV		:= PATH=$(PATH):$(embtk_tools)/bin
GCC2_PREFIX		:= $(embtk_tools)
GCC2_CONFIGURE_OPTS	:= --with-sysroot=$(embtk_sysroot)			\
	--target=$(STRICT_GNU_TARGET) $(GCC_WITH_ABI) $(GCC_WITH_ARCH)		\
	$(GCC_WITH_CPU) $(GCC_WITH_FLOAT) $(GCC_WITH_FPU) $(GCC_WITH_TUNE)	\
	$(GCC_MULTILIB)								\
	--with-gmp=$(GMP_HOST_DIR) --with-mpfr=$(MPFR_HOST_DIR)			\
	--with-mpc=$(MPC_HOST_DIR) --with-bugurl=$(EMBTK_BUGURL)		\
	--with-pkgversion=embtoolkit-$(EMBTK_VERSION)				\
	--disable-libssp --disable-libgomp --disable-libmudflap --disable-nls	\
	--enable-languages=c --enable-target-optspace --disable-libquadmath

CONFIG_EMBTK_GCC2_VERSION_GIT	:= $(CONFIG_EMBTK_GCC_VERSION_GIT)
CONFIG_EMBTK_GCC2_REFSPEC	:= $(CONFIG_EMBTK_GCC_REFSPEC)

define __embtk_postinstall_gcc2
	($(if $(CONFIG_EMBTK_32BITS_FS),					\
		cp -d $(embtk_tools)/$(STRICT_GNU_TARGET)/lib/*.so*		\
						$(embtk_sysroot)/lib/ &&)	\
	$(if $(CONFIG_EMBTK_64BITS_FS),						\
		cp -d $(embtk_tools)/$(STRICT_GNU_TARGET)/lib64/*.so*		\
						$(embtk_sysroot)/lib/ &&)	\
	$(if $(CONFIG_EMBTK_64BITS_FS_COMPAT32),				\
		cp -d $(embtk_tools)/$(STRICT_GNU_TARGET)/lib32/*.so*		\
						$(embtk_sysroot)/lib32/ &&)	\
	$(if $(CONFIG_EMBTK_64BITS_FS),						\
		$(if $(CONFIG_EMBTK_CLIB_UCLIBC),				\
			cd $(embtk_sysroot)/lib/;				\
				ln -sf ld-uClibc.so.0 ld64-uClibc.so.0 &&))	\
	touch $(GCC2_BUILD_DIR)/.gcc.embtk.postinstall)
endef
define embtk_postinstall_gcc2
	$(if $(CONFIG_EMBTK_LLVM_ONLY_TOOLCHAIN),
		[ -e $(GCC2_BUILD_DIR)/.gcc.embtk.postinstall ] ||		\
					$(__embtk_postinstall_gcc2),true)
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
GCC3_BUILD_DIR		:= $(embtk_toolsb)/gcc3-build
GCC3_KCONFIGS_NAME	:= GCC

GCC3_MAKE_ENV		:= PATH=$(PATH):$(embtk_tools)/bin
GCC3_PREFIX		:= $(embtk_tools)
GCC3_CONFIGURE_OPTS	:= --with-sysroot=$(embtk_sysroot)			\
	--target=$(STRICT_GNU_TARGET) $(GCC_WITH_ABI) $(GCC_WITH_ARCH)		\
	$(GCC_WITH_CPU) $(GCC_WITH_FLOAT) $(GCC_WITH_FPU) $(GCC_WITH_TUNE)	\
	$(GCC_MULTILIB)								\
	--with-gmp=$(GMP_HOST_DIR) --with-mpfr=$(MPFR_HOST_DIR)			\
	--with-mpc=$(MPC_HOST_DIR) --with-bugurl=$(EMBTK_BUGURL)		\
	--with-pkgversion=embtoolkit-$(EMBTK_VERSION)				\
	--disable-libssp --disable-libgomp --disable-libmudflap --disable-nls	\
	--disable-libquadmath							\
	--enable-languages=$(GCC_LANGUAGES) --enable-__cxa_atexit		\
	--enable-threads --enable-shared --enable-target-optspace		\
	$(GCC3_CONFIGURE_EXTRA_OPTIONS)

CONFIG_EMBTK_GCC3_VERSION_GIT	:= $(CONFIG_EMBTK_GCC_VERSION_GIT)
CONFIG_EMBTK_GCC3_REFSPEC	:= $(CONFIG_EMBTK_GCC_REFSPEC)

define __embtk_postinstall_gcc3
	($(if $(CONFIG_EMBTK_32BITS_FS),					\
		cp -d $(embtk_tools)/$(STRICT_GNU_TARGET)/lib/*.so*		\
						$(embtk_sysroot)/lib/ &&)	\
	$(if $(CONFIG_EMBTK_64BITS_FS),						\
		cp -d $(embtk_tools)/$(STRICT_GNU_TARGET)/lib64/*.so*		\
						$(embtk_sysroot)/lib/ &&)	\
	$(if $(CONFIG_EMBTK_64BITS_FS_COMPAT32),				\
		cp -d $(embtk_tools)/$(STRICT_GNU_TARGET)/lib32/*.so*		\
						$(embtk_sysroot)/lib32/ &&)	\
	$(if $(CONFIG_EMBTK_64BITS_FS),						\
		$(if $(CONFIG_EMBTK_CLIB_UCLIBC),				\
			cd $(embtk_sysroot)/lib/;				\
				ln -sf ld-uClibc.so.0 ld64-uClibc.so.0 &&))	\
	touch $(GCC3_BUILD_DIR)/.gcc3_post_install)
endef
define embtk_postinstall_gcc3
	[ -e $(GCC3_BUILD_DIR)/.gcc3_post_install ] ||				\
						$(__embtk_postinstall_gcc3)
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
