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
# \file         common.mk
# \brief	common.mk for gcc common macros and variables
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         Septembber 2014
################################################################################

GCC_NAME	:= gcc
GCC_VERSION	:= $(call embtk_get_pkgversion,gcc)
GCC_SITE	:= http://ftp.gnu.org/gnu/gcc/gcc-$(GCC_VERSION)
GCC_GIT_SITE	:= git://gcc.gnu.org/git/gcc.git
GCC_PACKAGE	:= gcc-$(GCC_VERSION).tar.bz2
GCC_SRC_DIR	:= $(embtk_toolsb)/gcc-$(GCC_VERSION)

GCC_MULTILIB	:= --disable-multilib
GCC_DEPS	:= gmp_host_install mpfr_host_install mpc_host_install

pembtk_gcc_common_opts := --with-sysroot=$(embtk_sysroot)
pembtk_gcc_common_opts += --target=$(STRICT_GNU_TARGET)
pembtk_gcc_common_opts += $(GCC_WITH_ARCH)
pembtk_gcc_common_opts += $(GCC_WITH_CPU)
pembtk_gcc_common_opts += $(GCC_WITH_TUNE)
pembtk_gcc_common_opts += $(GCC_WITH_ABI)
pembtk_gcc_common_opts += $(GCC_WITH_FLOAT)
pembtk_gcc_common_opts += $(GCC_WITH_FPU)
pembtk_gcc_common_opts += $(GCC_MULTILIB)
pembtk_gcc_common_opts += --with-gmp=$(embtk_htools)/usr
pembtk_gcc_common_opts += --with-mpfr=$(embtk_htools)/usr
pembtk_gcc_common_opts += --with-mpc=$(embtk_htools)/usr
pembtk_gcc_common_opts += --enable-target-optspace
pembtk_gcc_common_opts += --disable-libssp
pembtk_gcc_common_opts += --disable-libgomp
pembtk_gcc_common_opts += --disable-libmudflap
pembtk_gcc_common_opts += --disable-nls
pembtk_gcc_common_opts += --disable-libquadmath
pembtk_gcc_common_opts += --with-bugurl=$(EMBTK_BUGURL)
pembtk_gcc_common_opts += --with-pkgversion=embtoolkit-$(EMBTK_VERSION)

GCC_CXA_ATEXIT-$(CONFIG_EMBTK_GCC_LANGUAGE_CPP) := --enable-__cxa_atexit
GCC_CXA_ATEXIT-$(CONFIG_EMBTK_GCC_LANGUAGE_OBJECTIVECPP) := --enable-__cxa_atexit

define pembtk_postinstall_libgcc
	$(if $(CONFIG_EMBTK_32BITS_FS),							\
		(cd $(embtk_tools)/$(STRICT_GNU_TARGET)/lib/ && tar -cf - *.so*)	\
			| tar -xf - -C $(embtk_sysroot)/lib/ &&				\
		cp $(embtk_tools)/$(STRICT_GNU_TARGET)/lib/*.a				\
			$(embtk_sysroot)/usr/lib/ 2>/dev/null || true)			\
	$(if $(CONFIG_EMBTK_64BITS_FS),							\
		(cd $(embtk_tools)/$(STRICT_GNU_TARGET)/lib64/ && tar -cf - *.so*)	\
			| tar -xf - -C $(embtk_sysroot)/lib/ &&				\
		cp $(embtk_tools)/$(STRICT_GNU_TARGET)/lib64/*.a			\
			$(embtk_sysroot)/usr/lib/ 2>/dev/null || true)			\
	$(if $(CONFIG_EMBTK_64BITS_FS_COMPAT32),					\
		(cd $(embtk_tools)/$(STRICT_GNU_TARGET)/lib32/ && tar -cf - *.so*)	\
			| tar -xf - -C $(embtk_sysroot)/lib32/ &&			\
		cp $(embtk_tools)/$(STRICT_GNU_TARGET)/lib32/*.a			\
			$(embtk_sysroot)/usr/lib32/ 2>/dev/null || true)
endef

define pembtk_postinstall_gcc2_gcc3
	$(pembtk_postinstall_libgcc)						\
	$(if $(CONFIG_EMBTK_64BITS_FS),						\
		$(if $(CONFIG_EMBTK_CLIB_UCLIBC),				\
			&& cd $(embtk_sysroot)/lib/;				\
				ln -sf ld-uClibc.so.0 ld64-uClibc.so.0))
endef
