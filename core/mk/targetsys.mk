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
# \file         targetsys.mk
# \brief	This file defines system environment of the target
# \brief	(os, clib, etc.).
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         October 2012
################################################################################

#
# Target machine info
#
embtk_os-$(CONFIG_EMBTK_OS_LINUX)	:= linux
embtk_os				:= $(or $(embtk_os-y),invalid-os)

embtk_clib-$(CONFIG_EMBTK_CLIB_EGLIBC)	:= eglibc
embtk_clib-$(CONFIG_EMBTK_CLIB_GLIBC)	:= glibc
embtk_clib-$(CONFIG_EMBTK_CLIB_MUSL)	:= musl
embtk_clib-$(CONFIG_EMBTK_CLIB_UCLIBC)	:= uclibc
embtk_clib				:= $(or $(embtk_clib-y),invalid-clib)
embtk_clib_version			:= $(call embtk_get_pkgversion,$(embtk_clib))
