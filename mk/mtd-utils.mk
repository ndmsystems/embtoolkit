################################################################################
# Embtoolkit
# Copyright(C) 2009-2010 Abdoulaye Walsimou GAYE. All rights reserved.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
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
# \file         mtd-utils.mk
# \brief	mtd-utils.mk of Embtoolkit.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         June 2009
################################################################################

MTDUTILS_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_MTDUTILS_VERSION_STRING)))
MTDUTILS_SITE := ftp://ftp.infradead.org/pub/mtd-utils
MTDUTILS_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/mtd-utils/$(MTDUTILS_VERSION)
MTDUTILS_PACKAGE := mtd-utils-$(MTDUTILS_VERSION).tar.bz2
MTDUTILS_HOST_BUILD_DIR := $(TOOLS_BUILD)/mtd-utils-$(MTDUTILS_VERSION)
MTDUTILS_TARGET_BUILD_DIR := $(PACKAGES_BUILD)/mtd-utils-$(MTDUTILS_VERSION)

MTDUTILS_SBINS := bin2nand flash_eraseall flash_unlock mkfs.jffs2 nand2bin \
		nftl_format rfddump ubicrc32 ubimirror ubirmvol docfdisk \
		flash_info ftl_check mkfs.ubifs nanddump pddcustomize \
		rfdformat ubicrc32.pl ubimkvol ubirsvol doc_loadbios \
		flash_lock ftl_format mkpfi nandtest pfi2bin serve_image \
		ubidetach ubinfo ubiupdatevol flashcp flash_otp_dump \
		jffs2dump mtd_debug nandwrite pfiflash sumtool ubiformat \
		ubinize unubi flash_erase flash_otp_info mkbootenv mtdinfo \
		nftldump recv_image ubiattach ubigen ubirename

##############################################
# mtd-utils for the host development machine #
##############################################

MTDUTILS_HOST_DEPS := zlib_host_install lzo_host_install \
		utillinuxng_host_install

mtdutils_host_install:
	@test -e $(MTDUTILS_HOST_BUILD_DIR)/.installed || \
	$(MAKE) $(MTDUTILS_HOST_BUILD_DIR)/.installed

$(MTDUTILS_HOST_BUILD_DIR)/.installed:  $(MTDUTILS_HOST_DEPS) \
	download_mtdutils $(MTDUTILS_HOST_BUILD_DIR)/.decompressed
	LDFLAGS="-L$(HOSTTOOLS)/usr/local/lib" \
	CPPFLAGS="-I. -I$(HOSTTOOLS)/usr/local/include -I$(HOSTTOOLS)/usr/include" \
	DESTDIR=$(HOSTTOOLS) \
	BUILDDIR=$(MTDUTILS_HOST_BUILD_DIR) \
	$(MAKE) -C $(TOOLS_BUILD)/mtd-utils-$(MTDUTILS_VERSION) install
	@touch $@

$(MTDUTILS_HOST_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(MTDUTILS_PACKAGE)...")
	@tar -C $(TOOLS_BUILD) -xvf $(DOWNLOAD_DIR)/$(MTDUTILS_PACKAGE)
ifeq ($(CONFIG_EMBTK_MTDUTILS_NEED_PATCH),y)
	cd $(MTDUTILS_HOST_BUILD_DIR); \
	patch -p1 < $(DOWNLOAD_DIR)/mtd-utils-$(MTDUTILS_VERSION).patch
endif
	@touch $@

mtdutils_host_clean:
	$(call EMBTK_GENERIC_MESSAGE,"Cleaning mtd-utils in host ...")

########################
# mtd-utils for target #
########################

MTDUTILS_DEPS := zlib_target_install lzo_target_install utillinuxng_install

mtdutils_target_install:
	@test -e $(MTDUTILS_TARGET_BUILD_DIR)/.installed || \
	$(MAKE) $(MTDUTILS_TARGET_BUILD_DIR)/.installed

$(MTDUTILS_TARGET_BUILD_DIR)/.installed: $(MTDUTILS_DEPS) download_mtdutils \
	$(MTDUTILS_TARGET_BUILD_DIR)/.decompressed
	LDFLAGS="-L$(SYSROOT)/usr/local/lib" \
	CPPFLAGS="-I. -I./include -I$(SYSROOT)/usr/local/include -I$(SYSROOT)/usr/include" \
	CFLAGS="$(TARGET_CFLAGS)" \
	BUILDDIR=$(MTDUTILS_TARGET_BUILD_DIR) DESTDIR=$(SYSROOT) \
	PATH=$(PATH):$(TOOLS)/bin CROSS=$(CROSS_COMPILE) \
	$(MAKE) -C $(PACKAGES_BUILD)/mtd-utils-$(MTDUTILS_VERSION) install
	@touch $@

$(MTDUTILS_TARGET_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(MTDUTILS_PACKAGE)...")
	@tar -C $(PACKAGES_BUILD) -xjf $(DOWNLOAD_DIR)/$(MTDUTILS_PACKAGE)
ifeq ($(CONFIG_EMBTK_MTDUTILS_NEED_PATCH),y)
	@cd $(MTDUTILS_TARGET_BUILD_DIR); \
	patch -p1 < $(DOWNLOAD_DIR)/mtd-utils-$(MTDUTILS_VERSION).patch
endif
	@touch $@

mtdutils_target_clean:
	$(call EMBTK_GENERIC_MESSAGE,"Cleaning mtd-utils in target ...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(MTDUTILS_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(MTDUTILS_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(MTDUTILS_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(MTDUTILS_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(MTDUTILS_PKGCONFIGS)
	$(Q)-rm -rf $(MTDUTILS_TARGET_BUILD_DIR)*

download_mtdutils:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(MTDUTILS_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(MTDUTILS_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(MTDUTILS_PACKAGE) \
	$(MTDUTILS_SITE)/$(MTDUTILS_PACKAGE)
ifeq ($(CONFIG_EMBTK_MTDUTILS_NEED_PATCH),y)
	@test -e $(DOWNLOAD_DIR)/mtd-utils-$(MTDUTILS_VERSION).patch || \
	wget -O $(DOWNLOAD_DIR)/mtd-utils-$(MTDUTILS_VERSION).patch \
	$(MTDUTILS_PATCH_SITE)/mtd-utils-$(MTDUTILS_VERSION)-*.patch
endif
