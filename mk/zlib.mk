################################################################################
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
################################################################################
#
# \file         zlib.mk
# \brief	zlib.mk of Embtoolkit.
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         June 2009
################################################################################

ZLIB_VERSION := 1.2.3
ZLIB_SITE := http://www.gzip.org/zlib
ZLIB_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/zlib/patches
ZLIB_PACKAGE := zlib-$(ZLIB_VERSION).tar.bz2
ZLIB_HOST_BUILD_DIR := $(TOOLS_BUILD)/zlib-host-build
ZLIB_TARGET_BUILD_DIR := $(PACKAGES_BUILD)/zlib-target-build

zlib_host_install: $(ZLIB_HOST_BUILD_DIR)/.installed
zlib_target_install: $(ZLIB_TARGET_BUILD_DIR)/.installed

#zlib on host machine
$(ZLIB_HOST_BUILD_DIR)/.installed: download_zlib \
	$(ZLIB_HOST_BUILD_DIR)/.decompressed
	@$(MAKE) -C $(TOOLS_BUILD)/zlib-$(ZLIB_VERSION)-host $(J)
	@$(MAKE) -C $(TOOLS_BUILD)/zlib-$(ZLIB_VERSION)-host \
	prefix=$(HOSTTOOLS)/usr/local install
	@touch $@

$(ZLIB_HOST_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(ZLIB_PACKAGE)...")
	@tar -C $(TOOLS_BUILD) -xjf $(DOWNLOAD_DIR)/$(ZLIB_PACKAGE)
	@mv  $(TOOLS_BUILD)/zlib-$(ZLIB_VERSION) \
	$(TOOLS_BUILD)/zlib-$(ZLIB_VERSION)-host
	@mkdir -p $(ZLIB_HOST_BUILD_DIR)
	@touch $@

#zlib on target machine
$(ZLIB_TARGET_BUILD_DIR)/.installed: download_zlib \
$(ZLIB_TARGET_BUILD_DIR)/.decompressed
	@$(MAKE) -C $(PACKAGES_BUILD)/zlib-$(ZLIB_VERSION)-target \
	CC=$(TARGETCC_CACHED) AR="$(TOOLS)/bin/$(GNU_TARGET)-ar rc" \
	RANLIB=$(TOOLS)/bin/$(GNU_TARGET)-ranlib CFLAGS=-fPIC
	@$(MAKE) -C $(PACKAGES_BUILD)/zlib-$(ZLIB_VERSION)-target \
	CC=$(TARGETCC_CACHED) AR="$(TOOLS)/bin/$(GNU_TARGET)-ar rc" \
	RANLIB=$(TOOLS)/bin/$(GNU_TARGET)-ranlib \
	prefix=$(SYSROOT)/usr/ libdir=$(SYSROOT)/usr/$(LIBDIR) install
	@touch $@

$(ZLIB_TARGET_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(ZLIB_PACKAGE)...")
	@tar -C $(PACKAGES_BUILD) -xjf $(DOWNLOAD_DIR)/$(ZLIB_PACKAGE)
	@mv  $(PACKAGES_BUILD)/zlib-$(ZLIB_VERSION) \
	$(PACKAGES_BUILD)/zlib-$(ZLIB_VERSION)-target
	@mkdir -p $(ZLIB_TARGET_BUILD_DIR)
	@touch $@

#zlib download
download_zlib:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(ZLIB_PACKAGE) if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(ZLIB_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(ZLIB_PACKAGE) $(ZLIB_SITE)/$(ZLIB_PACKAGE)

