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

GCC_CXA_ATEXIT-$(CONFIG_EMBTK_GCC_LANGUAGE_CPP) := --enable-__cxa_atexit
GCC_CXA_ATEXIT-$(CONFIG_EMBTK_GCC_LANGUAGE_OBJECTIVECPP) := --enable-__cxa_atexit

#
# Final GCC extra configure options
#
__gcc3_extra_opts-y :=
__gcc3_extra_opts-$(CONFIG_EMBTK_GCC_LANGUAGE_JAVA) += --enable-java-home
__gcc3_extra_opts-$(CONFIG_KEMBTK_UCLIBC_LINUXTHREADS_OLD) += --disable-tls
GCC3_CONFIGURE_EXTRA_OPTIONS += $(__gcc3_extra_opts-y)

define embtk_beforeinstall_gcc1
	fixincludes_mk=$(call __embtk_pkg_srcdir,gcc)/gcc/Makefile.in;		\
	cp $$fixincludes_mk $$fixincludes_mk.old;				\
	sed -e 's@\./fixinc\.sh@-c true@'					\
		< $$fixincludes_mk > $$fixincludes_mk.tmp;			\
	mv $$fixincludes_mk.tmp $$fixincludes_mk
endef

define embtk_install_gcc1
	$(call __embtk_install_hostpkg,gcc1)
endef

define embtk_install_gcc2
	$(call __embtk_install_hostpkg,gcc2)
endef

define embtk_install_gcc3
	$(call __embtk_install_hostpkg,gcc3)
endef

define __embtk_postinstall_libgcc
	$(if $(CONFIG_EMBTK_32BITS_FS),							\
		(cd $(embtk_tools)/$(STRICT_GNU_TARGET)/lib/ && tar -cf - *.so*)	\
			| tar -xf - -C $(embtk_sysroot)/lib/ &&				\
		cp $(embtk_tools)/$(STRICT_GNU_TARGET)/lib/*.a				\
			$(embtk_sysroot)/usr/lib/ 2>/dev/null || true)			\
	$(if $(CONFIG_EMBTK_64BITS_FS),							\
		(cd $(embtk_tools)/$(STRICT_GNU_TARGET)/lib64/ && tar -cf - *.so*)	\
			| tar -xf - -C $(embtk_sysroot)/lib/ &&				\
		cp $(embtk_tools)/$(STRICT_GNU_TARGET)/lib64/*.a			\
			$(embtk_sysroot)/usr/lib/  2>/dev/null || true)			\
	$(if $(CONFIG_EMBTK_64BITS_FS_COMPAT32),					\
		(cd $(embtk_tools)/$(STRICT_GNU_TARGET)/lib32/ && tar -cf - *.so*)	\
			| tar -xf - -C $(embtk_sysroot)/lib32/ &&			\
		cp $(embtk_tools)/$(STRICT_GNU_TARGET)/lib32/*.a			\
			$(embtk_sysroot)/usr/lib32/  2>/dev/null || true)
endef

define __embtk_postinstall_gcc2_gcc3
	$(__embtk_postinstall_libgcc) &&					\
	$(if $(CONFIG_EMBTK_64BITS_FS),						\
		$(if $(CONFIG_EMBTK_CLIB_UCLIBC),				\
			cd $(embtk_sysroot)/lib/;				\
				ln -sf ld-uClibc.so.0 ld64-uClibc.so.0), true)
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
	--enable-languages=c --enable-target-optspace --disable-libquadmath	\
	--disable-libatomic

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
	--disable-libquadmath							\
	--disable-libssp --disable-libgomp --disable-libmudflap --disable-nls	\
	--enable-languages=c --enable-target-optspace --enable-threads		\
	--disable-libatomic $(GCC_CXA_ATEXIT-y)

CONFIG_EMBTK_GCC2_VERSION_GIT	:= $(CONFIG_EMBTK_GCC_VERSION_GIT)
CONFIG_EMBTK_GCC2_REFSPEC	:= $(CONFIG_EMBTK_GCC_REFSPEC)

define embtk_postinstall_gcc2
	$(if $(CONFIG_EMBTK_LLVM_ONLY_TOOLCHAIN),				\
		[ -e $(GCC2_BUILD_DIR)/.gcc.embtk.postinstall ] ||		\
			$(__embtk_postinstall_gcc2_gcc3) && 			\
			touch $(GCC2_BUILD_DIR)/.gcc.embtk.postinstall,		\
		true)
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
	--enable-languages=$(GCC_LANGUAGES) $(GCC_CXA_ATEXIT-y)			\
	--enable-threads --enable-shared --enable-target-optspace		\
	$(GCC3_CONFIGURE_EXTRA_OPTIONS)

CONFIG_EMBTK_GCC3_VERSION_GIT	:= $(CONFIG_EMBTK_GCC_VERSION_GIT)
CONFIG_EMBTK_GCC3_REFSPEC	:= $(CONFIG_EMBTK_GCC_REFSPEC)

define embtk_postinstall_gcc3
	[ -e $(GCC3_BUILD_DIR)/.gcc3_post_install ] ||				\
		$(__embtk_postinstall_gcc2_gcc3) &&				\
		touch $(GCC3_BUILD_DIR)/.gcc3_post_install
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
