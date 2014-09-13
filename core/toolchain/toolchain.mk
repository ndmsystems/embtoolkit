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

embtk_pkgincdir := toolchain

#
# Toolchain variables
#
include core/toolchain/vars.mk
include packages/htools/ccache/vars.mk
include packages/htools/m4/vars.mk
include packages/htools/libtool/vars.mk
include packages/htools/autoconf/vars.mk
include packages/htools/automake/vars.mk

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
# toolchain addon: strace
#
include core/mk/strace.mk
TOOLCHAIN_ADDONS-$(CONFIG_EMBTK_HAVE_STRACE) += strace_install

#
# toolchain addon: gdb
#
include packages/development/gdb/gdb.mk
TOOLCHAIN_ADDONS-$(CONFIG_EMBTK_HAVE_GDB)	+= gdb_install
TOOLCHAIN_ADDONS-$(CONFIG_EMBTK_HAVE_GDBSERVER)	+= gdbserver_install
TOOLCHAIN_ADDONS-$(CONFIG_EMBTK_HOST_HAVE_GDB)	+= gdb_host_install

#
# Autotools
#
AUTOTOOLS_INSTALL	:= m4_host_install libtool_host_install
AUTOTOOLS_INSTALL	+= autoconf_host_install automake_host_install

# BSD make
include core/mk/bmake.mk

#
# Toolchain virtual package internals
#
__xtools_compiler-$(CONFIG_EMBTK_LLVM_ONLY_TOOLCHAIN)		:= clangllvm-$(LLVM_HOST_VERSION)
__xtools_compiler-$(CONFIG_EMBTK_LLVM_DEFAULT_TOOLCHAIN)	:= clangllvm-$(LLVM_HOST_VERSION)
__xtools_compiler-$(CONFIG_EMBTK_GCC_ONLY_TOOLCHAIN)		:= gcc-$(GCC_VERSION)
__xtools_compiler-$(CONFIG_EMBTK_GCC_DEFAULT_TOOLCHAIN)		:= gcc-$(GCC_VERSION)
__xtools_bins		:= $(__xtools_compiler-y)-$(embtk_clib)-$(embtk_clib_version)

TOOLCHAIN_PACKAGE	:= toolchain-$(HOST_ARCH)-target-$(__xtools_archos)-$(__xtools_bins)-$(__xtools_env).tar.bz2
TOOLCHAIN_DIR		:= $(embtk_generated)/toolchains/toolchain-$(__xtools_archos)-$(__xtools_bins)-$(__xtools_env)
TOOLCHAIN_NAME		:= toolchain
TOOLCHAIN_BUILD_DIR	:= $(TOOLCHAIN_DIR)/.embtk-toolchain
TOOLCHAIN_SRC_DIR	:= $(TOOLCHAIN_DIR)/.embtk-toolchain

TOOLCHAIN_PRE_DEPS-y	:= ccache_host_install $(AUTOTOOLS_INSTALL) pkgconf_host_install
ifeq ($(embtk_buildhost_os_type),bsd)
TOOLCHAIN_PRE_DEPS-y	+= gsed_host_install gmake_host_install
endif
TOOLCHAIN_PRE_DEPS-$(CONFIG_EMBTK_TOOLCHAIN_PREDEP_GPERF_HOST) += gperf_host_install

__gcc3_toolchain-$(CONFIG_EMBTK_GCC_ONLY_TOOLCHAIN)		:= gcc3_install
__gcc3_toolchain-$(CONFIG_EMBTK_GCC_DEFAULT_TOOLCHAIN)		:= gcc3_install
# FIXME: When libc++ will be used with clang/llvm toolchain, remove this
__gcc3_toolchain-$(CONFIG_EMBTK_GCC_LANGUAGE_CPP)		:= gcc3_install

__gcc3_toolchain-$(CONFIG_EMBTK_GCC_LANGUAGE_OBJECTIVEC) 	:= gcc3_install
__gcc3_toolchain-$(CONFIG_EMBTK_GCC_LANGUAGE_OBJECTIVECPP)	:= gcc3_install

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
__llvm_compiler-rt-$(CONFIG_EMBTK_HAVE_COMPILER-RT) := compiler-rt_install
endif

TOOLCHAIN_DEPS-y	:= linux_headers_install binutils_install
TOOLCHAIN_DEPS-$(CONFIG_EMBTK_HOST_HAVE_LLVM) += llvm_host_install
TOOLCHAIN_DEPS-y	+= gcc1_install
TOOLCHAIN_DEPS-$(CONFIG_EMBTK_CLIB_UCLIBC) += $(embtk_clib)_headers_install gcc2_install
TOOLCHAIN_DEPS-y	+= $(embtk_clib)_install
TOOLCHAIN_DEPS-y	+= $(__gcc3_toolchain-y) $(__llvm_compiler-rt-y)

TOOLCHAIN_DEPS			:= $(TOOLCHAIN_DEPS-y)
TOOLCHAIN_ADDONS_NAME		:= toolchain_addons
TOOLCHAIN_ADDONS_DEPS		:= $(TOOLCHAIN_ADDONS-y)
TOOLCHAIN_ADDONS_BUILD_DIR	:= $(TOOLCHAIN_DIR)/.embtk-toolchain_addons
TOOLCHAIN_ADDONS_SRC_DIR	:= $(TOOLCHAIN_DIR)/.embtk-toolchain_addons

-include core/mk/$(embtk_clib).mk

define __embtk_toolchain_mkinitdirs
	mkdir -p $(embtk_generated)
	mkdir -p $(TOOLCHAIN_DIR)
	mkdir -p $(TOOLCHAIN_ADDONS_BUILD_DIR)
	$(__embtk_mk_initsysrootdirs)
	$(__embtk_mk_inittoolsdirs)
	$(__embtk_mk_inithosttoolsdirs)
	$(__embtk_mk_initpkgdirs)
endef

define __embtk_toolchain_compress
	cd $(embtk_generated);							\
	tar -cjf $(TOOLCHAIN_PACKAGE)						\
		$(notdir $(embtk_sysroot)) $(notdir $(embtk_tools)) &&		\
	mv $(TOOLCHAIN_PACKAGE) $(TOOLCHAIN_DIR)/$(TOOLCHAIN_PACKAGE)
endef

define ___embtk_toolchain_decompress
	rm -rf $(embtk_sysroot) $(embtk_tools)
	cd $(embtk_generated) && tar xjf $(TOOLCHAIN_DIR)/$(TOOLCHAIN_PACKAGE)
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

__embtk_toolchain_buildargs =  $(if $(strip $(__embtk_toolchain_runrecipe-y)),core-addons)
__embtk_toolchain_buildargs += $(if $(strip $(__embtk_toolchain_addons_runrecipe-y)),addons)

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

-include $(call __embtk_pkg_dotkconfig_f,toolchain)
-include $(call __embtk_pkg_dotkconfig_f,toolchain_addons)
