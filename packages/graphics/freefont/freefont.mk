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

FREEFONT_TTF_NAME	:= freefont-ttf
FREEFONT_TTF_SITE	:= http://ftp.gnu.org/gnu/freefont
FREEFONT_TTF_VERSION	:= $(call embtk_get_pkgversion,freefont_ttf)
FREEFONT_TTF_PACKAGE	:= freefont-ttf-$(FREEFONT_TTF_VERSION).tar.gz
FREEFONT_TTF_SRC_DIR	:= $(PACKAGES_BUILD)/freefont-$(FREEFONT_TTF_VERSION)
FREEFONT_TTF_BUILD_DIR	:= $(PACKAGES_BUILD)/freefont-$(FREEFONT_TTF_VERSION)

FREEFONT_TTF_DEPS := freetype_install
FREEFONT_TTF_DEPS += download_freefont_ttf
FREEFONT_TTF_DEPS += $(FREEFONT_TTF_BUILD_DIR)/.decompressed

freefont_ttf_install: $(FREEFONT_TTF_BUILD_DIR)/.installed
	$(call embtk_pinfo,"Successfully installed GNU FreeFont: TrueType")

$(FREEFONT_TTF_BUILD_DIR)/.installed: $(FREEFONT_TTF_DEPS)
	$(call embtk_pinfo,"Installing freefont-$(FREEFONT_TTF_VERSION) in your root filesystem...")
	$(Q)mkdir -p $(ROOTFS)
	$(Q)mkdir -p $(ROOTFS)/usr
	$(Q)mkdir -p $(ROOTFS)/usr/share
	$(Q)mkdir -p $(ROOTFS)/usr/share/fonts
	$(Q)mkdir -p $(ROOTFS)/usr/share/fonts/truetype
	$(Q)mkdir -p $(ROOTFS)/usr/share/fonts/truetype/freefont
	$(Q)cp $(FREEFONT_TTF_BUILD_DIR)/*.ttf					\
				$(ROOTFS)/usr/share/fonts/truetype/freefont/

$(FREEFONT_TTF_BUILD_DIR)/.decompressed:
	$(call embtk_decompress_pkg,freefont_ttf)

