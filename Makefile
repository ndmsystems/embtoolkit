################################################################################
# EmbToolkit
# Copyright(C) 2009-2011 Abdoulaye Walsimou GAYE.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
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
# \file         Makefile
# \brief	root Makefile of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################
VERSION			:= 0
PATCHLEVEL		:= 1
SUBLEVEL		:= 0
EXTRAVERSION		:= -rc16
EMBTK_VERSION		:= 							\
	$(shell									\
	dversion=$(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION);		\
	if [ -e .git ]; then							\
		version=$$(scripts/setlocalversion .);				\
		if [ "x$$version" = "x" ]; then					\
			echo $$dversion;					\
		elif [ "x$$version" = "x-dirty" ]; then				\
			echo $$dversion$$version;				\
		else								\
			echo $$version;						\
		fi;								\
	else echo $$dversion; fi)
EMBTK_BUGURL		= "http://www.embtoolkit.org/issues/projects/embtoolkit"
EMBTK_HOMEURL		= "http://www.embtoolkit.org"
export EMBTK_BUGURL EMBTK_HOMEURL EMBTK_VERSION

EMBTK_ROOT		:= $(shell pwd)
EMBTK_DOTCONFIG 	:= $(EMBTK_ROOT)/.config
export EMBTK_ROOT EMBTK_DOTCONFIG

# SHELL used by kbuild
CONFIG_SHELL		:=							\
	$(shell									\
	if [ -x "$$BASH" ]; then						\
		echo $$BASH;							\
	else									\
		if [ -x /bin/bash ]; then echo /bin/bash; else echo sh; fi;	\
	fi)
SHELL			:= $(CONFIG_SHELL)
export SHELL CONFIG_SHELL

HOST_ARCH		:= `$(CONFIG_SHELL) $(EMBTK_ROOT)/scripts/config.guess`
HOST_BUILD		:= $(HOST_ARCH)
export HOST_ARCH HOST_BUILD

HOSTCC			:= gcc
HOSTCXX			:= g++
HOSTCFLAGS		:= -Wall
HOSTCXXFLAGS		:= -O2
export HOSTCC HOSTCXX HOSTCFLAGS HOSTCXXFLAGS

ifeq ($(V),)
Q := @
MAKEFLAGS += --no-print-directory --silent
else
Q :=
endif
export Q

-include .config

J := -j$(CONFIG_EMBTK_NUMBER_BUILD_JOBS)

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

include mk/macros.mk
include mk/target-mcu.mk
include mk/buildsystem.mk
include mk/toolchain.mk
include mk/packages.mk
include mk/rootfs.mk
include mk/help.mk

distclean: clean
	$(Q)rm -rf dl/* src/eglibc* host-tools* .config.old
