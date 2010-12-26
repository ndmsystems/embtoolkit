################################################################################
# Embtoolkit
# Copyright(C) 2009-2010 Abdoulaye Walsimou GAYE. All rights reserved.
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
# \file         squashfs.mk
# \brief	squashfs.mk of Embtoolkit.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         August 2009
################################################################################

SQUASHFS_VERSION := 4.0
SQUASHFS_SITE := http://downloads.sourceforge.net/project/squashfs/squashfs
SQUASHFS_PACKAGE := squashfs$(SQUASHFS_VERSION).tar.gz
SQUASHFS_HOST_BUILD_DIR := $(TOOLS_BUILD)/squashfs-build
SQUASHFS_TARGET_BUILD_DIR := $(PACKAGES_BUILD)/squashfs-build

squashfs_host_install:
	@test -e $(SQUASHFS_HOST_BUILD_DIR)/.installed || \
	$(MAKE) $(SQUASHFS_HOST_BUILD_DIR)/.installed

squashfs_target_install: $(SQUASHFS_TARGET_BUILD_DIR)/.installed

#squashfs for host
$(SQUASHFS_HOST_BUILD_DIR)/.installed: download_squashfs \
	$(SQUASHFS_HOST_BUILD_DIR)/.decompressed
	@CC=$(HOSTCC_CACHED) \
	$(MAKE) -C $(TOOLS_BUILD)/squashfs$(SQUASHFS_VERSION)/squashfs-tools
	test -z $(HOSTTOOLS)/usr/bin || mkdir -p $(HOSTTOOLS)/usr/bin
	@install $(TOOLS_BUILD)/squashfs$(SQUASHFS_VERSION)/squashfs-tools/\
	mksquashfs $(HOSTTOOLS)/usr/bin/
	@install $(TOOLS_BUILD)/squashfs$(SQUASHFS_VERSION)/squashfs-tools/\
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

