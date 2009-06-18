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
# \file         lzo.mk
# \brief	lzo.mk of Embtoolkit.
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         June 2009
#########################################################################################

LZO_VERSION := 2.03
LZO_SITE := http://www.oberhumer.com/opensource/lzo/download
LZO_PACKAGE := lzo-$(LZO_VERSION).tar.gz
LZO_BUILD_DIR := $(TOOLS_BUILD)/lzo-build

lzo_install: $(LZO_BUILD_DIR)/.installed

$(LZO_BUILD_DIR)/.installed: download_lzo $(LZO_BUILD_DIR)/.decompressed \
	$(LZO_BUILD_DIR)/.configured
	$(MAKE) -C $(LZO_BUILD_DIR) && $(MAKE) -C $(LZO_BUILD_DIR) install
	@touch $@

download_lzo:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(LZO_PACKAGE) if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(LZO_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(LZO_PACKAGE) $(LZO_SITE)/$(LZO_PACKAGE)

$(LZO_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LZO_PACKAGE)...")
	@tar -C $(TOOLS_BUILD) -xzf $(DOWNLOAD_DIR)/$(LZO_PACKAGE)
	@mkdir -p $(LZO_BUILD_DIR)
	@touch $@

$(LZO_BUILD_DIR)/.configured:
	$(call EMBTK_GENERIC_MESSAGE,"Configuring lzo-$(LZO_VERSION)...")
	@cd $(LZO_BUILD_DIR); \
	$(TOOLS_BUILD)/lzo-$(LZO_VERSION)/configure \
	--prefix=$(HOSTTOOLS)/usr/local --build=$(HOST_BUILD) --host=$(HOST_ARCH)
	@touch $@

