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
# \file         initialpath.mk
# \brief	initialpath of Embtoolkit. Here we define SYSROOT, TOOLS,
# \brief	TOOLS_BUILD PACKAGES_BUILD and ROOTFS.
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         May 2009
################################################################################

SYSROOT:=$(EMBTK_ROOT)/sysroot-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)
TOOLS:=$(EMBTK_ROOT)/tools-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)
TOOLS_BUILD:=$(EMBTK_ROOT)/build/tools_build-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)
PACKAGES_BUILD:=$(EMBTK_ROOT)/build/packages_build-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)
ROOTFS:=$(EMBTK_ROOT)/rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)
HOSTTOOLS :=$(EMBTK_ROOT)/host-tools-$(EMBTK_MCU_FLAG)
DOWNLOAD_DIR := $(subst ",,$(strip $(CONFIG_EMBTK_DOWNLOAD_DIR)))

export SYSROOT TOOLS TOOLS_BUILD PACKAGES_BUILD ROOTFS HOSTTOOLS DOWNLOAD_DIR

mkinitialpath:
	@mkdir -p $(SYSROOT)
	@mkdir -p $(SYSROOT)/lib
	@mkdir -p $(SYSROOT)/usr
	@mkdir -p $(SYSROOT)/root
	@mkdir -p $(SYSROOT)/usr/lib
ifeq ($(CONFIG_EMBTK_64BITS_FS),y)
	@cd $(SYSROOT); \
	ln -s lib lib64
	@cd $(SYSROOT)/usr; \
	ln -s lib lib64
endif
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	@cd $(SYSROOT); \
	ln -s lib lib64; \
	mkdir -p lib32
	@cd $(SYSROOT)/usr; \
	ln -s lib lib64; \
	mkdir -p lib32
endif
	@mkdir -p $(TOOLS)
	@mkdir -p $(TOOLS_BUILD)
	@mkdir -p $(HOSTTOOLS)
	@mkdir -p $(HOSTTOOLS)/usr/
	@mkdir -p $(HOSTTOOLS)/usr/include
	@mkdir -p $(HOSTTOOLS)/usr/local
ifeq ($(CONFIG_EMBTK_HAVE_ROOTFS),y)
	@mkdir -p $(ROOTFS)
	@cp -Rp $(EMBTK_ROOT)/src/target_skeleton/* $(ROOTFS)/
	@mkdir -p $(PACKAGES_BUILD)
endif

rmallpath:
	@rm -Rf $(PACKAGES_BUILD) $(ROOTFS) $(TOOLS) $(TOOLS_BUILD) $(SYSROOT)
	@rm -Rf rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)*
	@rm -Rf initramfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)*
ifneq ($(CONFIG_EMBTK_CACHE_PATCHES),y)
	@rm -rf $(DOWNLOAD_DIR)/*.patch
endif
	@rm -rf $(DOWNLOAD_DIR)/eglibc-*

