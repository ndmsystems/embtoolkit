################################################################################
# EmbToolkit
# Copyright(C) 2009-2013 Abdoulaye Walsimou GAYE.
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
# \file         Makefile
# \brief	root Makefile of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################
VERSION			:= 1
PATCHLEVEL		:= 4
SUBLEVEL		:= 0
EXTRAVERSION		:=
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
EMBTK_BUGURL		= "http://bugs.embtoolkit.org/projects/embtoolkit"
EMBTK_HOMEURL		= "http://www.embtoolkit.org"
export EMBTK_BUGURL EMBTK_HOMEURL EMBTK_VERSION

EMBTK_ROOT		:= $(shell pwd)
EMBTK_DOTCONFIG 	:= $(EMBTK_ROOT)/.config

# SHELL used by kbuild
CONFIG_EMBTK_SHELL		:=						\
	$(shell									\
	if [ -x "$$BASH" ]; then						\
		echo $$BASH;							\
	else									\
		if [ -x /bin/bash ]; then					\
			echo /bin/bash;						\
		else								\
			echo /bin/sh;						\
		fi;								\
	fi)

HOST_ARCH		:= $(shell $(CONFIG_EMBTK_SHELL) $(EMBTK_ROOT)/scripts/config.guess)
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

#
# Performance hack
#
MAKEFLAGS += --no-builtin-rules --no-builtin-variables
.SUFFIXES:
	MAKEFLAGS += --no-builtin-rules --no-builtin-variables

SUFFIXES :=

%: %,v
%: RCS/%,v
%: RCS/%
%: s.%
%: SCCS/s.%

#
# Include our config if any
#
-include .config

EMBTK_BUILD := $(if $(CONFIG_EMBTK_DOTCONFIG),startbuild,xconfig)

All: $(EMBTK_BUILD)

include mk/macros.mk
include mk/targetsys.mk
include mk/target-mcu.mk
include mk/buildsystem.mk
include mk/toolchain.mk
include mk/packages.mk
include mk/rootfs.mk
include mk/help.mk
