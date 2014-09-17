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
# \file         addons.mk
# \brief	Toolchain addons part
# \author	Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date		September 2014
################################################################################

TOOLCHAIN_ADDONS_NAME		:= toolchain_addons
TOOLCHAIN_ADDONS_SRC_DIR	:= $(TOOLCHAIN_DIR)/.embtk-toolchain_addons
TOOLCHAIN_ADDONS_BUILD_DIR	:= $(TOOLCHAIN_DIR)/.embtk-toolchain_addons

# Include .kconfig symbols if any
-include $(call __embtk_pkg_dotkconfig_f,toolchain_addons)


#
# Toolchain addons build recipe
#
__embtk_toolchain_addons-y    = $(patsubst %_install,%,$(EMBTK_TOOLCHAIN_ADDONS_DEPS-y))
__embtk_toolchain_addons-n    = $(patsubst %_install,%,$(EMBTK_TOOLCHAIN_ADDONS_DEPS-))
__embtk_toolsaddons_build_msg = $(call embtk_pinfo,"Building new $(GNU_TARGET)/$(EMBTK_MCU_FLAG) toolchain ADDONS - please wait...")

define __embtk_toolchain_addons_build
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
	$(if $(EMBTK_TOOLCHAIN_ADDONS_DEPS-),
		$(foreach addon,$(__embtk_toolchain_addons-n),
				$(call embtk_cleanup_pkg,$(addon))))
	$(if $(EMBTK_TOOLCHAIN_ADDONS_DEPS-y),
		$(foreach addon,$(__embtk_toolchain_addons-y),
				$(call embtk_install_xpkg,$(addon))))
	$(call __embtk_setinstalled_pkg,toolchain_addons)
	$(if $(EMBTK_TOOLCHAIN_ADDONS_DEPS-y),
		$(call __embtk_pkg_gen_dotkconfig_f,toolchain_addons),
		$(call __embtk_pkg_setkconfigured,toolchain_addons))
endef

#
# Toolchain addons dependencies
#
embtk_pkgincdir := core/toolchain/addons

# strace
$(call embtk_include_xtoolpkg,strace,toolchain_addons)

# Addon: gdb
EMBTK_TOOLCHAIN_ADDONS_DEPS-$(CONFIG_EMBTK_HAVE_GDB)	   += gdb_install
EMBTK_TOOLCHAIN_ADDONS_DEPS-$(CONFIG_EMBTK_HAVE_GDBSERVER) += gdbserver_install
EMBTK_TOOLCHAIN_ADDONS_DEPS-$(CONFIG_EMBTK_HOST_HAVE_GDB)  += gdb_host_install
include packages/development/gdb/gdb.mk

TOOLCHAIN_ADDONS_DEPS := $(EMBTK_TOOLCHAIN_ADDONS_DEPS-y)
