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

__embtk_toolchain_version_prefix := $(if $(EMBTK_VERSION_GIT_HUMAN),$(EMBTK_VERSION_GIT_HUMAN)-)

TOOLCHAIN_NAME		:= toolchain
TOOLCHAIN_VERSION	:= $(__embtk_toolchain_version_prefix)$(__xtools_archos)-$(embtk_os_version)-$(__xtools_bins)-$(EMBTK_DATE)
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

#
# Generating toolchain information file
#

__embtk_toolchain_info_file := $(embtk_generated)/info.txt

define __embtk_toolchain_info_file_gen
	$(if $(EMBTK_VERSION_GIT_HUMAN),
		printf "Tag:\t\t%s\n\n" "$(EMBTK_VERSION_GIT_HUMAN)" > "$(1)",
		echo -n > "$(1)")
	printf "Host:\t\t%s\n" "$(HOST_ARCH)" >> "$(1)"
	printf "Target:\t\t%s (%s)\n\n" "$(__xtools_archos)" "$(__xtools_env)" >> "$(1)"
	printf "Binutils:\t%s\n" "$(embtk_binutils_version)" >> "$(1)"
	printf "C library:\t%s (%s)\n" "$(embtk_clib)" "$(embtk_clib_version)" >> "$(1)"
	printf "Compiler:\t%s (%s)\n" $$(echo "$(__xtools_compiler-y)" | cut -d '-' -f 1) \
		$$(echo "$(__xtools_compiler-y)" | cut -d '-' -f 2-) >> "$(1)"
	printf "Linux:\t\t%s\n" "$(embtk_os_version)" >> "$(1)"
endef

#
# Toolchain core build recipe
#
__embtk_toolchain_deps-y	= $(patsubst %_install,%,$(EMBTK_TOOLCHAIN_DEPS-y))
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
	$(foreach dep,$(__embtk_toolchain_deps-y),
				$(call embtk_install_xpkg,$(dep)))
	$(call __embtk_setinstalled_pkg,toolchain)
	$(call __embtk_pkg_gen_dotkconfig_f,toolchain)
	$(call __embtk_toolchain_info_file_gen,$(__embtk_toolchain_info_file))
endef


#
# Toolchain core dependencies
#
embtk_pkgincdir := packages/htools

# gmp
$(call embtk_include_xtoolpkg,gmp_host,toolchain_deps)

# mpfr
$(call embtk_include_xtoolpkg,mpfr_host,toolchain_deps)

# mpc
$(call embtk_include_xtoolpkg,mpc_host,toolchain_deps)

# gperf
$(call embtk_include_xtoolpkg,gperf_host,toolchain_deps)

EMBTK_TOOLCHAIN_DEPS-y	+= linux_headers_install binutils_install
EMBTK_TOOLCHAIN_DEPS-$(CONFIG_EMBTK_HOST_HAVE_LLVM) += llvm_host_install
EMBTK_TOOLCHAIN_DEPS-y	+= gcc1_install
EMBTK_TOOLCHAIN_DEPS-$(CONFIG_EMBTK_CLIB_UCLIBC) += $(embtk_clib)_headers_install gcc2_install
EMBTK_TOOLCHAIN_DEPS-y	+= $(embtk_clib)_install
EMBTK_TOOLCHAIN_DEPS-y	+= $(__embtk_xtool_gcc3-y)
EMBTK_TOOLCHAIN_DEPS-y	+= $(__embtk_xtool_compiler-rt-y)
TOOLCHAIN_DEPS		:= $(EMBTK_TOOLCHAIN_DEPS-y)


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
# linux kernel
#
include core/toolchain/linux/common.mk
include core/toolchain/linux/headers.mk
ifeq ($(CONFIG_EMBTK_BUILD_LINUX_KERNEL),y)
include core/toolchain/linux/linux.mk
endif

#
# C library
#
-include core/mk/$(embtk_clib).mk
