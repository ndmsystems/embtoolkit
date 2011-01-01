################################################################################
# Embtoolkit
# Copyright(C) 2010-2011 Abdoulaye Walsimou GAYE. All rights reserved.
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
# \file         automake.mk
# \brief	automake.mk of Embtoolkit.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         February 2010
################################################################################

AUTOMAKE_VERSION := 1.11.1
AUTOMAKE_SITE := http://ftp.gnu.org/gnu/automake
AUTOMAKE_PACKAGE := automake-$(AUTOMAKE_VERSION).tar.bz2
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
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(AUTOMAKE_PACKAGE) if \
	necessary...")
	@test -e $(DOWNLOAD_DIR)/$(AUTOMAKE_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(AUTOMAKE_PACKAGE) \
	$(AUTOMAKE_SITE)/$(AUTOMAKE_PACKAGE)

$(AUTOMAKE_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(AUTOMAKE_PACKAGE)...")
	@tar -C $(TOOLS_BUILD) -xjf $(DOWNLOAD_DIR)/$(AUTOMAKE_PACKAGE)
	@mkdir -p $(AUTOMAKE_BUILD_DIR)
	@mkdir -p $(AUTOMAKE_DIR)
	@touch $@

$(AUTOMAKE_BUILD_DIR)/.configured:
	$(call EMBTK_GENERIC_MESSAGE,"Configuring \
	automake_$(AUTOMAKE_VERSION)...")
	@cd $(AUTOMAKE_BUILD_DIR); \
	M4=$(M4_BIN) \
	$(TOOLS_BUILD)/automake-$(AUTOMAKE_VERSION)/configure \
	--prefix=$(AUTOMAKE_DIR) --build=$(HOST_BUILD) --host=$(HOST_ARCH)
	@touch $@
