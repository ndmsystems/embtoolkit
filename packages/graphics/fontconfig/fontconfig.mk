################################################################################
# Embtoolkit
# Copyright(C) 2009-2011 Abdoulaye Walsimou GAYE.
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
# \file         fontconfig.mk
# \brief	fontconfig.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

FONTCONFIG_NAME		:= fontconfig
FONTCONFIG_VERSION	:= $(call EMBTK_GET_PKG_VERSION,FONTCONFIG)
FONTCONFIG_SITE		:= http://fontconfig.org/release
FONTCONFIG_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
FONTCONFIG_PATCH_SITE	:= ftp://ftp.embtoolkit.org/embtoolkit.org/fontconfig/$(FONTCONFIG_VERSION)
FONTCONFIG_PACKAGE	:= fontconfig-$(FONTCONFIG_VERSION).tar.gz
FONTCONFIG_SRC_DIR	:= $(PACKAGES_BUILD)/fontconfig-$(FONTCONFIG_VERSION)
FONTCONFIG_BUILD_DIR	:= $(PACKAGES_BUILD)/fontconfig-$(FONTCONFIG_VERSION)

FONTCONFIG_BINS		= fc-cache fc-cat fc-list fc-match fc-query fc-scan
FONTCONFIG_SBINS	=
FONTCONFIG_INCLUDES	= fontconfig
FONTCONFIG_LIBS		= libfontconfig*
FONTCONFIG_PKGCONFIGS	= fontconfig.pc

LIBXML2_CFLAGS := -I$(SYSROOT)/usr/include/libxml2
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
LIBXML2_CFLAGS += -L$(SYSROOT)/usr/lib32
else
LIBXML2_CFLAGS += -L$(SYSROOT)/usr/lib
endif

FONTCONFIG_CONFIGURE_OPTS := --with-arch=$(STRICT_GNU_TARGET)	\
			--disable-docs --program-prefix=""

fontconfig_install:
	$(call EMBTK_INSTALL_PKG,FONTCONFIG)
	$(MAKE) $(FONTCONFIG_BUILD_DIR)/.special

download_fontconfig:
	$(call EMBTK_DOWNLOAD_PKG,FONTCONFIG)

.PHONY: $(FONTCONFIG_BUILD_DIR)/.special fontconfig_clean

fontconfig_clean:
	$(call EMBTK_CLEANUP_PKG,FONTCONFIG)

$(FONTCONFIG_BUILD_DIR)/.special:
	$(Q)-cp -R $(SYSROOT)/usr/etc/fonts $(ROOTFS)/etc/
	@touch $@

