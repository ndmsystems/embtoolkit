################################################################################
# Copyright(C) 2009-2014 Abdoulaye Walsimou GAYE <awg@embtoolkit.org>.
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
# \file         toolchain.mk
# \brief	toolchain.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

TARGETGCC		:= $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-gcc
TARGETGCXX		:= $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-g++
TARGETCLANG		:= $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-clang
TARGETCLANGXX		:= $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-clang++

#
# Default compilers to use for packages.
#
__TARGETCC-y					:= $(TARGETGCC)
__TARGETCXX-y					:= $(TARGETGCXX)

__TARGETCC-$(embtk_toolchain_use_llvm-y)	:= $(TARGETCLANG)
__TARGETCXX-$(embtk_toolchain_use_llvm-y)	:= $(TARGETCLANGXX)

#
# FIXME: remove this when clang++ will support exceptions in c++ for arm,
# as exceptions seem to work for mips.
#
ifeq ($(CONFIG_EMBTK_ARCH_MIPS),y)
__TARGETCXX-$(CONFIG_EMBTK_LLVM_ONLY_TOOLCHAIN)		:= $(TARGETCLANGXX)
__TARGETCXX-$(CONFIG_EMBTK_LLVM_DEFAULT_TOOLCHAIN)	:= $(TARGETCLANGXX)
else
__TARGETCXX-$(CONFIG_EMBTK_LLVM_ONLY_TOOLCHAIN)		:= $(TARGETGCXX)
__TARGETCXX-$(CONFIG_EMBTK_LLVM_DEFAULT_TOOLCHAIN)	:= $(TARGETGCXX)
endif

TARGETCC		:= $(__TARGETCC-y)
TARGETCXX		:= $(__TARGETCXX-y)

#
# Clang static analyzer tools
#
ifeq ($(CONFIG_EMBTK_GCC_ONLY_TOOLCHAIN),)
TARGETSCANBUILD		:= $(embtk_tools)/bin/clang-scan-build/scan-build
TARGETSCANBUILD		+= --use-analyzer=$(TARGETCLANG)
TARGETSCANBUILD		+= --use-cc=$(TARGETCC)
TARGETSCANBUILD		+= --use-c++=$(TARGETCXX)
TARGETSCANVIEW		:= $(embtk_tools)/bin/clang-scan-view/scan-view
endif

#
# Some binutils components.
#
TARGETAR		:= $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-ar
TARGETRANLIB		:= $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-ranlib
TARGETLD		:= $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-ld
TARGETNM		:= $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-nm
TARGETSTRIP		:= $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-strip
TARGETOBJDUMP		:= $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-objdump
TARGETOBJCOPY		:= $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-objcopy
TARGETREADELF		:= $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-readelf

#
# TARGET cflags
#
__kconfig-cflags	:= $(strip $(CONFIG_EMBTK_TARGET_COMPILER_CFLAGS))
__TARGET_CFLAGS		:= $(subst ",,$(__kconfig-cflags))
__TARGET_CFLAGS		+= $(if $(CONFIG_EMBTK_TARGET_NONE_OPTIMIZED),-O0)
__TARGET_CFLAGS		+= $(if $(CONFIG_EMBTK_TARGET_SIZE_OPTIMIZED),-Os)
__TARGET_CFLAGS		+= $(if $(CONFIG_EMBTK_TARGET_SPEED_OPTIMIZED),-O2)
__TARGET_CFLAGS		+= $(if $(CONFIG_EMBTK_TARGET_WITH_DEBUG_DATA),-g)

# cflags for clang
__clang_cflags		:= -Qunused-arguments -fcolor-diagnostics
__TARGET_CFLAGS		+= $(if $(CONFIG_EMBTK_LLVM_ONLY_TOOLCHAIN),$(__clang_cflags))
__TARGET_CFLAGS		+= $(if $(CONFIG_EMBTK_LLVM_DEFAULT_TOOLCHAIN),$(__clang_cflags))

TARGET_CFLAGS		:= $(strip $(__TARGET_CFLAGS))
TARGET_CXXFLAGS		:= $(filter-out $(__clang_cflags),$(TARGET_CFLAGS))
CROSS_COMPILE		:= $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-

export TARGETCC TARGETCXX TARGETAR TARGETRANLIB TARGETLD TARGETNM
export TARGETSTRIP TARGETOBJDUMP TARGETOBJCOPY TARGET_CFLAGS CROSS_COMPILE

ac_cv_func_malloc_0_nonnull=yes
export ac_cv_func_malloc_0_nonnull
ac_cv_func_realloc_0_nonnull=yes
export ac_cv_func_realloc_0_nonnull

PATH			:= $(embtk_htools)/usr/bin:$(embtk_htools)/usr/sbin:$(PATH)
export PATH

LIBDIR			:= $(if $(CONFIG_EMBTK_64BITS_FS_COMPAT32),lib32,lib)
export LIBDIR

# ccache
include mk/ccache.mk

# GMP
include mk/gmp.mk

# MPFR
include mk/mpfr.mk

# MPC
include mk/mpc.mk

# binutils
include mk/binutils.mk

# GCC
include mk/gcc.mk

# llvm/clang compiler infrastructure
include mk/llvm/clang.mk
include mk/llvm/llvm.mk
include mk/llvm/compiler-rt/compiler-rt.mk
include mk/libc++/libcxxrt/libcxxrt.mk
include mk/libc++/libc++/libcxx.mk

# linux kernel headers
include mk/linux.mk

# toolchain addon: strace
include mk/strace.mk
TOOLCHAIN_ADDONS-$(CONFIG_EMBTK_HAVE_STRACE) += strace_install

# toolchain addon: gdb
include packages/development/gdb/gdb.mk
TOOLCHAIN_ADDONS-$(CONFIG_EMBTK_HAVE_GDB) += gdb_install
TOOLCHAIN_ADDONS-$(CONFIG_EMBTK_HAVE_GDBSERVER) += gdbserver_install
TOOLCHAIN_ADDONS-$(CONFIG_EMBTK_HOST_HAVE_GDB) += gdb_host_install

# Autotools
include mk/libtool.mk
include mk/autoconf.mk
include mk/automake.mk
include mk/m4.mk
AUTOTOOLS_INSTALL	:= m4_install libtool_install autoconf_install
AUTOTOOLS_INSTALL	+= automake_install

# GNU sed
include mk/gsed.mk

# BSD make
include mk/bmake.mk

# GNU make
include mk/gmake.mk

# Toolchain internals
__xtools_compiler-$(CONFIG_EMBTK_LLVM_ONLY_TOOLCHAIN)		:= clangllvm-$(LLVM_VERSION)
__xtools_compiler-$(CONFIG_EMBTK_LLVM_DEFAULT_TOOLCHAIN)	:= clangllvm-$(LLVM_VERSION)
__xtools_compiler-$(CONFIG_EMBTK_GCC_ONLY_TOOLCHAIN)		:= gcc-$(GCC_VERSION)
__xtools_compiler-$(CONFIG_EMBTK_GCC_DEFAULT_TOOLCHAIN)		:= gcc-$(GCC_VERSION)
__xtools_bins		:= $(__xtools_compiler-y)-$(embtk_clib)-$(embtk_clib_version)

TOOLCHAIN_PACKAGE	:= toolchain-$(HOST_ARCH)-target-$(__xtools_archos)-$(__xtools_bins)-$(__xtools_env).tar.bz2
TOOLCHAIN_DIR		:= $(embtk_generated)/toolchain-$(__xtools_archos)-$(__xtools_bins)-$(__xtools_env)
TOOLCHAIN_NAME		:= toolchain
TOOLCHAIN_BUILD_DIR	:= $(TOOLCHAIN_DIR)/.embtk-toolchain-toolchain
TOOLCHAIN_SRC_DIR	:= $(TOOLCHAIN_DIR)/.embtk-toolchain-toolchain

TOOLCHAIN_PRE_DEPS-y	:= ccache_install $(AUTOTOOLS_INSTALL)
ifeq ($(embtk_buildhost_os_type),bsd)
TOOLCHAIN_PRE_DEPS-y	+= gsed_install gmake_install
endif
TOOLCHAIN_PRE_DEPS-$(CONFIG_EMBTK_TOOLCHAIN_PREDEP_GPERF_HOST) += gperf_host_install

__gcc3_toolchain-$(CONFIG_EMBTK_GCC_ONLY_TOOLCHAIN)		:= gcc3_install
__gcc3_toolchain-$(CONFIG_EMBTK_GCC_DEFAULT_TOOLCHAIN)		:= gcc3_install
# FIXME: When libc++ will be used with clang/llvm toolchain, remove this
__gcc3_toolchain-$(CONFIG_EMBTK_GCC_LANGUAGE_CPP)		:= gcc3_install

__gcc3_toolchain-$(CONFIG_EMBTK_GCC_LANGUAGE_OBJECTIVEC) 	:= gcc3_install
__gcc3_toolchain-$(CONFIG_EMBTK_GCC_LANGUAGE_OBJECTIVECPP)	:= gcc3_install

#
# Handle clang/llvm/uClibc based toolchain where linuxthread.old is used or non
# threading is used at all.
# FIXME: print a warning

ifeq ($(CONFIG_EMBTK_HAVE_COMPILER-RT)$(CONFIG_KEMBTK_UCLIBC_LINUXTHREADS_OLD),yy)
else ifeq ($(CONFIG_EMBTK_HAVE_COMPILER-RT)$(CONFIG_KEMBTK_UCLIBC_LINUXTHREADS_OLD),yy)
else
__llvm_compiler-rt-$(CONFIG_EMBTK_HAVE_COMPILER-RT) := compiler-rt_install
endif

TOOLCHAIN_DEPS-y	:= linux_headers_install gmp_host_install
TOOLCHAIN_DEPS-y	+= mpfr_host_install mpc_host_install binutils_install
TOOLCHAIN_DEPS-$(CONFIG_EMBTK_HAVE_LLVM) += llvm_install
TOOLCHAIN_DEPS-y	+= gcc1_install
TOOLCHAIN_DEPS-$(CONFIG_EMBTK_CLIB_UCLIBC) += $(embtk_clib)_headers_install gcc2_install
TOOLCHAIN_DEPS-y	+= $(embtk_clib)_install
TOOLCHAIN_DEPS-y	+= $(__gcc3_toolchain-y) $(__llvm_compiler-rt-y)

TOOLCHAIN_DEPS			:= $(TOOLCHAIN_DEPS-y)
TOOLCHAIN_ADDONS_NAME		:= toolchain_addons
TOOLCHAIN_ADDONS_DEPS		:= $(TOOLCHAIN_ADDONS-y)
TOOLCHAIN_ADDONS_BUILD_DIR	:= $(TOOLCHAIN_DIR)/.embtk-toolchain_addons-toolchain_addons
TOOLCHAIN_ADDONS_SRC_DIR	:= $(TOOLCHAIN_DIR)/.embtk-toolchain_addons-toolchain_addons

-include mk/$(embtk_clib).mk

define __embtk_toolchain_mkinitdirs
	mkdir -p $(embtk_generated)
	mkdir -p $(TOOLCHAIN_DIR)
	mkdir -p $(TOOLCHAIN_ADDONS_BUILD_DIR)
	$(__embtk_mk_initsysrootdirs)
	$(__embtk_mk_inittoolsdirs)
	$(__embtk_mk_inithosttoolsdirs)
	$(__embtk_mk_initpkgdirs)
endef

define __embtk_toolchain_symlinktools
	cd $(embtk_tools)/bin;							\
	tools=$$(ls $(STRICT_GNU_TARGET)-*);					\
	toolsnames=$$(echo $$tools | sed 's/$(STRICT_GNU_TARGET)-*//g');	\
	for tool in $$toolsnames; do						\
		ln -sf $(STRICT_GNU_TARGET)-$$tool $(GNU_TARGET)-$$tool;	\
	done
endef

define __embtk_toolchain_compress
	tar -cjf $(TOOLCHAIN_PACKAGE)						\
		$(notdir $(embtk_sysroot)) $(notdir $(embtk_tools)) &&		\
	mv $(TOOLCHAIN_PACKAGE) $(TOOLCHAIN_DIR)/$(TOOLCHAIN_PACKAGE)
endef

define ___embtk_toolchain_decompress
	rm -rf $(embtk_sysroot) $(embtk_tools)
	cd $(EMBTK_ROOT) && tar xjf $(TOOLCHAIN_DIR)/$(TOOLCHAIN_PACKAGE)
	$(__embtk_toolchain_mkinitdirs)
	$(MAKE) $(TOOLCHAIN_PRE_DEPS-y)
endef

define __embtk_toolchain_decompress
	$(if $(call __embtk_pkg_notdecompressed-y,toolchain),
		$(call embtk_pinfo,"Decompressing cached $(GNU_TARGET)/$(EMBTK_MCU_FLAG) toolchain - please wait...")
		$(___embtk_toolchain_decompress)
		$(call __embtk_setdecompressed_pkg,toolchain))
endef

__embtk_toolchain_deps-y	= $(patsubst %_install,%,$(TOOLCHAIN_DEPS))
__embtk_toolchain_predeps-y	= $(patsubst %_install,%,$(TOOLCHAIN_PRE_DEPS-y))
__embtk_toolchain_addons-y	= $(patsubst %_install,%,$(TOOLCHAIN_ADDONS-y))
__embtk_toolchain_addons-n	= $(patsubst %_install,%,$(TOOLCHAIN_ADDONS-))
__embtk_toolchain_built_msg	= $(call embtk_pinfo,"New $(GNU_TARGET)/$(EMBTK_MCU_FLAG) toolchain successfully built!")
__embtk_toolchain_building_msg	= $(call embtk_pinfo,"Building new $(GNU_TARGET)/$(EMBTK_MCU_FLAG) CORE toolchain - please wait...")
__embtk_toolsaddons_build_msg	= $(call embtk_pinfo,"Building new $(GNU_TARGET)/$(EMBTK_MCU_FLAG) toolchain ADDONS - please wait...")

define __embtk_toolchain_build_core
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

define __embtk_toolchain_build_addons
	$(__embtk_toolsaddons_build_msg)
	$(call __embtk_unsetinstalled_pkg,toolchain_addons)
	$(call __embtk_unsetdecompressed_pkg,toolchain_addons)
	$(__embtk_toolchain_mkinitdirs)
	$(if $(findstring core,$(1)),,
		$(foreach rootfspkg,$(__embtk_rootfs_pkgs-y),
				$(call embtk_cleanup_pkg,$(rootfspkg)))
		$(foreach rootfsnpkg,$(__embtk_rootfs_pkgs-n),
				$(call embtk_cleanup_pkg,$(rootfsnpkg)))
		$(___embtk_toolchain_decompress))
	$(if $(findstring core,$(1)),
		$(foreach addon,$(__embtk_toolchain_addons-y),
				$(call embtk_cleanup_pkg,$(addon))))
	$(if $(TOOLCHAIN_ADDONS-),
		$(foreach addon,$(__embtk_toolchain_addons-n),
				$(call embtk_cleanup_pkg,$(addon))))
	$(if $(TOOLCHAIN_ADDONS-y),
		$(foreach pdep,$(__embtk_toolchain_predeps-y),
				$(call embtk_install_xpkg,$(pdep)))
		$(foreach addon,$(__embtk_toolchain_addons-y),
				$(call embtk_install_xpkg,$(addon))))
	$(call __embtk_setinstalled_pkg,toolchain_addons)
	$(if $(TOOLCHAIN_ADDONS-y),
		$(call __embtk_pkg_gen_dotkconfig_f,toolchain_addons),
		$(call __embtk_pkg_setkconfigured,toolchain_addons))
endef

define __embtk_toolchain_build
	$(if $(findstring core,$(1)),$(__embtk_toolchain_build_core))
	$(if $(findstring addons,$(1)),$(__embtk_toolchain_build_addons))
	$(if $(findstring core,$(1))$(findstring addons,$(1)),
		$(__embtk_toolchain_symlinktools)
		$(call embtk_pinfo,"Packaging new $(GNU_TARGET)/$(EMBTK_MCU_FLAG) toolchain - please wait...")
		$(__embtk_toolchain_compress)
		$(call __embtk_setdecompressed_pkg,toolchain)
		$(call __embtk_setdecompressed_pkg,toolchain_addons)
		$(__embtk_toolchain_built_msg),
		$(__embtk_toolchain_decompress))
endef

define __embtk_toolchain_runrecipe-y
	 $(or $(call __embtk_pkg_runrecipe-y,toolchain),$(if $(wildcard $(TOOLCHAIN_DIR)/$(TOOLCHAIN_PACKAGE)),,y))
endef

define __embtk_toolchain_addons_runrecipe-y
	$(or $(call __embtk_pkg_runrecipe-y,toolchain_addons),$(if $(wildcard $(TOOLCHAIN_DIR)/$(TOOLCHAIN_PACKAGE)),,y))
endef

__embtk_toolchain_buildargs := $(if $(strip $(__embtk_toolchain_runrecipe-y)),core-addons)
__embtk_toolchain_buildargs  +=$(if $(strip $(__embtk_toolchain_addons_runrecipe-y)),addons)

toolchain_install:
	$(Q)$(call __embtk_toolchain_build,$(__embtk_toolchain_buildargs))

define __embtk_toolchain_clean
	$(call __embtk_unsetdecompressed_pkg,toolchain)
endef

toolchain_clean:
	$(Q)$(__embtk_toolchain_clean)

pembtk_toolchain_mkinitdirs:
	$(call __embtk_toolchain_mkinitdirs)

pembtk_toolchain_predeps_install:
	$(call __embtk_toolchain_mkinitdirs)
	$(MAKE) $(TOOLCHAIN_PRE_DEPS-y)

# Download target for offline build
TOOLCHAIN_ALL_DEPS := $(TOOLCHAIN_PRE_DEPS-y) $(TOOLCHAIN_DEPS)
TOOLCHAIN_ALL_DEPS += $(TOOLCHAIN_ADDONS_DEPS)

packages_fetch:: $(patsubst %_install,download_%,$(TOOLCHAIN_ALL_DEPS))