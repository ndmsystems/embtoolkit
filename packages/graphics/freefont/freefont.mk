################################################################################
# GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# Copyright(C) 2010 GAYE Abdoulaye Walsimou. All rights reserved.
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
# \file         freefont.mk
# \brief	freefont.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         January 2010
################################################################################

TTMKFDIR_SITE := http://ftp.de.debian.org/debian/pool/main/t/ttmkfdir
TTMKFDIR_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/ttmkfdir
TTMKFDIR_VERSION := 3.0.9
TTMKFDIR_PACKAGE := ttmkfdir_$(TTMKFDIR_VERSION).orig.tar.gz
TTMKFDIR_BUILD_DIR := $(PACKAGES_BUILD)/ttmkfdir-$(TTMKFDIR_VERSION)

FREEFONT_SITE := http://ftp.gnu.org/gnu/freefont
FREEFONT_TTF_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_FREEFONT_TTF_VERSION_STRING)))
FREEFONT_TTF_PACKAGE := freefont-ttf-$(FREEFONT_TTF_VERSION).tar.gz
FREEFONT_TTF_BUILD_DIR := $(PACKAGES_BUILD)/freefont-$(FREEFONT_TTF_VERSION)

FREEFONT_OTF_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_FREEFONT_OTF_VERSION_STRING)))
FREEFONT_OTF_PACKAGE := freefont-otf-$(FREEFONT_OTF_VERSION).zip
FREEFONT_OTF_BUILD_DIR := $(PACKAGES_BUILD)/freefont-otf-$(FREEFONT_OTF_VERSION)

freefont_ttf_install: $(FREEFONT_TTF_BUILD_DIR)/.installed
ttmkfdir_install: $(TTMKFDIR_BUILD_DIR)/.installed

$(TTMKFDIR_BUILD_DIR)/.installed: download_ttmkfdir \
	$(TTMKFDIR_BUILD_DIR)/.decompressed
	$(Q)$(MAKE) -C $(TTMKFDIR_BUILD_DIR) CC=$(TARGETCC_CACHED) \
	CXX=$(TARGETCXX_CACHED) DEBUG=""
	$(Q)$(MAKE) -C $(TTMKFDIR_BUILD_DIR) DESTDIR=$(SYSROOT) install
	@touch $@

$(TTMKFDIR_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(TTMKFDIR_PACKAGE)...")
	@tar -C $(PACKAGES_BUILD) -xzf $(DOWNLOAD_DIR)/$(TTMKFDIR_PACKAGE)
	$(Q)cd $(TTMKFDIR_BUILD_DIR); \
	patch -p1 < $(DOWNLOAD_DIR)/ttmkfdir-$(TTMKFDIR_VERSION).patch
	@touch $@

ttmkfdir_clean:
	$(Q)rm -rf $(SYSROOT)/usr/bin/ttmkfdir

download_ttmkfdir:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading ttmkfdir-$(TTMKFDIR_VERSION) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(TTMKFDIR_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(TTMKFDIR_PACKAGE) \
	$(TTMKFDIR_SITE)/$(TTMKFDIR_PACKAGE)
	@test -e $(DOWNLOAD_DIR)/ttmkfdir-$(TTMKFDIR_VERSION).patch || \
	wget -O $(DOWNLOAD_DIR)/ttmkfdir-$(TTMKFDIR_VERSION).patch \
	$(TTMKFDIR_PATCH_SITE)/ttmkfdir-$(TTMKFDIR_VERSION)-*.patch

$(FREEFONT_TTF_BUILD_DIR)/.installed: freetype_install ttmkfdir_install \
	download_freefont_ttf $(FREEFONT_TTF_BUILD_DIR)/.decompressed
	$(call EMBTK_GENERIC_MESSAGE,"Installing \
	freefont-$(FREEFONT_TTF_VERSION) in your root filesystem...")
	$(Q)mkdir -p $(ROOTFS)/usr/share/fonts
	$(Q)mkdir -p $(ROOTFS)/usr/share/fonts/trutype
	$(Q)mkdir -p $(ROOTFS)/usr/share/fonts/trutype/freefont
	$(Q)cp $(FREEFONT_TTF_BUILD_DIR)/*.ttf \
	$(ROOTFS)/usr/share/fonts/trutype/freefont/
	@touch $@

download_freefont_ttf:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(FREEFONT_TTF_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(FREEFONT_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(FREEFONT_PACKAGE) \
	$(FREEFONT_SITE)/$(FREEFONT_PACKAGE)

$(FREEFONT_TTF_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(FREEFONT_TTF_PACKAGE)...")
	@tar -C $(PACKAGES_BUILD) -xzf $(DOWNLOAD_DIR)/$(FREEFONT_TTF_PACKAGE)
	@touch $@

