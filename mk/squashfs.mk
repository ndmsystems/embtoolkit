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
# \file         squashfs.mk
# \brief	squashfs.mk of Embtoolkit.
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         August 2009
################################################################################

SQUASHFS_VERSION := 4.0
SQUASHFS_SITE := http://downloads.sourceforge.net/project/squashfs/squashfs
SQUASHFS_PACKAGE := squashfs$(SQUASHFS_VERSION).tar.gz
SQUASHFS_HOST_BUILD_DIR := $(TOOLS_BUILD)/squashfs-build
SQUASHFS_TARGET_BUILD_DIR := $(PACKAGES_BUILD)/squashfs-build

squashfs_host_install: $(SQUASHFS_HOST_BUILD_DIR)/.installed
squashfs_target_install: $(SQUASHFS_TARGET_BUILD_DIR)/.installed

#squashfs for host
$(SQUASHFS_HOST_BUILD_DIR)/.installed: download_squashfs \
	$(SQUASHFS_HOST_BUILD_DIR)/.decompressed
	@CC=$(HOSTCC_CACHED) \
	$(MAKE) -C $(TOOLS_BUILD)/squashfs$(SQUASHFS_VERSION)/squashfs-tools
	@cp $(TOOLS_BUILD)/squashfs$(SQUASHFS_VERSION)/squashfs-tools/\
	mksquashfs $(HOSTTOOLS)/usr/bin/
	@cp $(TOOLS_BUILD)/squashfs$(SQUASHFS_VERSION)/squashfs-tools/\
	unsquashfs $(HOSTTOOLS)/usr/bin/
	@touch $@

$(SQUASHFS_HOST_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(SQUASHFS_PACKAGE)...")
	@tar -C $(TOOLS_BUILD) -xzvf $(DOWNLOAD_DIR)/$(SQUASHFS_PACKAGE)
	@mkdir -p $(SQUASHFS_HOST_BUILD_DIR)
	@touch $@

squashfs_host_clean:
	$(call EMBTK_GENERIC_MESSAGE,"Cleaning squashfs in host ...")

#squashfs for target
$(SQUASHFS_TARGET_BUILD_DIR)/.installed: download_squashfs \
	$(SQUASHFS_TARGET_BUILD_DIR)/.decompressed
	@touch $@

$(SQUASHFS_TARGET_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(SQUASHFS_PACKAGE)...")
	@tar -C $(PACKAGES_BUILD) -xzvf $(DOWNLOAD_DIR)/$(SQUASHFS_PACKAGE)
	@mkdir -p $(SQUASHFS_TARGET_BUILD_DIR)
	@touch $@

squashfs_target_clean:
	$(call EMBTK_GENERIC_MESSAGE,"Cleaning squashfs in target ...")

download_squashfs:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(SQUASHFS_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(SQUASHFS_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(SQUASHFS_PACKAGE) \
	$(SQUASHFS_SITE)/squashfs$(SQUASHFS_VERSION)/$(SQUASHFS_PACKAGE)

