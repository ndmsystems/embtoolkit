################################################################################
# Embtoolkit
# Copyright(C) 2010 Abdoulaye Walsimou GAYE. All rights reserved.
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
# \file         m4.mk
# \brief	m4.mk of Embtoolkit.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         February 2010
################################################################################

M4_VERSION := 1.4.15
M4_SITE := http://ftp.gnu.org/gnu/m4
M4_PACKAGE := m4-$(M4_VERSION).tar.bz2
M4_BUILD_DIR := $(TOOLS_BUILD)/m4-$(M4_VERSION)
M4_DIR := $(HOSTTOOLS)/usr
M4_BIN := $(M4_DIR)/bin/m4

M4 := $(M4_BIN)
export M4

m4_install: $(M4_BUILD_DIR)/.installed

$(M4_BUILD_DIR)/.installed: download_m4 \
	$(M4_BUILD_DIR)/.decompressed $(M4_BUILD_DIR)/.configured
	@$(MAKE) -C $(M4_BUILD_DIR) $(J)
	$(MAKE) -C $(M4_BUILD_DIR) install
	@touch $@

download_m4:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(M4_PACKAGE) if \
	necessary...")
	@test -e $(DOWNLOAD_DIR)/$(M4_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(M4_PACKAGE) \
	$(M4_SITE)/$(M4_PACKAGE)

$(M4_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(M4_PACKAGE)...")
	@tar -C $(TOOLS_BUILD) -xjf $(DOWNLOAD_DIR)/$(M4_PACKAGE)
	@mkdir -p $(M4_BUILD_DIR)
	@mkdir -p $(M4_DIR)
	@touch $@

$(M4_BUILD_DIR)/.configured:
	$(call EMBTK_GENERIC_MESSAGE,"Configuring \
	m4_$(M4_VERSION)...")
	@cd $(M4_BUILD_DIR); \
	$(TOOLS_BUILD)/m4-$(M4_VERSION)/configure \
	--prefix=$(M4_DIR) --build=$(HOST_BUILD) --host=$(HOST_ARCH)
	@touch $@
