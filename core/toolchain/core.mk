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
# \file         core.mk
# \brief	Toolchain core part
# \author	Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date		September 2014
################################################################################

TOOLCHAIN_NAME		:= toolchain
TOOLCHAIN_VERSION	:= $(HOST_ARCH)-target-$(__xtools_archos)-$(__xtools_bins)-$(__xtools_env)
TOOLCHAIN_PACKAGE	:= toolchain-$(TOOLCHAIN_VERSION).tar.bz2
TOOLCHAIN_SRC_DIR	:= $(TOOLCHAIN_DIR)/.embtk-toolchain
TOOLCHAIN_BUILD_DIR	:= $(TOOLCHAIN_DIR)/.embtk-toolchain

# Include .kconfig symbols if any
-include $(call __embtk_pkg_dotkconfig_f,toolchain)

__embtk_xtool_gcc3-$(CONFIG_EMBTK_GCC_ONLY_TOOLCHAIN)        := gcc3_install
__embtk_xtool_gcc3-$(CONFIG_EMBTK_GCC_DEFAULT_TOOLCHAIN)     := gcc3_install

# FIXME: When libc++ will be used with clang/llvm toolchain, remove this
__embtk_xtool_gcc3-$(CONFIG_EMBTK_GCC_LANGUAGE_CPP)          := gcc3_install

__embtk_xtool_gcc3-$(CONFIG_EMBTK_GCC_LANGUAGE_OBJECTIVEC)   := gcc3_install
__embtk_xtool_gcc3-$(CONFIG_EMBTK_GCC_LANGUAGE_OBJECTIVECPP) := gcc3_install

#
# FIXME:
# 1- Handle clang/llvm/uClibc based toolchain where linuxthread.old is used or
# no threading is used at all.
# 2- Handle clang/llvm/musl MIPS based toolchain
#

ifeq ($(CONFIG_EMBTK_HAVE_COMPILER-RT)$(CONFIG_KEMBTK_UCLIBC_LINUXTHREADS_OLD),yy)
else ifeq ($(CONFIG_EMBTK_HAVE_COMPILER-RT)$(CONFIG_KEMBTK_UCLIBC_LINUXTHREADS_OLD),yy)
else ifeq ($(CONFIG_EMBTK_HAVE_COMPILER-RT)$(CONFIG_EMBTK_CLIB_MUSL)$(CONFIG_EMBTK_ARCH_MIPS),yyy)
else
__embtk_xtool_compiler-rt-$(CONFIG_EMBTK_HAVE_COMPILER-RT) := compiler-rt_install
endif

TOOLCHAIN_DEPS-y	:= linux_headers_install binutils_install
TOOLCHAIN_DEPS-$(CONFIG_EMBTK_HOST_HAVE_LLVM) += llvm_host_install
TOOLCHAIN_DEPS-y	+= gcc1_install
TOOLCHAIN_DEPS-$(CONFIG_EMBTK_CLIB_UCLIBC) += $(embtk_clib)_headers_install gcc2_install
TOOLCHAIN_DEPS-y	+= $(embtk_clib)_install
TOOLCHAIN_DEPS-y	+= $(__embtk_xtool_gcc3-y)
TOOLCHAIN_DEPS-y	+= $(__embtk_xtool_compiler-rt-y)
TOOLCHAIN_DEPS		:= $(TOOLCHAIN_DEPS-y)

#
# Toolchain core build recipe
#
__embtk_toolchain_deps-y	= $(patsubst %_install,%,$(TOOLCHAIN_DEPS))
__embtk_toolchain_predeps-y	= $(patsubst %_install,%,$(TOOLCHAIN_PREDEPS-y))
__embtk_toolchain_built_msg	= $(call embtk_pinfo,"New $(GNU_TARGET)/$(EMBTK_MCU_FLAG) toolchain successfully built!")
__embtk_toolchain_building_msg	= $(call embtk_pinfo,"Building new $(GNU_TARGET)/$(EMBTK_MCU_FLAG) CORE toolchain - please wait...")

define __embtk_toolchain_core_build
	$(__embtk_toolchain_building_msg)
	$(call __embtk_unsetinstalled_pkg,toolchain)
	$(call __embtk_unsetdecompressed_pkg,toolchain)
	$(foreach dep,$(__embtk_toolchain_deps-y),
				$(call embtk_cleanup_pkg,$(dep)))
	$(foreach pkg,$(__embtk_rootfs_pkgs-y),
				$(call embtk_cleanup_pkg,$(pkg)))
	$(foreach pkgn,$(__embtk_rootfs_pkgs-n),
				$(call embtk_cleanup_pkg,$(pkgn)))
	rm -rf $(embtk_sysroot) $(embtk_tools)
	$(__embtk_toolchain_mkinitdirs)
	$(foreach pdep,$(__embtk_toolchain_predeps-y),
				$(call embtk_install_xpkg,$(pdep)))
	$(foreach dep,$(__embtk_toolchain_deps-y),
				$(call embtk_install_xpkg,$(dep)))
	$(call __embtk_setinstalled_pkg,toolchain)
	$(call __embtk_pkg_gen_dotkconfig_f,toolchain)
endef

#
# binutils
#
include core/toolchain/binutils/binutils.mk

#
# GCC
#
include core/toolchain/gcc/gcc.mk

#
# llvm/clang compiler infrastructure
#
include core/toolchain/llvm/clang/clang.mk
include core/toolchain/llvm/llvm/llvm.mk
include core/toolchain/llvm/compiler-rt/compiler-rt.mk
include core/toolchain/libcxxrt/libcxxrt.mk
include core/toolchain/llvm/libc++/libcxx.mk

#
# linux kernel headers
#
include core/mk/linux.mk

#
# C library
#
-include core/mk/$(embtk_clib).mk
