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
# \file         libjpeg.mk
# \brief	libjpeg.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         October 2009
################################################################################

LIBJPEG_NAME := jpeg
LIBJPEG_VERSION := $(call embtk_get_pkgversion,LIBJPEG)
LIBJPEG_SITE := http://www.ijg.org/files
LIBJPEG_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
LIBJPEG_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/jpeg/$(LIBJPEG_VERSION)
LIBJPEG_PACKAGE := jpegsrc.v$(LIBJPEG_VERSION).tar.gz
LIBJPEG_SRC_DIR := $(PACKAGES_BUILD)/jpeg-$(LIBJPEG_VERSION)
LIBJPEG_BUILD_DIR := $(PACKAGES_BUILD)/jpeg-$(LIBJPEG_VERSION)

LIBJPEG_BINS := cjpeg djpeg jpegtran rdjpgcom wrjpgcom
LIBJPEG_SBINS :=
LIBJPEG_LIBS := libjpeg*
LIBJPEG_INCLUDES := jconfig.h jerror.h jmorecfg.h jpeglib.h

LIBJPEG_CONFIGURE_OPTS := --program-suffix=""

libjpeg_install:
	@test -e $(LIBJPEG_BUILD_DIR)/.installed || \
	$(MAKE) $(LIBJPEG_BUILD_DIR)/.installed

$(LIBJPEG_BUILD_DIR)/.installed: download_libjpeg \
	$(LIBJPEG_BUILD_DIR)/.decompressed $(LIBJPEG_BUILD_DIR)/.configured
	$(call embtk_generic_message,"Compiling and installing \
	jpeg-$(LIBJPEG_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(LIBJPEG_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBJPEG_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	@touch $@

download_libjpeg:
	$(call embtk_download_pkg,LIBJPEG)

$(LIBJPEG_BUILD_DIR)/.decompressed:
	$(call embtk_decompress_pkg,LIBJPEG)

$(LIBJPEG_BUILD_DIR)/.configured:
	$(call embtk_configure_pkg,LIBJPEG)

libjpeg_clean:
	$(call embtk_cleanup_pkg,LIBJPEG)
