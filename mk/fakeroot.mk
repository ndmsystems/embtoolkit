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
# \file         fakeroot.mk
# \brief	fakeroot.mk of Embtoolkit. fakeroot helps building root filesystem,
# \brief	without the need to be root.
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         June 2009
#########################################################################################

FAKEROOT_VERSION := 1.11
FAKEROOT_SITE := http://snapshot.debian.net/archive/2008/12/31/debian/pool/main/f/fakeroot
FAKEROOT_PACKAGE := fakeroot_$(FAKEROOT_VERSION).tar.gz
FAKEROOT_BUILD_DIR := $(TOOLS_BUILD)/fakeroot-build
FAKEROOT_DIR := $(HOSTTOOLS)/usr/local/fakeroot
FAKEROOT_BIN := $(FAKEROOT_DIR)/bin/fakeroot

fakeroot_install: $(FAKEROOT_BUILD_DIR)/.installed

$(FAKEROOT_BUILD_DIR)/.installed: download_fakeroot $(FAKEROOT_BUILD_DIR)/.decompressed \
	$(FAKEROOT_BUILD_DIR)/.configured
	@$(MAKE) -C $(FAKEROOT_BUILD_DIR) && $(MAKE) -C $(FAKEROOT_BUILD_DIR) install
	@touch $@

download_fakeroot:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(FAKEROOT_PACKAGE) if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(FAKEROOT_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(FAKEROOT_PACKAGE) $(FAKEROOT_SITE)/$(FAKEROOT_PACKAGE)

$(FAKEROOT_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(FAKEROOT_PACKAGE)...")
	@tar -C $(TOOLS_BUILD) -xzf $(DOWNLOAD_DIR)/$(FAKEROOT_PACKAGE)
	@mkdir -p $(FAKEROOT_BUILD_DIR)
	@mkdir -p $(FAKEROOT_DIR)
	@touch $@

$(FAKEROOT_BUILD_DIR)/.configured:
	$(call EMBTK_GENERIC_MESSAGE,"Configuring fakeroot_$(FAKEROOT_VERSION)...")
	@cd $(FAKEROOT_BUILD_DIR); \
	$(TOOLS_BUILD)/fakeroot-$(FAKEROOT_VERSION)/configure \
	--prefix=$(FAKEROOT_DIR) --build=$(HOST_BUILD) --host=$(HOST_ARCH)
	@touch $@
