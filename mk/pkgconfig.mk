################################################################################
# Abdoulaye Walsimou GAYE, <awg@embtoolkit.org>
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
# \file         pkgconfig.mk
# \brief	pkgconfig.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE, <awg@embtoolkit.org>
# \date         October 2009
################################################################################

PKGCONFIG_VERSION := 0.25
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

pkgconfig_install:
	@test -e $(PKGCONFIG_BUILD_DIR)/.installed || \
	$(MAKE) $(PKGCONFIG_BUILD_DIR)/.installed

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

