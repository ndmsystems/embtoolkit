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
# \file         imlib2.mk
# \brief	imlib2.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         June 2010
################################################################################

IMLIB2_NAME := imlib2
IMLIB2_VERSION := $(call embtk_get_pkgversion,IMLIB2)
IMLIB2_SITE := http://downloads.sourceforge.net/project/enlightenment/imlib2-src/$(IMLIB2_VERSION)
IMLIB2_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
IMLIB2_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/imlib2/$(IMLIB2_VERSION)
IMLIB2_PACKAGE := imlib2-$(IMLIB2_VERSION).tar.gz
IMLIB2_SRC_DIR := $(PACKAGES_BUILD)/imlib2-$(IMLIB2_VERSION)
IMLIB2_BUILD_DIR := $(PACKAGES_BUILD)/imlib2-$(IMLIB2_VERSION)

IMLIB2_BINS = imlib2_bumpmap imlib2_colorspace imlib2-config imlib2_conv \
		imlib2_grab imlib2_poly imlib2_show imlib2_test imlib2_view
IMLIB2_SBINS =
IMLIB2_INCLUDES = Imlib2.h
IMLIB2_LIBS = imlib2 libImlib2.*
IMLIB2_PKGCONFIGS = imlib2.pc

IMLIB2_DEPS := libpng_install freetype_install libjpeg_install

imlib2_install:
	test -e $(IMLIB2_BUILD_DIR)/.installed || \
	$(MAKE) $(IMLIB2_BUILD_DIR)/.installed
	$(Q)$(MAKE) $(IMLIB2_BUILD_DIR)/.special

$(IMLIB2_BUILD_DIR)/.installed: $(IMLIB2_DEPS) download_imlib2 \
	$(IMLIB2_BUILD_DIR)/.decompressed $(IMLIB2_BUILD_DIR)/.configured
	$(call embtk_generic_message,"Compiling and installing \
	imlib2-$(IMLIB2_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(IMLIB2_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(IMLIB2_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_imlib2:
	$(call embtk_download_pkg,IMLIB2)

$(IMLIB2_BUILD_DIR)/.decompressed:
	$(call embtk_decompress_pkg,IMLIB2)

$(IMLIB2_BUILD_DIR)/.configured:
	$(call embtk_configure_pkg,IMLIB2)

imlib2_clean:
	$(call embtk_cleanup_pkg,IMLIB2)

.PHONY: $(IMLIB2_BUILD_DIR)/.special

$(IMLIB2_BUILD_DIR)/.special:
	$(Q)mkdir -p $(ROOTFS)/usr/$(LIBDIR)
	$(Q)-cp -R $(SYSROOT)/usr/$(LIBDIR)/imlib2 $(ROOTFS)/usr/$(LIBDIR)
	$(Q)-mkdir -p $(ROOTFS)/usr/share
	$(Q)-cp -R $(SYSROOT)/usr/share/imlib2 $(ROOTFS)/usr/share
	@touch $@
