################################################################################
# GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
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
# \file         libtool.mk
# \brief	libtool.mk of Embtoolkit.
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         March 2010
################################################################################

LIBTOOL_VERSION := 2.2.6b
LIBTOOL_SITE := http://ftp.gnu.org/gnu/libtool
LIBTOOL_PACKAGE := libtool-$(LIBTOOL_VERSION).tar.gz
LIBTOOL_BUILD_DIR := $(TOOLS_BUILD)/libtool-$(LIBTOOL_VERSION)
LIBTOOL_DIR := $(HOSTTOOLS)/usr/local/libtool

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
	M4=$(M4_BIN) \
	$(TOOLS_BUILD)/libtool-$(LIBTOOL_VERSION)/configure \
	--prefix=$(LIBTOOL_DIR) --build=$(HOST_BUILD) --host=$(HOST_ARCH)
	@touch $@
