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
# \file         uclibc.mk
# \brief	uclibc.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         August 2009
################################################################################

UCLIBC_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_UCLIBC_VERSION_STRING)))
UCLIBC_SITE := http://www.uclibc.org/downloads
UCLIBC_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/uclibc
UCLIBC_PACKAGE := uClibc-$(UCLIBC_VERSION).tar.bz2
UCLIBC_BUILD_DIR := $(TOOLS_BUILD)/uClibc-$(UCLIBC_VERSION)

uclibc_install: $(UCLIBC_BUILD_DIR)/.installed

$(UCLIBC_BUILD_DIR)/.installed: uclibc_download \
$(UCLIBC_BUILD_DIR)/.decompressed $(UCLIBC_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Building and installing \
	uClibc-$(UCLIBC_VERSION) ...")
	$(MAKE) -C $(UCLIBC_BUILD_DIR) oldconfig
	$(MAKE) -C $(UCLIBC_BUILD_DIR) \
	CROSS_COMPILER_PREFIX="$(TOOLS)/bin/$(STRICT_GNU_TARGET)-" \
	SHARED_LIB_LOADER_PREFIX="/lib/" \
	RUNTIME_PREFIX="/" DEVEL_PREFIX="/usr/" \
	KERNEL_HEADERS="$(SYSROOT)/usr/include/" \
	UCLIBC_EXTRA_CFLAGS="$(TARGET_CFLAGS) -pipe"
	$(MAKE) -C $(UCLIBC_BUILD_DIR) PREFIX=$(SYSROOT)/ \
	CROSS_COMPILER_PREFIX="$(TOOLS)/bin/$(STRICT_GNU_TARGET)-" \
	SHARED_LIB_LOADER_PREFIX="/lib/" \
	RUNTIME_PREFIX="/" DEVEL_PREFIX="/usr/" \
	KERNEL_HEADERS="$(SYSROOT)/usr/include/" \
	UCLIBC_EXTRA_CFLAGS="$(TARGET_CFLAGS) -pipe" install

uclibc_download:
	$(call EMBTK_GENERIC_MESSAGE,"downloading uClibc-$(UCLIBC_VERSION) \
	if necessary ...")
	@test -e $(DOWNLOAD_DIR)/$(UCLIBC_PACKAGE) || \
	wget $(UCLIBC_SITE)/$(UCLIBC_PACKAGE) \
	-O $(DOWNLOAD_DIR)/$(UCLIBC_PACKAGE)
ifeq ($(CONFIG_EMBTK_UCLIBC_NEED_PATCH),y)
	@test -e $(DOWNLOAD_DIR)/uClibc-$(UCLIBC_VERSION).patch || \
	wget -O $(DOWNLOAD_DIR)/uClibc-$(UCLIBC_VERSION).patch \
	$(UCLIBC_PATCH_SITE)/uClibc-$(UCLIBC_VERSION)-*.patch
endif

$(UCLIBC_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing \
	uClibc-$(UCLIBC_VERSION) ...")
	$(Q)tar -C $(TOOLS_BUILD) -xjvf $(DOWNLOAD_DIR)/$(UCLIBC_PACKAGE)
ifeq ($(CONFIG_EMBTK_UCLIBC_NEED_PATCH),y)
	$(Q)cd $(UCLIBC_BUILD_DIR); \
	patch -p1 < $(DOWNLOAD_DIR)/uClibc-$(UCLIBC_VERSION).patch
endif

$(UCLIBC_BUILD_DIR)/.configured:
	$(call EMBTK_GENERIC_MESSAGE,"Configuring \
	uClibc-$(UCLIBC_VERSION) ...")
	grep "CONFIG_KEMBTK_UCLIBC_" $(EMBTK_ROOT)/.config | \
	sed -e 's/CONFIG_KEMBTK_UCLIBC_*//g' \
	> $(UCLIBC_BUILD_DIR)/.config

