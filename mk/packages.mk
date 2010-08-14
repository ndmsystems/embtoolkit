################################################################################
# Embtoolkit
# Copyright(C) 2009-2010 Abdoulaye Walsimou GAYE. All rights reserved.
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
# \file         packages.kconfig
# \brief	packages.kconfig of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
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
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_ROOTFS_HAVE_MTDUTILS) += mtdutils_target_install
ROOTFS_COMPONENTS_CLEAN += mtdutils_target_clean

#Compression packages
ROOTFS_COMPONENTS_CLEAN += zlib_target_clean

# Graphics packages
include $(EMBTK_ROOT)/packages/graphics/graphics.mk

# Networking packages

# Scripting languages
include $(EMBTK_ROOT)/packages/scripting-languages/scripting-languages.mk

# Security packages
include $(EMBTK_ROOT)/packages/security/security.mk

# System packages
include $(EMBTK_ROOT)/packages/system/system.mk

#X window system packages
include $(EMBTK_ROOT)/packages/x11/x11.mk

# Miscellaneous packages
include $(EMBTK_ROOT)/packages/misc/misc.mk

#Busybox
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_ROOTFS_HAVE_BB) += busybox_install
include $(EMBTK_ROOT)/packages/busybox/busybox.mk

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

