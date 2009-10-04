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
# \file         libpng.mk
# \brief	libpng.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         October 2009
################################################################################

LIBPNG_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_LIBPNG_VERSION_STRING)))
LIBPNG_SITE := http://download.sourceforge.net/libpng
LIBPNG_PACKAGE := libpng-$(LIBPNG_VERSION).tar.gz
LIBPNG_BUILD_DIR := $(PACKAGES_BUILD)/libpng-$(LIBPNG_VERSION)

libpng_install: $(LIBPNG_BUILD_DIR)/.installed

$(LIBPNG_BUILD_DIR)/.installed: zlib_target_install download_libpng \
	$(LIBPNG_BUILD_DIR)/.decompressed $(LIBPNG_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	libpng-$(LIBPNG_VERSION) in your root filesystem...")
	$(Q)cd $(LIBPNG_BUILD_DIR); $(MAKE) $(J) ; $(MAKE) install
	@touch $@

download_libpng:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(LIBPNG_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(LIBPNG_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(LIBPNG_PACKAGE) \
	$(LIBPNG_SITE)/$(LIBPNG_PACKAGE)

$(LIBPNG_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LIBPNG_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzvf $(DOWNLOAD_DIR)/$(LIBPNG_PACKAGE)
	@touch $@

$(LIBPNG_BUILD_DIR)/.configured:
	cd $(LIBPNG_BUILD_DIR); \
	CC=$(TARGETCC_CACHED) CFLAGS=$(TARGET_CFLAGS) \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--prefix=$(ROOTFS)/usr --includedir=$(SYSROOT)/usr/include \
	--datarootdir=$(SYSROOT)/usr \
	--with-pkgconfigdir=$(SYSROOT)/usr/lib/pkgconfig \
	--enable-static=no
	@touch $@

