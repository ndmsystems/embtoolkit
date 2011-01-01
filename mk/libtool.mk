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
# \file         libtool.mk
# \brief	libtool.mk of Embtoolkit.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

LIBTOOL_VERSION := 2.4
LIBTOOL_SITE := http://ftp.gnu.org/gnu/libtool
LIBTOOL_PACKAGE := libtool-$(LIBTOOL_VERSION).tar.gz
LIBTOOL_BUILD_DIR := $(TOOLS_BUILD)/libtool-$(LIBTOOL_VERSION)
LIBTOOL_DIR := $(HOSTTOOLS)/usr

LIBTOOL := $(LIBTOOL_DIR)/bin/libtool
LIBTOOLIZE := $(LIBTOOL_DIR)/bin/libtoolize

export LIBTOOL LIBTOOLIZE

libtool_install: $(LIBTOOL_BUILD_DIR)/.installed

$(LIBTOOL_BUILD_DIR)/.installed: download_libtool \
	$(LIBTOOL_BUILD_DIR)/.decompressed $(LIBTOOL_BUILD_DIR)/.configured
	@$(MAKE) -C $(LIBTOOL_BUILD_DIR) $(J)
	$(MAKE) -C $(LIBTOOL_BUILD_DIR) install
	@touch $@

download_libtool:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(LIBTOOL_PACKAGE) if \
	necessary...")
	@test -e $(DOWNLOAD_DIR)/$(LIBTOOL_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(LIBTOOL_PACKAGE) \
	$(LIBTOOL_SITE)/$(LIBTOOL_PACKAGE)

$(LIBTOOL_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LIBTOOL_PACKAGE)...")
	@tar -C $(TOOLS_BUILD) -xzf $(DOWNLOAD_DIR)/$(LIBTOOL_PACKAGE)
	@mkdir -p $(LIBTOOL_BUILD_DIR)
	@mkdir -p $(LIBTOOL_DIR)
	@touch $@

$(LIBTOOL_BUILD_DIR)/.configured:
	$(call EMBTK_GENERIC_MESSAGE,"Configuring \
	libtool_$(LIBTOOL_VERSION)...")
	@cd $(LIBTOOL_BUILD_DIR); \
	$(TOOLS_BUILD)/libtool-$(LIBTOOL_VERSION)/configure \
	--prefix=$(LIBTOOL_DIR) --build=$(HOST_BUILD) --host=$(HOST_ARCH)
	@touch $@
