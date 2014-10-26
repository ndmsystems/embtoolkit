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
# \file         buildsystem.mk
# \brief	buildsystem.mk of Embtoolkit.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

TOOLS_BUILD		:= $(EMBTK_ROOT)/build/tools_build-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)
PACKAGES_BUILD		:= $(EMBTK_ROOT)/build/packages_build-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)
J			:= -j$(or $(CONFIG_EMBTK_NUMBER_BUILD_JOBS),1)

#
# New version of above variables names. The old names are scheduled for removal
#
embtk_generated		:= $(EMBTK_ROOT)/generated
embtk_sysroot		:= $(embtk_generated)/sysroot-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)
embtk_tools		:= $(embtk_generated)/tools-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)
embtk_htools		:= $(embtk_generated)/host-tools-$(EMBTK_MCU_FLAG)
embtk_toolsb		:= $(TOOLS_BUILD)
embtk_pkgb		:= $(PACKAGES_BUILD)
embtk_rootfs		:= $(embtk_generated)/rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)
__embtk_dldir		:= $(patsubst %/,%,$(call __embtk_mk_uquote,$(CONFIG_EMBTK_DOWNLOAD_DIR)))
embtk_dldir		:= $(or $(__embtk_dldir),$(EMBTK_ROOT)/dl)
embtk_srcdir		:= $(EMBTK_ROOT)/src
embtk_includedir	:= $(embtk_srcdir)/embtk/include


define __embtk_kconfig_buildrun
	PKG_CONFIG_PATH=$(EMBTK_HOST_PKG_CONFIG_PATH)				\
	$(MAKE) -f scripts/Makefile.build					\
		obj=$(EMBTK_ROOT)/scripts/kconfig				\
		EMBTK_HOST_OS="$(embtk_buildhost_os)"				\
		EMBTK_HOST_OSTYPE="$(embtk_buildhost_os_type)"			\
		EMBTK_DEFAULT_DL="$(EMBTK_ROOT)/dl/"				\
		EMBTK_VERSION=$(EMBTK_VERSION)					\
		CONFIG_SHELL=$(CONFIG_EMBTK_SHELL)				\
		quiet=quiet_ KBUILD_VERBOSE=0 $(1)
endef

define __embtk_mk_xconfig
	$(if $(CONFIG_EMBTK_DOTCONFIG),true,
		if [ -e $(EMBTK_DOTCONFIG).old ]; then				\
			cp $(EMBTK_DOTCONFIG).old  $(EMBTK_DOTCONFIG);		\
		fi)
	$(call __embtk_kconfig_buildrun,$(1))
endef

xconfig menuconfig nconfig olddefconfig: embtk_kconfig_basic
	$(Q)$(call __embtk_mk_xconfig,$@)

embtk_kconfig_basic:
	$(Q)$(MAKE) -f scripts/Makefile.build					\
		obj=$(EMBTK_ROOT)/scripts/basic quiet=quiet_ KBUILD_VERBOSE=0

__bsystem_xtoolchain_decompressed := $(wildcard $(embtk_generated)/toolchain-*/.*.embtk.decompressed)
clean: toolchain_clean rmallpath
	$(Q)$(__embtk_kconfig_clean)
	[ -e .config ] && cp .config .config.old || true
	$(Q)rm -rf .config kbuild.log .fakeroot*
	$(Q)$(if $(__bsystem_xtoolchain_decompressed),rm -rf $(__bsystem_xtoolchain_decompressed))

distclean: clean
	$(Q)rm -rf dl/* src/*.git src/*.svn .config.old
	$(Q)rm -rf $(embtk_generated)


define __embtk_mk_print_selectedfeatures
	$(call embtk_pinfo,"Starting build of selected features...")
	$(help_toolchain_summary)
	$(help_rootfs_summary)
endef

__embtk_mk_startbuild-y						:= __startbuild_msg
__embtk_mk_startbuild-y						+= toolchain_install
__embtk_mk_startbuild-$(CONFIG_EMBTK_BUILD_LINUX_KERNEL)	+= linux_install
__embtk_mk_startbuild-$(CONFIG_EMBTK_HAVE_ROOTFS)		+= rootfs_build
__embtk_mk_startbuild-y						+= __endbuild_msg

__startbuild_msg:
	$(__embtk_mk_print_selectedfeatures)

__endbuild_msg:
	$(call embtk_pinfo,"Selected features built successfully...")
	$(help_toolchain_summary)
	$(help_rootfs_summary)
	$(help_successful_build)

startbuild: $(__embtk_mk_startbuild-y)
	@:

define __embtk_mk_initsysrootdirs
	mkdir -p $(embtk_generated)
	mkdir -p $(embtk_sysroot)
	[ -L $(EMBTK_ROOT)/$(notdir $(embtk_sysroot)) ] ||			\
		ln -sf $(embtk_sysroot) $(EMBTK_ROOT)/$(notdir $(embtk_sysroot))
	mkdir -p $(embtk_sysroot)/etc
	mkdir -p $(embtk_sysroot)/lib
	mkdir -p $(embtk_sysroot)/usr
	mkdir -p $(embtk_sysroot)/root
	mkdir -p $(embtk_sysroot)/usr/lib
	$(if $(CONFIG_EMBTK_32BITS_FS),,					\
		cd $(embtk_sysroot); rm -rf lib64; ln -sf lib lib64;		\
		cd $(embtk_sysroot)/usr; rm -rf lib64; ln -sf lib lib64)
	$(if $(CONFIG_EMBTK_64BITS_FS_COMPAT32),				\
		cd $(embtk_sysroot);						\
			 rm -rf lib64; ln -sf lib lib64; mkdir -p lib32;	\
		cd $(embtk_sysroot)/usr;					\
			 rm -rf lib64; ln -sf lib lib64; mkdir -p lib32)
endef

define __embtk_mk_inittoolsdirs
	mkdir -p $(embtk_generated)
	mkdir -p $(embtk_generated)/toolchains
	mkdir -p $(embtk_tools)
	mkdir -p $(embtk_toolsb)
	[ -L $(EMBTK_ROOT)/$(notdir $(embtk_tools)) ] ||			\
		ln -sf $(embtk_tools) $(EMBTK_ROOT)/$(notdir $(embtk_tools))
endef

define __embtk_mk_initpkgdirs
	mkdir -p $(embtk_dldir)
	mkdir -p $(EMBTK_ROOT)/build
	mkdir -p $(embtk_pkgb)
endef

define __embtk_mk_inithosttoolsdirs
	mkdir -p $(embtk_generated)
	mkdir -p $(embtk_htools)
	mkdir -p $(embtk_htools)/usr
	mkdir -p $(embtk_htools)/usr/include
	mkdir -p $(embtk_htools)/usr/local
	[ -L $(EMBTK_ROOT)/$(notdir $(embtk_htools)) ] ||			\
		ln -sf $(embtk_htools) $(EMBTK_ROOT)/$(notdir $(embtk_htools))
endef

define __embtk_kconfig_clean
	rm -rf $(EMBTK_ROOT)/scripts/basic/fixdep
	rm -rf $$(find $(EMBTK_ROOT)/scripts/kconfig -type f -name 'config*')
	rm -rf $$(find $(EMBTK_ROOT)/scripts/kconfig -type f -name 'lex.*.c')
	rm -rf $$(find $(EMBTK_ROOT)/scripts/kconfig -type f -name 'zconf.lex.c')
	rm -rf $$(find $(EMBTK_ROOT)/scripts/kconfig -type f -name '*.tab.c')
	rm -rf $$(find $(EMBTK_ROOT)/scripts/kconfig -type f -name '*.tab.h')
	rm -rf $$(find $(EMBTK_ROOT)/scripts/kconfig -type f -name 'zconf.hash.c')
	rm -rf $$(find $(EMBTK_ROOT)/scripts/kconfig -type f -name '*.moc')
	rm -rf $$(find $(EMBTK_ROOT)/scripts/kconfig -type f -name 'lkc_defs.h')
	rm -rf $$(find $(EMBTK_ROOT)/scripts/kconfig -type f -name '*.o')
	rm -rf $$(find $(EMBTK_ROOT)/scripts/kconfig -type f -name '*.tmp_qtcheck')
	rm -rf $$(find $(EMBTK_ROOT)/scripts/kconfig -type f -name '*.tmp_gtkcheck')
	rm -rf $$(find $(EMBTK_ROOT)/scripts/kconfig -type f -name 'conf')
	rm -rf $$(find $(EMBTK_ROOT)/scripts/kconfig -type f -name 'mconf')
	rm -rf $$(find $(EMBTK_ROOT)/scripts/kconfig -type f -name 'qconf')
	rm -rf $$(find $(EMBTK_ROOT)/scripts/kconfig -type f -name 'gconf')
	rm -rf $$(find $(EMBTK_ROOT)/scripts/kconfig -type f -name 'kxgettext')
	rm -rf $$(find $(EMBTK_ROOT)/scripts/ -type f -name '*.*.cmd')
endef

rmallpath:
	$(Q)rm -rf $(embtk_pkgb)* $(embtk_rootfs)* $(embtk_tools)* $(embtk_toolsb)*
	$(Q)rm -rf $(EMBTK_ROOT)/host-tools-*
	$(Q)rm -rf $(EMBTK_ROOT)/sysroot-*
	$(Q)rm -rf $(EMBTK_ROOT)/tools-*
	$(Q)rm -rf $(EMBTK_ROOT)/build
	$(Q)rm -rf $(embtk_sysroot)* $(embtk_htools)* $(embtk_generated)/rootfs-*
	$(Q)$(if $(CONFIG_EMBTK_CACHE_PATCHES),,rm -rf $(embtk_dldir)/*.patch)
