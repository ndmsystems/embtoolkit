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
DOWNLOAD_DIR		:= $(patsubst %/,%,$(subst ",,$(strip $(CONFIG_EMBTK_DOWNLOAD_DIR))))

export SYSROOT TOOLS TOOLS_BUILD PACKAGES_BUILD EMBTK_GENERATED ROOTFS
export HOSTTOOLS DOWNLOAD_DIR

mkinitialpath:
	$(Q)mkdir -p $(SYSROOT)
	$(Q)mkdir -p $(SYSROOT)/lib
	$(Q)mkdir -p $(SYSROOT)/usr
	$(Q)mkdir -p $(SYSROOT)/usr/etc
	$(Q)mkdir -p $(SYSROOT)/root
	$(Q)mkdir -p $(SYSROOT)/usr/lib
	$(Q)$(if $(CONFIG_EMBTK_32BITS_FS),,cd $(SYSROOT);			\
		ln -sf lib lib64; cd $(SYSROOT)/usr;ln -sf lib lib64)
	$(Q)$(if $(CONFIG_EMBTK_64BITS_FS_COMPAT32),				\
		cd $(SYSROOT); ln -sf lib lib64; mkdir -p lib32;		\
		cd $(SYSROOT)/usr; ln -sf lib lib64; mkdir -p lib32)
	$(Q)mkdir -p $(TOOLS)
	$(Q)mkdir -p $(TOOLS_BUILD)
	$(Q)mkdir -p $(HOSTTOOLS)
	$(Q)mkdir -p $(HOSTTOOLS)/usr
	$(Q)mkdir -p $(HOSTTOOLS)/usr/include
	$(Q)mkdir -p $(HOSTTOOLS)/usr/local
	$(Q)$(if $(CONFIG_EMBTK_HAVE_ROOTFS),					\
		mkdir -p $(ROOTFS);						\
		cp -Rp $(EMBTK_ROOT)/src/target_skeleton/* $(ROOTFS)/;		\
		mkdir -p $(PACKAGES_BUILD))

rmallpath:
	$(Q)rm -rf $(PACKAGES_BUILD) $(ROOTFS) $(TOOLS) $(TOOLS_BUILD)
	$(Q)rm -rf $(SYSROOT) $(EMBTK_GENERATED) $(HOSTTOOLS)
	$(Q)rm -rf $(DOWNLOAD_DIR)/eglibc-*.tar.bz2
	$(Q)$(if $(CONFIG_EMBTK_CACHE_PATCHES),,rm -rf $(DOWNLOAD_DIR)/*.patch)
