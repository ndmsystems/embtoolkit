################################################################################
# Embtoolkit
# Copyright(C) 2010-2011 Abdoulaye Walsimou GAYE.
#
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
# \file         freefont.mk
# \brief	freefont.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         January 2010
################################################################################

TTMKFDIR_SITE := http://ftp.de.debian.org/debian/pool/main/t/ttmkfdir
TTMKFDIR_VERSION := 3.0.9
TTMKFDIR_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/ttmkfdir/$(TTMKFDIR_VERSION)
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
	$(call embtk_generic_message,"Decompressing $(TTMKFDIR_PACKAGE)...")
	@tar -C $(PACKAGES_BUILD) -xzf $(DOWNLOAD_DIR)/$(TTMKFDIR_PACKAGE)
	$(Q)cd $(TTMKFDIR_BUILD_DIR); \
	patch -p1 < $(DOWNLOAD_DIR)/ttmkfdir-$(TTMKFDIR_VERSION).patch
	@touch $@

ttmkfdir_clean:
	$(Q)rm -rf $(SYSROOT)/usr/bin/ttmkfdir

download_ttmkfdir:
	$(call embtk_generic_message,"Downloading ttmkfdir-$(TTMKFDIR_VERSION) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(TTMKFDIR_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(TTMKFDIR_PACKAGE) \
	$(TTMKFDIR_SITE)/$(TTMKFDIR_PACKAGE)
	@test -e $(DOWNLOAD_DIR)/ttmkfdir-$(TTMKFDIR_VERSION).patch || \
	wget -O $(DOWNLOAD_DIR)/ttmkfdir-$(TTMKFDIR_VERSION).patch \
	$(TTMKFDIR_PATCH_SITE)/ttmkfdir-$(TTMKFDIR_VERSION)-*.patch

$(FREEFONT_TTF_BUILD_DIR)/.installed: freetype_install \
	download_freefont_ttf $(FREEFONT_TTF_BUILD_DIR)/.decompressed
	$(call embtk_generic_message,"Installing \
	freefont-$(FREEFONT_TTF_VERSION) in your root filesystem...")
	$(Q)mkdir -p $(ROOTFS)/usr/share/fonts
	$(Q)mkdir -p $(ROOTFS)/usr/share/fonts/truetype
	$(Q)mkdir -p $(ROOTFS)/usr/share/fonts/truetype/freefont
	$(Q)cp $(FREEFONT_TTF_BUILD_DIR)/*.ttf \
	$(ROOTFS)/usr/share/fonts/truetype/freefont/
	@touch $@

download_freefont_ttf:
	$(call embtk_generic_message,"Downloading $(FREEFONT_TTF_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(FREEFONT_TTF_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(FREEFONT_TTF_PACKAGE) \
	$(FREEFONT_SITE)/$(FREEFONT_TTF_PACKAGE)

$(FREEFONT_TTF_BUILD_DIR)/.decompressed:
	$(call embtk_generic_message,"Decompressing $(FREEFONT_TTF_PACKAGE)...")
	@tar -C $(PACKAGES_BUILD) -xzf $(DOWNLOAD_DIR)/$(FREEFONT_TTF_PACKAGE)
	@touch $@

freefont_ttf_clean:
	$(call embtk_generic_message,"Cleanup freefont...")
