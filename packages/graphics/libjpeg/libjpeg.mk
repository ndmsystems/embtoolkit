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
# \file         libjpeg.mk
# \brief	libjpeg.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         October 2009
################################################################################

LIBJPEG_VERSION := v7
LIBJPEG_SITE := http://www.ijg.org/files
LIBJPEG_PACKAGE := jpegsrc.$(LIBJPEG_VERSION).tar.gz
LIBJPEG_BUILD_DIR := $(PACKAGES_BUILD)/jpeg-7

LIBJPEG_BINS := cjpeg djpeg jpegtran rdjpgcom wrjpgcom
LIBJPEG_SBINS :=
LIBJPEG_LIBS := libjpeg*
LIBJEPG_INCLUDES := jconfig.h jerror.h jmorecfg.h jpeglib.h

libjpeg_install: $(LIBJPEG_BUILD_DIR)/.installed

$(LIBJPEG_BUILD_DIR)/.installed: download_libjpeg \
	$(LIBJPEG_BUILD_DIR)/.decompressed $(LIBJPEG_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	jpeg-$(LIBJPEG_VERSION) in your root filesystem...")
	$(call KILL_LT_RPATH, $(LIBJPEG_BUILD_DIR))
	$(Q)$(MAKE) -C $(LIBJPEG_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBJPEG_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	@touch $@

download_libjpeg:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(LIBJPEG_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(LIBJPEG_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(LIBJPEG_PACKAGE) \
	$(LIBJPEG_SITE)/$(LIBJPEG_PACKAGE)

$(LIBJPEG_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LIBJPEG_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzvf $(DOWNLOAD_DIR)/$(LIBJPEG_PACKAGE)
	@touch $@

$(LIBJPEG_BUILD_DIR)/.configured:
	cd $(LIBJPEG_BUILD_DIR); \
	CC=$(TARGETCC_CACHED) CFLAGS="$(TARGET_CFLAGS)" \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) \
	--prefix=/usr --enable-static=no --program-suffix=""
	@touch $@

libjpeg_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup jpeg-$(LIBJPEG_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(LIBJPEG_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(LIBJPEG_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(LIBJPEG_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/lib; rm -rf $(LIBJPEG_LIBS)
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cd $(SYSROOT)/usr/lib32; rm -rf $(LIBJPEG_LIBS)
endif


