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
# \file         ccache.mk
# \brief	ccache.mk of Embtoolkit. Here we install ccache to speed up recompilation
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         May 2009
#########################################################################################

CCACHE_VERSION := 2.4
CCACHE_SITE := http://samba.org/ftp/ccache
CCACHE_PACKAGE := ccache-$(CCACHE_VERSION).tar.gz
CCACHE_HOST_BUILD_DIR := $(TOOLS_BUILD)/ccachehost-build
CCACHE_HOST_DIR := $(EMBTK_ROOT)/ccachehost

CCACHE_DIR := $(CCACHE_HOST_DIR)
HOSTCC_CACHED := "$(CCACHE_HOST_DIR)/bin/ccache $(HOSTCC)"
HOSTCXX_CACHED := "$(CCACHE_HOST_DIR)/bin/ccache $(HOSTCXX)"
TARGETCC_CACHED := "$(CCACHE_HOST_DIR)/bin/ccache $(TARGETCC)"
TARGETCXX_CACHED := "$(CCACHE_HOST_DIR)/bin/ccache $(TARGETCXX)"

export CCACHE_DIR HOSTCC_CACHED HOSTCXX_CACHED TARGETCC_CACHED TARGETCXX_CACHED

ccachehost_install: $(CCACHE_HOST_BUILD_DIR)/.installed

$(CCACHE_HOST_BUILD_DIR)/.installed: ccache_download \
	$(CCACHE_HOST_BUILD_DIR)/.decompressed \
	$(CCACHE_HOST_BUILD_DIR)/.configured
	$(MAKE) -C $(CCACHE_HOST_BUILD_DIR) && \
	$(MAKE) -C $(CCACHE_HOST_BUILD_DIR) install
	@touch $@

ccache_download:
	@test -e $(DOWNLOAD_DIR)/$(CCACHE_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(CCACHE_PACKAGE) \
	$(CCACHE_SITE)/$(CCACHE_PACKAGE)

$(CCACHE_HOST_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(CCACHE_PACKAGE) ...")
	@tar -C $(TOOLS_BUILD) -xzf $(DOWNLOAD_DIR)/$(CCACHE_PACKAGE)
	@mkdir -p $(CCACHE_HOST_BUILD_DIR)
	@touch $@

$(CCACHE_HOST_BUILD_DIR)/.configured:
	$(call EMBTK_GENERIC_MESSAGE,"Configure ccache-$(CCACHE_VERSION) ...")
	cd $(CCACHE_HOST_BUILD_DIR) ; \
	$(TOOLS_BUILD)/ccache-$(CCACHE_VERSION)/configure \
	--prefix=$(CCACHE_HOST_DIR) \
	--build=$(HOST_BUILD) --host=$(HOST_ARCH)
	@touch $@
