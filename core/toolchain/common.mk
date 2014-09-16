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
# \brief	Toolchain common variables and macros
# \author	Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date		September 2014
################################################################################

#
# Toolchain components init
#
EMBTK_TOOLCHAIN_PREDEPS-y     :=
EMBTK_TOOLCHAIN_DEPS-y        :=
EMBTK_TOOLCHAIN_ADDONS_DEPS-y :=

#
# Toolchain base directory definition
#
__xtools_compiler-$(CONFIG_EMBTK_LLVM_ONLY_TOOLCHAIN)    := clangllvm-$(call embtk_pkg_version,llvm_host)
__xtools_compiler-$(CONFIG_EMBTK_LLVM_DEFAULT_TOOLCHAIN) := clangllvm-$(call embtk_pkg_version,llvm_host)
__xtools_compiler-$(CONFIG_EMBTK_GCC_ONLY_TOOLCHAIN)     := gcc-$(call embtk_pkg_version,gcc)
__xtools_compiler-$(CONFIG_EMBTK_GCC_DEFAULT_TOOLCHAIN)  := gcc-$(call embtk_pkg_version,gcc)
__xtools_bins := $(__xtools_compiler-y)-$(embtk_clib)-$(embtk_clib_version)

TOOLCHAIN_DIR := $(embtk_generated)/toolchains/toolchain-$(__xtools_archos)-$(__xtools_bins)-$(__xtools_env)

#
# Toolchain pre-dependencies
#
EMBTK_TOOLCHAIN_PREDEPS-y := ccache_host_install
EMBTK_TOOLCHAIN_PREDEPS-y += m4_host_install
EMBTK_TOOLCHAIN_PREDEPS-y += libtool_host_install
EMBTK_TOOLCHAIN_PREDEPS-y += autoconf_host_install
EMBTK_TOOLCHAIN_PREDEPS-y += automake_host_install
EMBTK_TOOLCHAIN_PREDEPS-y += pkgconf_host_install
ifeq ($(embtk_buildhost_os_type),bsd)
EMBTK_TOOLCHAIN_PREDEPS-y += gsed_host_install gmake_host_install
endif

#
# Toolchain macros evaluating if core and addons need to be built
#
__embtk_toolchain_runrecipe-y = $(strip $(___embtk_toolchain_runrecipe-y))
define ___embtk_toolchain_runrecipe-y
	$(eval __xtool_changed-y   := $(call __embtk_pkg_runrecipe-y,toolchain))
	$(eval __xtool_exists-y    := $(if $(wildcard $(TOOLCHAIN_DIR)/$(TOOLCHAIN_PACKAGE)),,y))
	$(eval __xtool_runrecipe-y := $(or $(__xtool_changed-y),$(__xtool_exists-y)))$(__xtool_runrecipe-y)
endef

__embtk_toolchain_addons_runrecipe-y = $(strip $(___embtk_toolchain_addons_runrecipe-y))
define ___embtk_toolchain_addons_runrecipe-y
	$(eval __xtool_addons_changed-y := $(call __embtk_pkg_runrecipe-y,toolchain_addons))
	$(eval __xtool_exists-y         := $(if $(wildcard $(TOOLCHAIN_DIR)/$(TOOLCHAIN_PACKAGE)),,y))
	$(eval __xtool_runrecipe-y      := $(or $(__xtool_addons_changed-y),$(__xtool_exists-y)))$(__xtool_runrecipe-y)
endef

#
# Toolchain needed directories creation
#
define __embtk_toolchain_mkinitdirs
	mkdir -p $(embtk_generated)
	mkdir -p $(TOOLCHAIN_DIR)
	mkdir -p $(TOOLCHAIN_ADDONS_BUILD_DIR)
	$(__embtk_mk_initsysrootdirs)
	$(__embtk_mk_inittoolsdirs)
	$(__embtk_mk_inithosttoolsdirs)
	$(__embtk_mk_initpkgdirs)
endef

#
# Toolchain compress/uncompress macros
#
define __embtk_toolchain_compress
	cd $(embtk_generated);							\
	tar -cjf $(TOOLCHAIN_PACKAGE)						\
		$(notdir $(embtk_sysroot)) $(notdir $(embtk_tools)) &&		\
	mv $(TOOLCHAIN_PACKAGE) $(TOOLCHAIN_DIR)/$(TOOLCHAIN_PACKAGE)
endef

define __embtk_toolchain_decompress
	$(if $(call __embtk_pkg_notdecompressed-y,toolchain),
		$(call embtk_pinfo,"Decompressing cached $(GNU_TARGET)/$(EMBTK_MCU_FLAG) toolchain - please wait...")
		$(___embtk_toolchain_decompress)
		$(call __embtk_setdecompressed_pkg,toolchain))
endef
define ___embtk_toolchain_decompress
	rm -rf $(embtk_sysroot) $(embtk_tools)
	cd $(embtk_generated) && tar xjf $(TOOLCHAIN_DIR)/$(TOOLCHAIN_PACKAGE)
	$(__embtk_toolchain_mkinitdirs)
	$(MAKE) $(EMBTK_TOOLCHAIN_PREDEPS-y)
endef
