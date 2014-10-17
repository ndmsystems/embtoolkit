################################################################################
# Embtoolkit
# Copyright(C) 2009-2014 Abdoulaye Walsimou GAYE <awg@embtoolkit.org>.
#
# This program is free software; you can distribute it and/or modify it
# under the terms of the GNU General Public License
# (Version 2 or later) published by the Free Software Foundation.
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
# \file         host-support.mk
# \brief	Host support
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         October 2014
################################################################################

#
# Host development machine info
#

CONFIG_EMBTK_SHELL	:= /bin/sh
HOST_ARCH		:= $(shell $(CONFIG_EMBTK_SHELL) $(EMBTK_ROOT)/scripts/config.guess)
HOST_BUILD		:= $(HOST_ARCH)
export HOST_ARCH HOST_BUILD

ifeq ($(findstring linux,$(HOST_ARCH)),linux)
embtk_buildhost_os	:= linux
embtk_buildhost_os_type	:= linux
else ifeq ($(findstring freebsd,$(HOST_ARCH)),freebsd)
embtk_buildhost_os	:= freebsd
embtk_buildhost_os_type	:= bsd
else ifeq ($(findstring netbsd,$(HOST_ARCH)),netbsd)
embtk_buildhost_os	:= netbsd
embtk_buildhost_os_type	:= bsd
else ifeq ($(findstring openbsd,$(HOST_ARCH)),openbsd)
embtk_buildhost_os	:= openbsd
embtk_buildhost_os_type	:= bsd
else ifeq ($(findstring apple,$(HOST_ARCH)),apple)
embtk_buildhost_os	:= macos
embtk_buildhost_os_type	:= bsd
else
embtk_buildhost_os	:= unknown-host-os
endif

HOSTCC			:=							\
	$(shell									\
	if [ -n "$$(command -v gcc 2>/dev/null)" ]; then			\
		echo "$$(command -v gcc)";					\
	elif [ -n "$$(command -v cc 2>/dev/null)" ]; then			\
		echo "$$(command -v cc)";					\
	else									\
		echo gcc;							\
	fi)

HOSTCXX			:=							\
	$(shell									\
	if [ -n "$$(command -v g++ 2>/dev/null)" ]; then			\
		echo "$$(command -v g++)";					\
	elif [ -n "$$(command -v c++ 2>/dev/null)" ]; then			\
		echo "$$(command -v c++)";					\
	else									\
		echo g++;							\
	fi)

HOSTCFLAGS		:= -Wall -O2
HOSTCXXFLAGS		:= -Wall -O2
HOSTLDFLAGS		:=

ifeq ($(embtk_buildhost_os),macos)
HOSTCFLAGS		+= -I/opt/local/include
HOSTLDFLAGS		+= -L/opt/local/lib
endif
HOSTCXXFLAGS		:= $(HOSTCFLAGS)

export HOSTCC HOSTCXX HOSTCFLAGS HOSTCXXFLAGS HOSTLDFLAGS
