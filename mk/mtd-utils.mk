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
# \file         mtd-utils.mk
# \brief	mtd-utils.mk of Embtoolkit.
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         June 2009
################################################################################

MTD-UTILS_VERSION := 1.2.0
MTD-UTILS_SITE := ftp://ftp.infradead.org/pub/mtd-utils
MTD-UTILS_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/mtd-utils
MTD-UTILS_PACKAGE := mtd-utils-$(MTD-UTILS_VERSION).tar.bz2
MTD-UTILS_PATCH := mtd-utils.patch
MTD-UTILS_HOST_BUILD_DIR := $(TOOLS_BUILD)/mtd-utils-build
MTD-UTILS_TARGET_BUILD_DIR := $(PACKAGES_BUILD)/mtd-utils-build

MTD-UTILS_BINS := docfdisk flash_erase flash_lock flash_unlock jffs2dump \
nanddump nftldump rfddump sumtool doc_loadbios flash_eraseall flash_otp_dump \
ftl_check mkfs.jffs2 nandtest nftl_format rfdformat flashcp flash_info \
flash_otp_info ftl_format mtd_debug nandwrite recv_image serve_image

mtd-utils_host_install: $(MTD-UTILS_HOST_BUILD_DIR)/.installed
mtd-utils_target_install: $(MTD-UTILS_TARGET_BUILD_DIR)/.installed

#mtd-utils for host
$(MTD-UTILS_HOST_BUILD_DIR)/.installed: zlib_host_install lzo_host_install \
download_mtd-utils $(MTD-UTILS_HOST_BUILD_DIR)/.decompressed
	LDFLAGS="-L$(HOSTTOOLS)/usr/local/lib" \
	CFLAGS="-I. -I./include -I$(HOSTTOOLS)/usr/local/include \
	-I$(HOSTTOOLS)/usr/include" DESTDIR=$(HOSTTOOLS) \
	$(MAKE) -C $(TOOLS_BUILD)/mtd-utils-$(MTD-UTILS_VERSION) install
	@touch $@

$(MTD-UTILS_HOST_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(MTD-UTILS_PACKAGE)...")
	@tar -C $(TOOLS_BUILD) -xjvf $(DOWNLOAD_DIR)/$(MTD-UTILS_PACKAGE)
	cd  $(TOOLS_BUILD)/mtd-utils-$(MTD-UTILS_VERSION); \
	patch -p1 < $(DOWNLOAD_DIR)/mtd-utils.patch
	@mkdir -p $(MTD-UTILS_HOST_BUILD_DIR)
	@touch $@

#mtd-utils for target
$(MTD-UTILS_TARGET_BUILD_DIR)/.installed: zlib_target_install \
lzo_target_install download_mtd-utils $(MTD-UTILS_TARGET_BUILD_DIR)/.decompressed
	LDFLAGS="-L$(SYSROOT)/usr/local/lib" \
	CFLAGS="-I. -I./include -I$(SYSROOT)/usr/local/include \
	-I$(SYSROOT)/usr/include" DESTDIR=$(SYSROOT) \
	PATH=$(PATH):$(TOOLS)/bin CROSS=$(GNU_TARGET)- \
	$(MAKE) -C $(PACKAGES_BUILD)/mtd-utils-$(MTD-UTILS_VERSION) install
	@touch $@

$(MTD-UTILS_TARGET_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(MTD-UTILS_PACKAGE)...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(MTD-UTILS_PACKAGE)
	cd  $(PACKAGES_BUILD)/mtd-utils-$(MTD-UTILS_VERSION); \
	patch -p1 < $(DOWNLOAD_DIR)/mtd-utils.patch
	@mkdir -p $(MTD-UTILS_TARGET_BUILD_DIR)
	@touch $@

mtd-utils_target_clean:
	@if [ -e $(MTD-UTILS_TARGET_BUILD_DIR)/.installed ]; then \
		cd $(SYSROOT)/usr/sbin; rm -rf $(MTD-UTILS_BINS); \
	fi

download_mtd-utils:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(MTD-UTILS_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(MTD-UTILS_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(MTD-UTILS_PACKAGE) \
	$(MTD-UTILS_SITE)/$(MTD-UTILS_PACKAGE)
	@test -e $(DOWNLOAD_DIR)/$(MTD-UTILS_PATCH) || \
	wget -O $(DOWNLOAD_DIR)/$(MTD-UTILS_PATCH) \
	$(MTD-UTILS_PATCH_SITE)/$(MTD-UTILS_PATCH)

