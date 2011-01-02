################################################################################
# Embtoolkit
# Copyright(C) 2009-2011 Abdoulaye Walsimou GAYE. All rights reserved.
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
# \file         lzo.mk
# \brief	lzo.mk of Embtoolkit.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         June 2009
################################################################################

LZO_VERSION := 2.03
LZO_SITE := http://www.oberhumer.com/opensource/lzo/download
LZO_PACKAGE := lzo-$(LZO_VERSION).tar.gz
LZO_HOST_BUILD_DIR := $(TOOLS_BUILD)/lzo-build-host
LZO_TARGET_BUILD_DIR := $(PACKAGES_BUILD)/lzo-build-target

lzo_host_install: $(LZO_HOST_BUILD_DIR)/.installed
lzo_target_install: $(LZO_TARGET_BUILD_DIR)/.installed

#lzo host machine
$(LZO_HOST_BUILD_DIR)/.installed: download_lzo \
$(LZO_HOST_BUILD_DIR)/.decompressed \
	$(LZO_HOST_BUILD_DIR)/.configured
	$(MAKE) -C $(LZO_HOST_BUILD_DIR) $(J)
	$(MAKE) -C $(LZO_HOST_BUILD_DIR) install
	@touch $@

$(LZO_HOST_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LZO_PACKAGE)...")
	@tar -C $(TOOLS_BUILD) -xzf $(DOWNLOAD_DIR)/$(LZO_PACKAGE)
	@mkdir -p $(LZO_HOST_BUILD_DIR)
	@touch $@

$(LZO_HOST_BUILD_DIR)/.configured:
	$(call EMBTK_GENERIC_MESSAGE,"Configuring lzo-$(LZO_VERSION)...")
	@cd $(LZO_HOST_BUILD_DIR); CC=$(HOSTCC_CACHED) CXX=$(HOSTCXX_CACHED) \
	$(TOOLS_BUILD)/lzo-$(LZO_VERSION)/configure \
	--prefix=$(HOSTTOOLS)/usr/local --build=$(HOST_BUILD) \
	--host=$(HOST_ARCH)
	@touch $@

#lzo target machine
$(LZO_TARGET_BUILD_DIR)/.installed: download_lzo \
$(LZO_TARGET_BUILD_DIR)/.decompressed \
	$(LZO_TARGET_BUILD_DIR)/.configured
	$(MAKE) -C $(LZO_TARGET_BUILD_DIR) $(J)
	$(MAKE) -C $(LZO_TARGET_BUILD_DIR) install
	@touch $@

$(LZO_TARGET_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LZO_PACKAGE)...")
	@tar -C $(PACKAGES_BUILD) -xzf $(DOWNLOAD_DIR)/$(LZO_PACKAGE)
	@mkdir -p $(LZO_TARGET_BUILD_DIR)
	@touch $@

$(LZO_TARGET_BUILD_DIR)/.configured:
	$(call EMBTK_GENERIC_MESSAGE,"Configuring lzo-$(LZO_VERSION)...")
	@cd $(LZO_TARGET_BUILD_DIR); CC=$(TARGETCC_CACHED) \
	CXX=$(TARGETCXX_CACHED) RANLIB=$(TOOLS)/bin/$(GNU_TARGET)-ranlib \
	AR=$(TOOLS)/bin/$(GNU_TARGET)-ar \
	$(PACKAGES_BUILD)/lzo-$(LZO_VERSION)/configure \
	--prefix=$(SYSROOT)/usr/local --host=$(STRICT_GNU_TARGET)
	@touch $@

download_lzo:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(LZO_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(LZO_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(LZO_PACKAGE) $(LZO_SITE)/$(LZO_PACKAGE)

