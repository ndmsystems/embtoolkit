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
# \file         libtiff.mk
# \brief	libtiff.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

LIBTIFF_NAME := libtiff
LIBTIFF_VERSION := $(call EMBTK_GET_PKG_VERSION,LIBTIFF)
LIBTIFF_SITE := ftp://ftp.remotesensing.org/pub/libtiff
LIBTIFF_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
LIBTIFF_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/libtiff/$(LIBTIFF_VERSION)
LIBTIFF_PACKAGE := tiff-$(LIBTIFF_VERSION).tar.gz
LIBTIFF_SRC_DIR := $(PACKAGES_BUILD)/tiff-$(LIBTIFF_VERSION)
LIBTIFF_BUILD_DIR := $(PACKAGES_BUILD)/tiff-$(LIBTIFF_VERSION)

LIBTIFF_BINS =	vbmp2tiff fax2tiff pal2rgb  ras2tiff rgb2ycbcr tiff2bw tiff2ps \
		tiffcmp tiffcrop tiffdump tiffmedian tiffsplit fax2ps gif2tiff \
		ppm2tiff raw2tiff thumbnail tiff2pdf tiff2rgba tiffcp \
		tiffdither tiffinfo tiffset bmp2tiff
LIBTIFF_SBINS =
LIBTIFF_INCLUDES = tiffconf.h tiff.h tiffio.h tiffio.hxx tiffvers.h
LIBTIFF_LIBS = libtiff*
LIBTIFF_PKGCONFIGS =

LIBTIFF_CONFIGURE_OPTS := --disable-cxx --program-prefix=""

libtiff_install:
	@test -e $(LIBTIFF_BUILD_DIR)/.installed || \
	$(MAKE) $(LIBTIFF_BUILD_DIR)/.installed

$(LIBTIFF_BUILD_DIR)/.installed: download_libtiff \
	$(LIBTIFF_BUILD_DIR)/.decompressed $(LIBTIFF_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	libtiff-$(LIBTIFF_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(LIBTIFF_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBTIFF_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_libtiff:
	$(call EMBTK_DOWNLOAD_PKG,LIBTIFF)

$(LIBTIFF_BUILD_DIR)/.decompressed:
	$(call EMBTK_DECOMPRESS_PKG,LIBTIFF)

$(LIBTIFF_BUILD_DIR)/.configured:
	$(call EMBTK_CONFIGURE_PKG,LIBTIFF)

libtiff_clean:
	$(call EMBTK_CLEANUP_PKG,LIBTIFF)
