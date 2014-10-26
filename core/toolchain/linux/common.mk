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
# \file         linux.mk
# \brief	common variables and macros for linux kernel
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

pembtk_linux_site        = $(or $(pembtk_linux_site_mirror),$(pembtk_linux_site_full))
pembtk_linux_site_mirror = $(call embtk_uquote,$(CONFIG_EMBTK_LINUX_HAVE_MIRROR))
pembtk_linux_site_full   = $(pembtk_linux_site_base)/$(LINUX_MAJORV)$(pembtk_linux_longterm_v)
pembtk_linux_site_base   = http://ftp.kernel.org/pub/linux/kernel
pembtk_linux_longterm_v  = $(if $(LINUX_LONGTERMV),/longterm/$(LINUX_LONGTERMV))

LINUX_NAME	:= linux
LINUX_MAJORV	:= $(call embtk_pkg_version,linux_major)
LINUX_LONGTERMV	:= $(call embtk_pkg_version,linux_longterm)
LINUX_VERSION	:= $(call embtk_pkg_version,linux)
LINUX_SITE	:= $(pembtk_linux_site)
LINUX_PACKAGE	:= linux-$(LINUX_VERSION).tar.xz
LINUX_SRC_DIR	:= $(embtk_toolsb)/linux-$(LINUX_VERSION)
LINUX_BUILD_DIR	:= $(embtk_toolsb)/linux-$(LINUX_VERSION)
LINUX_KEEP_SRC_DIR := $(CONFIG_EMBTK_BUILD_LINUX_KERNEL)

#
# common make options
#
LINUX_MAKE_OPTS	:= quiet=quiet_
LINUX_MAKE_OPTS	+= ARCH=$(LINUX_ARCH)
LINUX_MAKE_OPTS	+= CROSS_COMPILE=$(CROSS_COMPILE_CACHED)
LINUX_MAKE_OPTS	+= HOSTCC="$(HOSTCC)"
LINUX_MAKE_OPTS	+= HOSTCXX="$(HOSTCXX)"
LINUX_MAKE_OPTS	+= HOSTCFLAGS="$(HOSTCFLAGS)"
LINUX_MAKE_OPTS	+= HOSTCXXFLAGS="$(HOSTCXXFLAGS)"