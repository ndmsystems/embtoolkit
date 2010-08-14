################################################################################
# Embtoolkit
# Copyright(C) 2010 GAYE Abdoulaye Walsimou. All rights reserved.
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
# \file         autoconf.mk
# \brief	autoconf.mk of Embtoolkit.
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         February 2010
################################################################################

AUTOCONF_VERSION := 2.67
AUTOCONF_SITE := http://ftp.gnu.org/gnu/autoconf
AUTOCONF_PACKAGE := autoconf-$(AUTOCONF_VERSION).tar.bz2
AUTOCONF_BUILD_DIR := $(TOOLS_BUILD)/autoconf-$(AUTOCONF_VERSION)
AUTOCONF_DIR := $(HOSTTOOLS)/usr

AUTOCONF := $(AUTOCONF_DIR)/bin/autoconf
AUTOHEADER := $(AUTOCONF_DIR)/bin/autoheader
AUTOM4TE := $(AUTOCONF_DIR)/bin/autom4te
AUTORECONF := $(AUTOCONF_DIR)/bin/autoreconf
AUTOSCAN := $(AUTOCONF_DIR)/bin/autoscan
AUTOUPDATE := $(AUTOCONF_DIR)/bin/autoupdate
IFNAMES := $(AUTOCONF_DIR)/bin/ifnames

export AUTOCONF AUTOHEADER AUTOM4TE AUTORECONF AUTOSCAN AUTOUPDATE IFNAMES

autoconf_install: $(AUTOCONF_BUILD_DIR)/.installed

$(AUTOCONF_BUILD_DIR)/.installed: download_autoconf \
	$(AUTOCONF_BUILD_DIR)/.decompressed $(AUTOCONF_BUILD_DIR)/.configured
	@$(MAKE) -C $(AUTOCONF_BUILD_DIR) $(J)
	$(MAKE) -C $(AUTOCONF_BUILD_DIR) install
	@touch $@

download_autoconf:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(AUTOCONF_PACKAGE) if \
	necessary...")
	@test -e $(DOWNLOAD_DIR)/$(AUTOCONF_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(AUTOCONF_PACKAGE) \
	$(AUTOCONF_SITE)/$(AUTOCONF_PACKAGE)

$(AUTOCONF_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(AUTOCONF_PACKAGE)...")
	@tar -C $(TOOLS_BUILD) -xjf $(DOWNLOAD_DIR)/$(AUTOCONF_PACKAGE)
	@mkdir -p $(AUTOCONF_BUILD_DIR)
	@mkdir -p $(AUTOCONF_DIR)
	@touch $@

$(AUTOCONF_BUILD_DIR)/.configured:
	$(call EMBTK_GENERIC_MESSAGE,"Configuring \
	autoconf_$(AUTOCONF_VERSION)...")
	@cd $(AUTOCONF_BUILD_DIR); \
	M4=$(M4_BIN) \
	$(TOOLS_BUILD)/autoconf-$(AUTOCONF_VERSION)/configure \
	--prefix=$(AUTOCONF_DIR) --build=$(HOST_BUILD) --host=$(HOST_ARCH)
	@touch $@
