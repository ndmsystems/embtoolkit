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
# \file         zlib.mk
# \brief	zlib.mk of Embtoolkit.
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         June 2009
#########################################################################################

ZLIB_VERSION := 1.2.3
ZLIB_SITE := http://www.gzip.org/zlib
ZLIB_PACKAGE := zlib-$(ZLIB_VERSION).tar.bz2
ZLIB_HOST_BUILD_DIR := $(TOOLS_BUILD)/zlib-host-build

zlib_host_install: $(ZLIB_HOST_BUILD_DIR)/.installed

#zlib on host machine
$(ZLIB_HOST_BUILD_DIR)/.installed: download_zlib $(ZLIB_HOST_BUILD_DIR)/.decompressed
	@$(MAKE) -C $(TOOLS_BUILD)/zlib-$(ZLIB_VERSION)-host
	@$(MAKE) -C $(TOOLS_BUILD)/zlib-$(ZLIB_VERSION)-host \
	prefix=$(HOSTTOOLS)/usr/local install
	@touch $@

download_zlib:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(ZLIB_PACKAGE) if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(ZLIB_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(ZLIB_PACKAGE) $(ZLIB_SITE)/$(ZLIB_PACKAGE)

$(ZLIB_HOST_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(ZLIB_PACKAGE)...")
	@tar -C $(TOOLS_BUILD) -xjf $(DOWNLOAD_DIR)/$(ZLIB_PACKAGE)
	@mv  $(TOOLS_BUILD)/zlib-$(ZLIB_VERSION) \
	$(TOOLS_BUILD)/zlib-$(ZLIB_VERSION)-host
	@mkdir -p $(ZLIB_HOST_BUILD_DIR)
	@touch $@

