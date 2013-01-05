################################################################################
# Copyright(C) 2009-2012 Abdoulaye Walsimou GAYE <awg@embtoolkit.org>.
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
__TARGETCC-$(CONFIG_EMBTK_GCC_ONLY_TOOLCHAIN)		:= $(TARGETGCC)
__TARGETCC-$(CONFIG_EMBTK_GCC_DEFAULT_TOOLCHAIN)	:= $(TARGETGCC)
__TARGETCXX-$(CONFIG_EMBTK_GCC_ONLY_TOOLCHAIN)		:= $(TARGETGCXX)
__TARGETCXX-$(CONFIG_EMBTK_GCC_DEFAULT_TOOLCHAIN)	:= $(TARGETGCXX)

__TARGETCC-$(CONFIG_EMBTK_LLVM_ONLY_TOOLCHAIN)		:= $(TARGETCLANG)
__TARGETCC-$(CONFIG_EMBTK_LLVM_DEFAULT_TOOLCHAIN)	:= $(TARGETCLANG)
__TARGETCXX-$(CONFIG_EMBTK_LLVM_ONLY_TOOLCHAIN)		:= $(TARGETCLANGXX)
__TARGETCXX-$(CONFIG_EMBTK_LLVM_DEFAULT_TOOLCHAIN)	:= $(TARGETCLANGXX)

TARGETCC		:= $(__TARGETCC-y)
TARGETCXX		:= $(__TARGETCXX-y)

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
include mk/llvm/compiler-rt.mk
include mk/llvm/llvm.mk

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

# Toolchain internals
TOOLCHAIN_NAME		:= toolchain
TOOLCHAIN_PACKAGE	:= toolchain-$(GNU_TARGET)-$(embtk_clib)-$(EMBTK_MCU_FLAG).tar.bz2
TOOLCHAIN_DIR		:= $(embtk_generated)/toolchain-$(GNU_TARGET)-$(embtk_clib)-$(EMBTK_MCU_FLAG)
TOOLCHAIN_BUILD_DIR	:= $(TOOLCHAIN_DIR)
TOOLCHAIN_SRC_DIR	:= $(TOOLCHAIN_DIR)

TOOLCHAIN_PRE_DEPS-y	:= ccache_install $(AUTOTOOLS_INSTALL)
TOOLCHAIN_PRE_DEPS-y	+= $(if $(CONFIG_EMBTK_TOOLCHAIN_PREDEP_GPERF_HOST),	\
				gperf_host_install)

__gcc3_toolchain-$(CONFIG_EMBTK_GCC_ONLY_TOOLCHAIN)	:= gcc3_install
__gcc3_toolchain-$(CONFIG_EMBTK_GCC_DEFAULT_TOOLCHAIN)	:= gcc3_install

__llvm_toolchain-$(CONFIG_EMBTK_LLVM_ONLY_TOOLCHAIN)	:= llvm_install
__llvm_toolchain-$(CONFIG_EMBTK_LLVM_DEFAULT_TOOLCHAIN)	:= llvm_install

TOOLCHAIN_DEPS		:= linux_headers_install gmp_host_install
TOOLCHAIN_DEPS		+= mpfr_host_install mpc_host_install binutils_install
TOOLCHAIN_DEPS		+= $(__llvm_toolchain-y)
TOOLCHAIN_DEPS		+= gcc1_install $(embtk_clib)_headers_install
TOOLCHAIN_DEPS		+= gcc2_install $(embtk_clib)_install
TOOLCHAIN_DEPS		+= $(__gcc3_toolchain-y)

TOOLCHAIN_ADDONS_NAME		:= toolchain-addons
TOOLCHAIN_ADDONS_DEPS		:= $(TOOLCHAIN_ADDONS-y)
TOOLCHAIN_ADDONS_BUILD_DIR	:= $(TOOLCHAIN_BUILD_DIR)/.addons
TOOLCHAIN_ADDONS_SRC_DIR	:= $(TOOLCHAIN_BUILD_DIR)/.addons

-include mk/$(embtk_clib).mk

define __embtk_toolchain_mkinitdirs
	$(__embtk_mk_initsysrootdirs)
	$(__embtk_mk_inittoolsdirs)
	$(__embtk_mk_inithosttoolsdirs)
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
	cd $(EMBTK_ROOT) && tar xjf $(TOOLCHAIN_DIR)/$(TOOLCHAIN_PACKAGE)
	$(__embtk_toolchain_mkinitdirs)
	$(MAKE) $(TOOLCHAIN_PRE_DEPS-y)
	mkdir -p $(GCC3_BUILD_DIR)
	touch $(call __embtk_pkg_dotinstalled_f,gcc3)
	touch $(GCC3_BUILD_DIR)/.gcc3_post_install
	$(MAKE) __embtk_gcc3_printmetakconfigs > 				\
					$(call __embtk_pkg_dotpkgkconfig_f,gcc3)
endef

define __embtk_toolchain_decompress
	$(if $(call __embtk_mk_pathnotexist,$(call __embtk_pkg_dotdecompressed_f,toolchain)),
		$(call embtk_pinfo,"Decompressing $(GNU_TARGET)/$(EMBTK_MCU_FLAG) toolchain - please wait...")
		$(___embtk_toolchain_decompress)
		touch $(call __embtk_pkg_dotdecompressed_f,toolchain))
endef

__embtk_toolchain_deps-y	= $(patsubst %_install,%,$(TOOLCHAIN_DEPS))
__embtk_toolchain_predeps-y	= $(patsubst %_install,%,$(TOOLCHAIN_PRE_DEPS-y))
__embtk_toolchain_addons-y	= $(patsubst %_install,%,$(TOOLCHAIN_ADDONS-y))
__embtk_toolchain_addons-n	= $(patsubst %_install,%,$(TOOLCHAIN_ADDONS-))
__embtk_toolchain_built_msg	= $(call embtk_pinfo,"New $(GNU_TARGET)/$(EMBTK_MCU_FLAG) toolchain successfully built!")
__embtk_toolchain_building_msg	= $(call embtk_pinfo,"Building new $(GNU_TARGET)/$(EMBTK_MCU_FLAG) CORE toolchain - please wait...")
__embtk_toolsaddons_build_msg	= $(call embtk_pinfo,"Building new $(GNU_TARGET)/$(EMBTK_MCU_FLAG) toolchain ADDONS - please wait...")
define __embtk_toolchain_build
	$(if $(findstring core,$(1)),
		$(__embtk_toolchain_building_msg)
		rm -rf $(call __embtk_pkg_dotinstalled_f,toolchain)
		rm -rf $(call __embtk_pkg_dotdecompressed_f,toolchain)
		$(foreach dep,$(__embtk_toolchain_deps-y),
					$(call embtk_cleanup_pkg,$(dep)))
		$(foreach pkg,$(__embtk_rootfs_pkgs-y),
					$(call embtk_cleanup_pkg,$(pkg)))
		rm -rf $(embtk_sysroot) $(embtk_tools)
		$(__embtk_toolchain_mkinitdirs)
		$(foreach pdep,$(__embtk_toolchain_predeps-y),
					$(call embtk_install_xpkg,$(pdep)))
		$(foreach dep,$(__embtk_toolchain_deps-y),
					$(call embtk_install_xpkg,$(dep)))
		touch $(call __embtk_pkg_dotinstalled_f,toolchain))
	$(if $(findstring addons,$(1)),
		$(__embtk_toolsaddons_build_msg)
		rm -rf $(call __embtk_pkg_dotinstalled_f,toolchain_addons)
		rm -rf $(call __embtk_pkg_dotdecompressed_f,toolchain_addons)
		$(if $(findstring core,$(1)),,$(___embtk_toolchain_decompress))
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
		touch $(call __embtk_pkg_dotinstalled_f,toolchain_addons))
	$(if $(findstring core,$(1))$(findstring addons,$(1)),
		$(__embtk_toolchain_symlinktools)
		$(__embtk_toolchain_compress)
		touch $(call __embtk_pkg_dotdecompressed_f,toolchain)
		touch $(call __embtk_pkg_dotdecompressed_f,toolchain_addons)
		$(__embtk_toolchain_built_msg),
		$(__embtk_toolchain_decompress))
endef

define __embtk_toolchain_core_inst-y
	 $(and $(call __embtk_pkg_installed-y,toolchain),
	 $(call __embtk_mk_pathexist,$(TOOLCHAIN_DIR)/$(TOOLCHAIN_PACKAGE)))
endef
__embtk_toolchain_core_inst = $(if $(strip $(__embtk_toolchain_core_inst-y)),,core)

define __embtk_toolchain_addons_inst-y
	$(and $(call __embtk_pkg_installed-y,toolchain_addons),
	$(call __embtk_mk_pathexist,$(TOOLCHAIN_DIR)/$(TOOLCHAIN_PACKAGE)))
endef
__embtk_toolchain_addons_inst = $(if $(strip $(__embtk_toolchain_addons_inst-y)),,addons)

__embtk_toolchain_buildargs = $(if $(__embtk_toolchain_core_inst),core-addons)
__embtk_toolchain_buildargs += $(__embtk_toolchain_addons_inst)

toolchain_install:
	$(Q)$(call __embtk_toolchain_build,$(__embtk_toolchain_buildargs))

define __embtk_toolchain_clean
	rm -rf $(call __embtk_pkg_dotdecompressed_f,toolchain)
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
