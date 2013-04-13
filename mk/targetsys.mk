################################################################################
# Embtoolkit
# Copyright(C) 2012 Abdoulaye Walsimou GAYE <awg@embtoolkit.org>.
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
# \file         targetsys.mk
# \brief	This file defines system environment of the target
# \brief	(os, clib, etc.).
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         October 2012
################################################################################

embtk_os-$(CONFIG_EMBTK_OS_LINUX)	:= linux
embtk_os				:= $(or $(embtk_os-y),invalid-os)

embtk_clib-$(CONFIG_EMBTK_CLIB_EGLIBC)	:= eglibc
embtk_clib-$(CONFIG_EMBTK_CLIB_UCLIBC)	:= uclibc
embtk_clib				:= $(or $(embtk_clib-y),invalid-clib)
embtk_clib_version			:= $(call embtk_get_pkgversion,$(embtk_clib))

#
# Host development machine info
#
ifeq ($(findstring linux,$(HOST_ARCH)),linux)
embtk_buildhost_os			:= linux
embtk_buildhost_os_type			:= linux
else ifeq ($(findstring freebsd,$(HOST_ARCH)),freebsd)
embtk_buildhost_os			:= freebsd
embtk_buildhost_os_type			:= bsd
else ifeq ($(findstring netbsd,$(HOST_ARCH)),netbsd)
embtk_buildhost_os			:= netbsd
embtk_buildhost_os_type			:= bsd
else ifeq ($(findstring openbsd,$(HOST_ARCH)),openbsd)
embtk_buildhost_os			:= openbsd
embtk_buildhost_os_type			:= bsd
else
embtk_buildhost_os			:= unknown-host-os
endif
