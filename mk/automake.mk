################################################################################
# Embtoolkit
# Copyright(C) 2010-2011 Abdoulaye Walsimou GAYE. All rights reserved.
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
# \file         automake.mk
# \brief	automake.mk of Embtoolkit.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         February 2010
################################################################################

AUTOMAKE_NAME := automake
AUTOMAKE_VERSION := $(call EMBTK_GET_PKG_VERSION,AUTOMAKE)
AUTOMAKE_SITE := http://ftp.gnu.org/gnu/automake
AUTOMAKE_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
AUTOMAKE_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/automake/$(AUTOMAKE_VERSION)
AUTOMAKE_PACKAGE := automake-$(AUTOMAKE_VERSION).tar.bz2
AUTOMAKE_SRC_DIR := $(TOOLS_BUILD)/automake-$(AUTOMAKE_VERSION)
AUTOMAKE_BUILD_DIR := $(TOOLS_BUILD)/automake-$(AUTOMAKE_VERSION)

AUTOMAKE_DIR := $(HOSTTOOLS)/usr
ACLOCAL := $(AUTOMAKE_DIR)/bin/aclocal
AUTOMAKE := $(AUTOMAKE_DIR)/bin/automake

export ACLOCAL AUTOMAKE

automake_install: $(AUTOMAKE_BUILD_DIR)/.installed

$(AUTOMAKE_BUILD_DIR)/.installed: download_automake \
	$(AUTOMAKE_BUILD_DIR)/.decompressed $(AUTOMAKE_BUILD_DIR)/.configured
	@$(MAKE) -C $(AUTOMAKE_BUILD_DIR) $(J)
	$(MAKE) -C $(AUTOMAKE_BUILD_DIR) install
	@touch $@

download_automake:
	$(call EMBTK_DOWNLOAD_PKG,AUTOMAKE)

$(AUTOMAKE_BUILD_DIR)/.decompressed:
	$(call EMBTK_DECOMPRESS_HOSTPKG,AUTOMAKE)

$(AUTOMAKE_BUILD_DIR)/.configured:
	$(call EMBTK_GENERIC_MESSAGE,"Configuring \
	automake_$(AUTOMAKE_VERSION)...")
	@cd $(AUTOMAKE_BUILD_DIR); \
	M4=$(M4_BIN) \
	$(TOOLS_BUILD)/automake-$(AUTOMAKE_VERSION)/configure \
	--prefix=$(AUTOMAKE_DIR) --build=$(HOST_BUILD) --host=$(HOST_ARCH)
	@touch $@
