################################################################################
# Embtoolkit
# Copyright(C) 2009-2011 Abdoulaye Walsimou GAYE.
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
# \file         initialpath.mk
# \brief	initialpath of Embtoolkit. Here we define SYSROOT, TOOLS,
# \brief	TOOLS_BUILD PACKAGES_BUILD and ROOTFS.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

SYSROOT			:= $(EMBTK_ROOT)/sysroot-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)
TOOLS			:= $(EMBTK_ROOT)/tools-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)
TOOLS_BUILD		:= $(EMBTK_ROOT)/build/tools_build-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)
PACKAGES_BUILD		:= $(EMBTK_ROOT)/build/packages_build-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)
EMBTK_GENERATED 	:= $(EMBTK_ROOT)/generated
ROOTFS			:= $(EMBTK_GENERATED)/rootfs-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)
HOSTTOOLS		:= $(EMBTK_ROOT)/host-tools-$(EMBTK_MCU_FLAG)
DOWNLOAD_DIR		:= $(subst ",,$(strip $(CONFIG_EMBTK_DOWNLOAD_DIR)))

export SYSROOT TOOLS TOOLS_BUILD PACKAGES_BUILD EMBTK_GENERATED ROOTFS
export HOSTTOOLS DOWNLOAD_DIR

mkinitialpath:
	@mkdir -p $(SYSROOT)
	@mkdir -p $(SYSROOT)/lib
	@mkdir -p $(SYSROOT)/usr
	@mkdir -p $(SYSROOT)/usr/etc
	@mkdir -p $(SYSROOT)/root
	@mkdir -p $(SYSROOT)/usr/lib
ifeq ($(CONFIG_EMBTK_64BITS_FS),y)
	@-cd $(SYSROOT); \
	ln -s lib lib64
	@-cd $(SYSROOT)/usr; \
	ln -s lib lib64
endif
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	@-cd $(SYSROOT); \
	ln -s lib lib64; \
	mkdir -p lib32
	@-cd $(SYSROOT)/usr; \
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
	@rm -Rf $(EMBTK_GENERATED) $(HOSTTOOLS)
ifneq ($(CONFIG_EMBTK_CACHE_PATCHES),y)
	@rm -rf $(DOWNLOAD_DIR)/*.patch
endif
	@rm -rf $(DOWNLOAD_DIR)/eglibc-*.tar.bz2

