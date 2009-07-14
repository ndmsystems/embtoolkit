################################################################################
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
################################################################################
#
# \file         packages.mk
# \brief	packages.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         May 2009
################################################################################

#Packages for target

#Busybox
ifeq ($(CONFIG_EMBTK_ROOTFS_HAVE_BB),y)
include $(EMBTK_ROOT)/packages/busybox/busybox.mk
ROOTFS_COMPONENTS += busybox_install
endif

ifeq ($(CONFIG_EMBTK_HAVE_GDB_ON_TARGET),y)
ROOTFS_COMPONENTS += gdb_target_install
endif

ifeq ($(CONFIG_EMBTK_HAVE_GDBSERVER_ON_TARGET),y)
ROOTFS_COMPONENTS += gdbserver_target_install
endif

#mtd-utils
ifeq ($(CONFIG_EMBTK_ROOTFS_HAVE_MTDUTILS),y)
ROOTFS_COMPONENTS += mtd-utils_target_install
ROOTFS_COMPONENTS_CLEAN += mtd-utils_target_clean
endif

#Packages for host

#fakeroot
ifeq ($(CONFIG_EMBTK_HAVE_ROOTFS),y)
include $(EMBTK_ROOT)/mk/fakeroot.mk
include $(EMBTK_ROOT)/mk/makedevs.mk
HOSTTOOLS_COMPONENTS := makedevs_install fakeroot_install
endif

#gdb
ifeq ($(CONFIG_EMBTK_HAVE_GDB),y)
include $(EMBTK_ROOT)/mk/termcap.mk
include $(EMBTK_ROOT)/mk/gdb.mk
ifeq ($(CONFIG_EMBTK_HAVE_GDB_ON_HOST),y)
HOSTTOOLS_COMPONENTS += gdb_host_install
endif
endif

#lzo
include $(EMBTK_ROOT)/mk/lzo.mk

#mtd-utils
ifeq ($(CONFIG_EMBTK_HAVE_ROOTFS),y)
include $(EMBTK_ROOT)/mk/mtd-utils.mk
endif

#zlib
include $(EMBTK_ROOT)/mk/zlib.mk

