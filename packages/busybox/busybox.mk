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
# \file         busybox.mk
# \brief	busybox.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         May 2009
#########################################################################################

BB_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_BB_VERSION_STRING)))
BB_DOT_CONFIG := $(subst ",,$(strip $(CONFIG_EMBTK_BB_DOT_CONFIG)))
BB_SITE := http://www.busybox.net/downloads
BB_PACKAGE := busybox-$(BB_VERSION).tar.bz2
BB_BUILD_DIR := $(PACKAGES_BUILD)/busybox-$(BB_VERSION)

busybox_install: $(BB_BUILD_DIR)/.installed

$(BB_BUILD_DIR)/.installed: download_busybox $(BB_BUILD_DIR)/.decompressed
	CFLAGS="-Os -pipe -fno-strict-aliasing" \
	$(MAKE) -C $(BB_BUILD_DIR) CROSS_COMPILE=$(TOOLS)/bin/$(STRICT_GNU_TARGET)- \
	CONFIG_PREFIX=$(ROOTFS) install
	touch $@

download_busybox:
	@test -e $(DOWNLOAD_DIR)/$(BB_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(BB_PACKAGE) $(BB_SITE)/$(BB_PACKAGE)

$(BB_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(BB_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjf $(DOWNLOAD_DIR)/$(BB_PACKAGE)
	@test -e $(BB_BUILD_DIR)/.config || \
	cp $(EMBTK_ROOT)/packages/busybox/$(BB_DOT_CONFIG) $(BB_BUILD_DIR)/.config
	@touch $@
