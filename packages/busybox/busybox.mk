################################################################################
# Embtoolkit
# Copyright(C) 2009-1010 Abdoulaye Walsimou GAYE. All rights reserved.
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
# \file         busybox.mk
# \brief	busybox.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

BB_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_BB_VERSION_STRING)))
BB_DOT_CONFIG := $(subst ",,$(strip $(CONFIG_EMBTK_BB_DOT_CONFIG)))
BB_SITE := http://www.busybox.net/downloads
BB_PACKAGE := busybox-$(BB_VERSION).tar.bz2
BB_BUILD_DIR := $(PACKAGES_BUILD)/busybox-$(BB_VERSION)

busybox_install: $(BB_BUILD_DIR)/.installed

$(BB_BUILD_DIR)/.installed: download_busybox $(BB_BUILD_DIR)/.decompressed \
	$(BB_BUILD_DIR)/.Config.in.renewed
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	busybox-$(BB_VERSION) in your root filesystem...")
	@CFLAGS="$(TARGET_CFLAGS) -pipe -fno-strict-aliasing" \
	$(MAKE) -C $(BB_BUILD_DIR) \
	CROSS_COMPILE=$(TOOLS)/bin/$(STRICT_GNU_TARGET)- \
	CONFIG_PREFIX=$(ROOTFS) install
	@touch $@

download_busybox:
	@test -e $(DOWNLOAD_DIR)/$(BB_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(BB_PACKAGE) $(BB_SITE)/$(BB_PACKAGE)

$(BB_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(BB_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjf $(DOWNLOAD_DIR)/$(BB_PACKAGE)
	@test -e $(BB_BUILD_DIR)/.config || \
	cp $(EMBTK_ROOT)/packages/busybox/$(BB_DOT_CONFIG) \
	$(BB_BUILD_DIR)/.config
	@touch $@

$(BB_BUILD_DIR)/.Config.in.renewed:
	@cd $(PACKAGES_BUILD)/busybox-$(BB_VERSION); \
	sed 's|source |source $(BB_BUILD_DIR)/|' < Config.in >Config.in.tmp; \
	sed 's/networking\/Config.in/&.new/' <Config.in.tmp >Config.in.new; \
	cd networking; \
	sed 's|source networking|source $(BB_BUILD_DIR)/networking|' \
	< Config.in >Config.in.new
	touch $@

busybox_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup busybox...")
