################################################################################
# Embtoolkit
# Copyright(C) 2009-2011 Abdoulaye Walsimou GAYE. All rights reserved.
#
# This program is free software; you can distribute it and/or modify it
##
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
# \file         ccache.mk
# \brief	ccache.mk of Embtoolkit. Here we install ccache to speed up
# \brief	recompilation.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

CCACHE_VERSION := 3.1.3
CCACHE_SITE := http://samba.org/ftp/ccache
CCACHE_PACKAGE := ccache-$(CCACHE_VERSION).tar.bz2
CCACHE_HOST_BUILD_DIR := $(TOOLS_BUILD)/ccachehost-build
CCACHE_HOST_DIR := $(HOSTTOOLS)/usr/local/ccachehost

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
	$(MAKE) -C $(CCACHE_HOST_BUILD_DIR) $(J)
	$(MAKE) -C $(CCACHE_HOST_BUILD_DIR) install
	@touch $@

ccache_download:
	@test -e $(DOWNLOAD_DIR)/$(CCACHE_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(CCACHE_PACKAGE) \
	$(CCACHE_SITE)/$(CCACHE_PACKAGE)

$(CCACHE_HOST_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(CCACHE_PACKAGE) ...")
	@tar -C $(TOOLS_BUILD) -xjf $(DOWNLOAD_DIR)/$(CCACHE_PACKAGE)
	@mkdir -p $(CCACHE_HOST_BUILD_DIR)
	@touch $@

$(CCACHE_HOST_BUILD_DIR)/.configured:
	$(call EMBTK_GENERIC_MESSAGE,"Configure ccache-$(CCACHE_VERSION) ...")
	cd $(CCACHE_HOST_BUILD_DIR) ; \
	$(TOOLS_BUILD)/ccache-$(CCACHE_VERSION)/configure \
	--prefix=$(CCACHE_HOST_DIR) \
	--build=$(HOST_BUILD) --host=$(HOST_ARCH)
	@touch $@
