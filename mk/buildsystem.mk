################################################################################
# Embtoolkit
# Copyright(C) 2009-2012 Abdoulaye Walsimou GAYE.
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
# \file         initialpath.mk
# \brief	initialpath of Embtoolkit. Here we define SYSROOT, TOOLS,
# \brief	TOOLS_BUILD PACKAGES_BUILD and ROOTFS.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

SYSROOT			:= $(EMBTK_ROOT)/sysroot-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)
TOOLS			:= $(EMBTK_ROOT)/tools-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)
TOOLS_BUILD		:= $(EMBTK_ROOT)/build/tools_build-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)
PACKAGES_BUILD		:= $(EMBTK_ROOT)/build/packages_build-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)
EMBTK_GENERATED 	:= $(EMBTK_ROOT)/generated
ROOTFS			:= $(EMBTK_GENERATED)/rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)
HOSTTOOLS		:= $(EMBTK_ROOT)/host-tools-$(EMBTK_MCU_FLAG)
DOWNLOAD_DIR		:= $(patsubst %/,%,$(subst ",,$(strip $(CONFIG_EMBTK_DOWNLOAD_DIR))))
J			:= -j$(CONFIG_EMBTK_NUMBER_BUILD_JOBS)

xconfig: basic
ifeq ($(CONFIG_EMBTK_DOTCONFIG),y)
	$(Q)make -f scripts/Makefile.build obj=scripts/kconfig			\
	EMBTK_DEFAULT_DL="$(EMBTK_ROOT)/dl/" 					\
	EMBTK_VERSION=$(EMBTK_VERSION) xconfig
else
	$(Q)if [ -e $(EMBTK_DOTCONFIG).old ]; then				\
		cp  $(EMBTK_DOTCONFIG).old  $(EMBTK_DOTCONFIG);			\
		make -f scripts/Makefile.build obj=scripts/kconfig		\
		EMBTK_DEFAULT_DL="$(EMBTK_ROOT)/dl/"				\
		EMBTK_VERSION=$(EMBTK_VERSION) xconfig;				\
	else									\
		make -f scripts/Makefile.build obj=scripts/kconfig		\
		EMBTK_DEFAULT_DL="$(EMBTK_ROOT)/dl/"				\
		EMBTK_VERSION=$(EMBTK_VERSION) xconfig;				\
	fi
endif

menuconfig: basic
	$(Q)$(MAKE) -f scripts/Makefile.build obj=scripts/kconfig		\
	EMBTK_DEFAULT_DL="$(EMBTK_ROOT)/dl/"					\
	EMBTK_VERSION=$(EMBTK_VERSION) menuconfig

randconfig: basic
	$(Q)$(MAKE) -f scripts/Makefile.build obj=scripts/kconfig		\
	EMBTK_DEFAULT_DL="$(EMBTK_ROOT)/dl/"					\
	EMBTK_VERSION=$(EMBTK_VERSION) randconfig

basic:
	$(Q)$(MAKE) -f scripts/Makefile.build obj=scripts/basic

clean: rmallpath
	$(Q)$(MAKE) -f scripts/Makefile.clean obj=scripts/kconfig
	$(Q)$(MAKE) -f scripts/Makefile.clean obj=scripts/basic
	$(Q)rm -rf .config kbuild.log .fakeroot*

distclean: clean
	$(Q)rm -rf dl/* src/eglibc* host-tools* .config.old

startbuild:
	@if [ -e $(GCC3_BUILD_DIR)/.installed ]; then \
	echo "#################### Embtoolkit Warning ######################"; \
	echo "# Warning trying to restart all the build while it is already"; \
	echo "# done. Please use the correct make target !!!"; \
	echo "##############################################################"; \
	echo; \
	make -s help; \
	else \
	echo "################## Embtoolkit build start ####################"; \
	echo "# Starting build of selected features.."; \
	echo "##############################################################"; \
	echo; \
	make buildtoolchain host_packages_build symlink_tools rootfs_build \
	successful_build; \
	fi

# Successful build of EmbToolkit message
successful_build:
	$(call embtk_echo_blue," ~~~~~~~~~~~~~~~~~~~~~ ")
	$(call embtk_echo_blue,"| Toolchain build log |")
	$(call embtk_echo_blue," ~~~~~~~~~~~~~~~~~~~~~ ")
	$(call embtk_echo_blue,"You successfully build your toolchain for $(GNU_TARGET)")
	$(call embtk_echo_blue,"Tools built (GCC compiler, Binutils, etc.) are located in:")
	$(call embtk_echo_blue,"    $(TOOLS)/bin")
	@echo
	$(call embtk_echo_blue," ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ")
	$(call embtk_echo_blue,"| Root file system build log |")
	$(call embtk_echo_blue," ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ")
ifeq ($(CONFIG_EMBTK_HAVE_ROOTFS),y)
	$(call embtk_echo_blue,"You also successfully build root filesystem(s) located in the")
	$(call embtk_echo_blue,"'generated' sub-directory of EmbToolkit.")
else
	$(call embtk_echo_green,"Build of root filesystem not selected.")
endif
	@echo
	$(call embtk_echo_blue," ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ")
	$(call embtk_echo_blue,"| Embedded systems Toolkit   |")
	$(call embtk_echo_blue," ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ")
	$(call embtk_echo_blue,"Hope that EmbToolkit will be useful for your project !!!")
	$(call embtk_echo_blue,"Please report any bugs/suggestion at:")
	$(call embtk_echo_blue,"   http://www.embtoolkit.org/issues/projects/show/embtoolkit")
	$(call embtk_echo_blue,"You can also visit the wiki at:")
	$(call embtk_echo_blue,"   http://www.embtoolkit.org")
	@echo
	$(call embtk_echo_blue,$(__embtk_msg_h))

define __embtk_mk_initsysrootdirs
	mkdir -p $(SYSROOT)
	mkdir -p $(SYSROOT)/lib
	mkdir -p $(SYSROOT)/usr
	mkdir -p $(SYSROOT)/usr/etc
	mkdir -p $(SYSROOT)/root
	mkdir -p $(SYSROOT)/usr/lib
	$(if $(CONFIG_EMBTK_32BITS_FS),,cd $(SYSROOT);				\
		ln -sf lib lib64; cd $(SYSROOT)/usr;ln -sf lib lib64)
	$(Q)$(if $(CONFIG_EMBTK_64BITS_FS_COMPAT32),				\
		cd $(SYSROOT); ln -sf lib lib64; mkdir -p lib32;		\
		cd $(SYSROOT)/usr; ln -sf lib lib64; mkdir -p lib32)
endef

define __embtk_mk_inittoolsdirs
	mkdir -p $(TOOLS)
	mkdir -p $(TOOLS_BUILD)
endef

define __embtk_mk_inithosttoolsdirs
	mkdir -p $(HOSTTOOLS)
	mkdir -p $(HOSTTOOLS)/usr
	mkdir -p $(HOSTTOOLS)/usr/include
	mkdir -p $(HOSTTOOLS)/usr/local
endef

define __embtk_mk_initrootfsdirs
	$(if $(CONFIG_EMBTK_HAVE_ROOTFS),					\
		mkdir -p $(ROOTFS);						\
		cp -Rp $(EMBTK_ROOT)/src/target_skeleton/* $(ROOTFS)/;		\
		mkdir -p $(PACKAGES_BUILD))
endef

mkinitialpath:
	$(Q)$(__embtk_mk_initsysrootdirs)
	$(Q)$(__embtk_mk_inittoolsdirs)
	$(Q)$(__embtk_mk_inithosttoolsdirs)
	$(Q)$(__embtk_mk_initrootfsdirs)

rmallpath:
	$(Q)rm -rf $(PACKAGES_BUILD) $(ROOTFS) $(TOOLS) $(TOOLS_BUILD)
	$(Q)rm -rf $(SYSROOT) $(EMBTK_GENERATED) $(HOSTTOOLS)
	$(Q)$(if $(CONFIG_EMBTK_CACHE_PATCHES),,rm -rf $(DOWNLOAD_DIR)/*.patch)
