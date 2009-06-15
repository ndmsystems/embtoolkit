#########################################################################################
# GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# Copyright(C) 2009 GAYE Abdoulaye Walsimou. All rights reserved.
#
# This program is free software; you can distribute it and/or modify it
# under the terms of the GNU General Public License
# (Version 2 or later) published by the Free Software Foundation.
#
# This program is distributed in the hope it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
#########################################################################################
#
# \file         Makefile
# \brief	root Makefile of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         May 2009
#########################################################################################
VERSION = 0
PATCHLEVEL = 1
SUBLEVEL = 0
EXTRAVERSION = -Beta1
KERNELVERSION = $(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION)
export VERSION PATCHLEVEL SUBLEVEL KERNELRELEASE KERNELVERSION

EMBTK_ROOT := $(shell pwd)
export EMBTK_ROOT

# SHELL used by kbuild
CONFIG_SHELL := $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
	  else if [ -x /bin/bash ]; then echo /bin/bash; \
	  else echo sh; fi ; fi)
export CONFIG_SHELL

HOST_ARCH := `$(CONFIG_SHELL) $(EMBTK_ROOT)/scripts/config.guess`
HOST_BUILD := $(HOST_ARCH)
export HOST_ARCH HOST_BUILD

HOSTCC       = gcc
HOSTCXX      = g++
HOSTCFLAGS   = -Wall
HOSTCXXFLAGS = -O2
export HOSTCC HOSTCXX HOSTCFLAGS HOSTCXXFLAGS

ifeq ($(Q),)
Q:=
else
Q:=@
endif
export Q

-include .config

ifeq ($(CONFIG_EMBTK_DOWNLOAD_DIR),)
DOWNLOAD_DIR := $(EMBTK_ROOT)/dl
endif

ifeq ($(CONFIG_EMBTK_DOTCONFIG),)
EMBTK_BUILD := xconfig
else
EMBTK_BUILD := startbuild
endif

All: $(EMBTK_BUILD)

xconfig: basic
ifeq ($(CONFIG_EMBTK_DOTCONFIG),y)
	$(Q)$(MAKE) -f scripts/Makefile.build obj=scripts/kconfig xconfig
else
	@if [ -e $(EMBTK_ROOT)/.config.old ]; then \
	cp  $(EMBTK_ROOT)/.config.old  $(EMBTK_ROOT)/.config; \
	$(Q)$(MAKE) -f scripts/Makefile.build obj=scripts/kconfig xconfig; \
	else \
	$(Q)$(MAKE) -f scripts/Makefile.build obj=scripts/kconfig xconfig; \
	fi
endif

menuconfig: basic
	$(Q)$(MAKE) -f scripts/Makefile.build obj=scripts/kconfig menuconfig

basic:
	$(Q)$(MAKE) -f scripts/Makefile.build obj=scripts/basic

clean: rmallpath
	$(Q)$(MAKE) -f scripts/Makefile.clean obj=scripts/kconfig
	$(Q)$(MAKE) -f scripts/Makefile.clean obj=scripts/basic
	$(Q)rm -rf .config kbuild.log .fakeroot*

startbuild: buildtoolchain rootfs_build

include mk/macros.mk
include mk/target-mcu.mk
include mk/initialpath.mk
include mk/toolchain.mk
include mk/packages.mk
include mk/rootfs.mk

busybox_config:
ifeq ($(CONFIG_EMBTK_DOTCONFIG),)
	$(call EMBTK_GENERIC_MESSAGE,"Please run make xconfig and configure EmbToolkit first")
	@echo
	@echo
else ifeq ($(CONFIG_EMBTK_HAVE_ROOTFS),)
	$(call EMBTK_GENERIC_MESSAGE,"Please run make xconfig and enable build of root filesystem")
	@echo
	@echo
else ifeq ($(CONFIG_EMBTK_ROOTFS_HAVE_BB),)
	$(call EMBTK_GENERIC_MESSAGE,"Please run make xconfig and enable build of Busybox")
	@echo
	@echo
else
	$(MAKE) mkinitialpath
	$(MAKE) download_busybox $(BB_BUILD_DIR)/.decompressed \
	$(BB_BUILD_DIR)/.Config.in.renewed
	KCONFIG_CONFIG=$(BB_BUILD_DIR)/.config \
	scripts/kconfig/qconf $(BB_BUILD_DIR)/Config.in.new
endif

help:
	$(call EMBTK_GENERIC_MESSAGE,"Embedded systems Toolkit help. Please visit - http://embtoolkit.org -for more details")
	@echo " ---------------------------"
	@echo "| Building and configuring: |"
	@echo " ---------------------------"
	@echo "make xconfig:    Show EmbToolkit configure GUI and let you to"
	@echo "                 configure your toolchain and your root filesystem."
	@echo "make menuconfig: Same as xconfig but using this time ncurse GUI."
	@echo
	@echo " -----------"
	@echo "| Cleaning: |"
	@echo " -----------"
	@echo "make clean:      Remove all built files, but keep downloaded"
	@echo "                 packages and host tools."
	@echo "make distclean:  Same as clean, but remove all downloaded packages."
	@echo

distclean: clean
	$(Q)rm -rf dl/* src/eglibc* host-tools

