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
	$(Q)rm -rf dl/* src/*.git src/*.svn .config.old
	$(Q)rm -rf $(EMBTK_GENERATED)

define __embtk_mk_pwarning_restartbuild
	$(call embtk_pwarning,"Wrong make target - Use correct make target")
	$(call embtk_echo_yellow,"You are trying to restart all the build while it is already")
	$(call embtk_echo_yellow,"done. Please use the correct make target!!!")
	echo
	$(MAKE) help
endef

define __embtk_mk_print_selectedfeatures
	$(call embtk_pinfo,"Starting build of selected features...")
endef

define __embtk_mk_startbuild
	$(__embtk_mk_print_selectedfeatures)
	$(call embtk_echo_blue," ~~~~~~~~~~~ ")
	$(call embtk_echo_blue,"| Toolchain |")
	$(call embtk_echo_blue," ~~~~~~~~~~~ ")
	$(call embtk_echo_blue,"\tLinux kernel headers: linux-$(call embtk_get_pkgversion,linux)")
	$(call embtk_echo_blue,"\tC library           :")
	$(call embtk_echo_blue,"\tBinutils            : binutils-$(call embtk_get_pkgversion,binutils)")
	$(call embtk_echo_blue,"\tGCC                 : gcc-$(call embtk_get_pkgversion,gcc)")
	$(if $(CONFIG_EMBTK_HAVE_GDB_SYSTEM),
	$(call embtk_echo_blue,"\tGDB                 : gdb-$(call embtk_get_pkgversion,gdb)"))
	$(if $(CONFIG_EMBTK_ROOTFS_HAVE_STRACE),
	$(call embtk_echo_blue,"\tStrace              : strace-$(call embtk_get_pkgversion,strace)"))
	$(call embtk_echo_blue," ~~~~~~~~~~~~ ")
	$(call embtk_echo_blue,"| Host tools |")
	$(call embtk_echo_blue," ~~~~~~~~~~~~ ")
	$(call embtk_echo_blue,"\tNumber of host tools packages needed:$(__embtk_hosttools_nrpackages)")
	$(if $(CONFIG_EMBTK_HAVE_ROOTFS),
		$(call embtk_echo_blue," ~~~~~~~~~~~~~~~~~~ ")
		$(call embtk_echo_blue,"| Root FS packages |")
		$(call embtk_echo_blue," ~~~~~~~~~~~~~~~~~~ ")
		$(call embtk_echo_blue,"\tNumber of root FS packages:$(__embtk_rootfs_nrpackages)")
		$(call embtk_echo_blue," ~~~~~~~~~~~~~~~ ")
		$(call embtk_echo_blue,"| Root FS types |")
		$(call embtk_echo_blue," ~~~~~~~~~~~~~~~ ")
		$(call embtk_echo_blue,"\tTAR.BZ2   : Yes")
		$(call embtk_echo_blue,"\tInitramfs : $(if $(CONFIG_EMBTK_ROOTFS_HAVE_INITRAMFS_CPIO),Yes,No)")
		$(call embtk_echo_blue,"\tsqashFS   : $(if $(CONFIG_EMBTK_ROOTFS_HAVE_SQUASHFS),Yes,No)")
		$(call embtk_echo_blue,"\tJFFS2     : $(if $(CONFIG_EMBTK_ROOTFS_HAVE_JFFS2),Yes,No)"))
	$(MAKE) buildtoolchain host_packages_build rootfs_build successful_build
endef

startbuild:
	$(if $(call __embtk_mk_pathexist,$(GCC3_BUILD_DIR)/.installed),		\
		$(__embtk_mk_pwarning_restartbuild),$(__embtk_mk_startbuild))

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

define __embtk_mk_initialpath
	$(__embtk_mk_initsysrootdirs)
	$(__embtk_mk_inittoolsdirs)
	$(__embtk_mk_inithosttoolsdirs)
	$(__embtk_mk_initrootfsdirs)
endef

mkinitialpath:
	$(Q)$(__embtk_mk_initialpath)

rmallpath:
	$(Q)rm -rf $(PACKAGES_BUILD)* $(ROOTFS)* $(TOOLS)* $(TOOLS_BUILD)*
	$(Q)rm -rf $(SYSROOT)* $(HOSTTOOLS)* $(EMBTK_GENERATED)/rootfs-*
	$(Q)rm -rf $(EMBTK_GENERATED)/initramfs-*
	$(Q)$(if $(CONFIG_EMBTK_CACHE_PATCHES),,rm -rf $(DOWNLOAD_DIR)/*.patch)
