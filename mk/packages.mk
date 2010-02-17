################################################################################
# GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# Copyright(C) 2009-2010 GAYE Abdoulaye Walsimou. All rights reserved.
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

ROOTFS_COMPONENTS-y :=
HOSTTOOLS_COMPONENTS-y :=
################################################################################
#################### Common include for target and host ########################
################################################################################

include $(EMBTK_ROOT)/mk/zlib.mk
include $(EMBTK_ROOT)/mk/lzo.mk
include $(EMBTK_ROOT)/mk/mtd-utils.mk
include $(EMBTK_ROOT)/mk/termcap.mk

#gdb
ifeq ($(CONFIG_EMBTK_HAVE_GDB),y)
include $(EMBTK_ROOT)/mk/gdb.mk
endif

################################################################################
############################# Packages for TARGET ##############################
################################################################################

#gdb
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_GDB_ON_TARGET) += gdb_target_install

#gdbserver
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_GDBSERVER_ON_TARGET) += gdbserver_target_install

#strace
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_ROOTFS_HAVE_STRACE) += strace_install
include $(EMBTK_ROOT)/mk/strace.mk

# Flash manipulation tools: mtd-utils
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_ROOTFS_HAVE_MTDUTILS) += mtd-utils_target_install
ROOTFS_COMPONENTS_CLEAN += mtd-utils_target_clean

#Compression packages

# Graphics packages
include $(EMBTK_ROOT)/packages/graphics/graphics.mk

# Networking packages

# Scripting languages
include $(EMBTK_ROOT)/packages/scripting-languages/scripting-languages.mk

# Security packages
include $(EMBTK_ROOT)/packages/security/security.mk

# System packages

# Miscellaneous packages
include $(EMBTK_ROOT)/packages/misc/misc.mk

#Busybox
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_ROOTFS_HAVE_BB) += busybox_install
include $(EMBTK_ROOT)/packages/busybox/busybox.mk
ROOTFS_COMPONENTS += busybox_install

################################################################################
########################## Packages for HOST MACHINE ###########################
################################################################################

#gdb
HOSTTOOLS_COMPONENTS-$(CONFIG_EMBTK_HAVE_GDB_ON_HOST) += gdb_host_install

################################################################################
########################### Targets for HOST MACHINE ###########################
################################################################################
host_packages_build:
ifeq ($(HOSTTOOLS_COMPONENTS-y),)
else
	$(call EMBTK_GENERIC_MESSAGE,"Building extra packages intended to run \
	on your host machine ...")
	@$(MAKE) $(HOSTTOOLS_COMPONENTS-y)
endif

