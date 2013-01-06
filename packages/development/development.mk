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
# \file         misc.mk
# \brief	misc.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         February 2010
################################################################################

#libevent
include packages/development/libbsd/libbsd.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBBSD) += libbsd_install

#libevent
include packages/development/libevent/libevent.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBEVENT) += libevent_install

#libnih
include packages/development/libnih/libnih.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBNIH) += libnih_install

#libsigsegv
include packages/development/libsigsegv/libsigsegv.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBSIGSEGV) += libsigsegv_install

# libunwind
include packages/development/libunwind/libunwind.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBUNWIND) += libunwind_install
