#########################################################################################
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
#########################################################################################
#
# \file         initialpath.mk
# \brief	initialpath of Embtoolkit. Here we define SYSROOT, TOOLS, TOOLS_BUILD
# \brief	PACKAGES_BUILD and ROOTFS.
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         May 2009
#########################################################################################

SYSROOT := $(EMBTK_ROOT)/sysroot-$(GNU_TARGET)-$(GNU_TARGET_ARCH)
TOOLS := $(EMBTK_ROOT)/tools-$(GNU_TARGET)-$(GNU_TARGET_ARCH)
TOOLS_BUILD := $(EMBTK_ROOT)/tools_build-$(GNU_TARGET)-$(GNU_TARGET_ARCH)
PACKAGES_BUILD := $(EMBTK_ROOT)/packages_build-$(GNU_TARGET)-$(GNU_TARGET_ARCH)
ROOTFS := $(EMBTK_ROOT)/rootfs-$(GNU_TARGET)-$(GNU_TARGET_ARCH)

export SYSROOT TOOLS TOOLS_BUILD PACKAGES_BUILD ROOTFS

mkinitialpath:
	@mkdir -p $(SYSROOT)
	@cp -Rp $(EMBTK_ROOT)/src/target_skeleton/* $(SYSROOT)/
	@mkdir -p $(ROOTFS)
	@cp -Rp $(EMBTK_ROOT)/src/target_skeleton/* $(ROOTFS)/
	@mkdir -p $(TOOLS)
	@mkdir -p $(TOOLS_BUILD)
	@mkdir -p $(PACKAGES_BUILD)

rmallpath:
	@rm -Rf $(SYSROOT) $(TOOLS) $(TOOLS_BUILD) $(PACKAGES_BUILD) $(ROOTFS)

