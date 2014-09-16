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
# Toolchain variables and macros
#
include core/toolchain/vars.mk
include core/toolchain/common.mk

include packages/htools/ccache/vars.mk
include packages/htools/m4/vars.mk
include packages/htools/libtool/vars.mk
include packages/htools/autoconf/vars.mk
include packages/htools/automake/vars.mk

include core/toolchain/core.mk
include core/toolchain/addons.mk

define __embtk_toolchain_build
	$(eval __xtool_build        := $(if $(__embtk_toolchain_runrecipe-y),core))
	$(eval __xtool_addons_build := $(if $(__embtk_toolchain_addons_runrecipe-y),addons))
	$(eval __xtool_build_args   := $(strip $(__xtool_build) $(__xtool_addons_build)))
	$(if $(__xtool_build),
		$(call __embtk_toolchain_core_build,$(__xtool_build_args)))
	$(if $(__xtool_addons_build),
		$(call __embtk_toolchain_addons_build,$(__xtool_build_args)))
	$(if $(__xtool_build_args),
		$(call embtk_pinfo,"Packaging new $(GNU_TARGET)/$(EMBTK_MCU_FLAG) toolchain - please wait...")
		$(__embtk_toolchain_compress)
		$(call __embtk_setdecompressed_pkg,toolchain)
		$(call __embtk_setdecompressed_pkg,toolchain_addons)
		$(__embtk_toolchain_built_msg),
		$(__embtk_toolchain_decompress))
endef

toolchain_install:
	$(Q)$(__embtk_toolchain_build)

define __embtk_toolchain_clean
	$(call __embtk_unsetdecompressed_pkg,toolchain)
	$(call __embtk_unsetdecompressed_pkg,toolchain_addons)
endef

toolchain_clean:
	$(Q)$(__embtk_toolchain_clean)

pembtk_toolchain_mkinitdirs:
	$(__embtk_toolchain_mkinitdirs)

pembtk_toolchain_predeps_install:
	$(__embtk_toolchain_mkinitdirs)
	$(MAKE) $(TOOLCHAIN_PREDEPS-y)

# Download target for offline build
TOOLCHAIN_ALL_DEPS := $(TOOLCHAIN_PREDEPS-y) $(TOOLCHAIN_DEPS)
TOOLCHAIN_ALL_DEPS += $(TOOLCHAIN_ADDONS_DEPS)

packages_fetch:: $(patsubst %_install,download_%,$(TOOLCHAIN_ALL_DEPS))
