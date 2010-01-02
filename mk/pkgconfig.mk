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
# \file         pkgconfig.mk
# \brief	pkgconfig.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         October 2009
################################################################################

PKGCONFIG_VERSION := 0.23
PKGCONFIG_SITE := http://pkgconfig.freedesktop.org/releases
PKGCONFIG_PACKAGE := pkg-config-$(PKGCONFIG_VERSION).tar.gz
PKGCONFIG_BUILD_DIR := $(TOOLS_BUILD)/pkg-config-$(PKGCONFIG_VERSION)
PKGCONFIG_DIR := $(HOSTTOOLS)/usr/local/pkg-config
PKGCONFIG_BIN := $(PKGCONFIG_DIR)/bin/pkg-config

export PKGCONFIG_BIN

ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
PKG_CONFIG_PATH=$(SYSROOT)/usr/lib32/pkgconfig
else
PKG_CONFIG_PATH=$(SYSROOT)/usr/lib/pkgconfig
endif

export PKG_CONFIG_PATH

pkgconfig_install: $(PKGCONFIG_BUILD_DIR)/.installed

$(PKGCONFIG_BUILD_DIR)/.installed: download_pkgconfig \
	$(PKGCONFIG_BUILD_DIR)/.decompressed $(PKGCONFIG_BUILD_DIR)/.configured
	@$(MAKE) -C $(PKGCONFIG_BUILD_DIR) $(J)
	@$(MAKE) -C $(PKGCONFIG_BUILD_DIR) install
	@touch $@

download_pkgconfig:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(PKGCONFIG_PACKAGE) if \
	necessary...")
	@test -e $(DOWNLOAD_DIR)/$(PKGCONFIG_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(PKGCONFIG_PACKAGE) \
	$(PKGCONFIG_SITE)/$(PKGCONFIG_PACKAGE)

$(PKGCONFIG_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(PKGCONFIG_PACKAGE)...")
	@tar -C $(TOOLS_BUILD) -xzf $(DOWNLOAD_DIR)/$(PKGCONFIG_PACKAGE)
	@touch $@

$(PKGCONFIG_BUILD_DIR)/.configured:
	$(call EMBTK_GENERIC_MESSAGE,"Configuring \
	pkg-config-$(PKGCONFIG_VERSION)...")
	@cd $(PKGCONFIG_BUILD_DIR); \
	./configure \
	--prefix=$(PKGCONFIG_DIR) --build=$(HOST_BUILD) --host=$(HOST_ARCH)
	@touch $@

