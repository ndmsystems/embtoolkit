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

LIBPNG_BINS = libpng*
LIBPNG_SBINS =
LIBPNG_INCLUDES = libpng* png*
LIBPNG_LIBS = libpng*
LIBPNG_PKGCONFIGS = libpng*

libpng_install: $(LIBPNG_BUILD_DIR)/.installed

$(LIBPNG_BUILD_DIR)/.installed: zlib_target_install download_libpng \
	$(LIBPNG_BUILD_DIR)/.decompressed $(LIBPNG_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	libpng-$(LIBPNG_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(LIBPNG_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBPNG_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) $(LIBPNG_BUILD_DIR)/.libtoolpatched
	$(Q)$(MAKE) $(LIBPNG_BUILD_DIR)/.pkgconfigpatched
	$(Q)$(MAKE) $(LIBPNG_BUILD_DIR)/.libpng-configpatched
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
	CC=$(TARGETCC_CACHED) CFLAGS="$(TARGET_CFLAGS)" \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--prefix=/usr --enable-static=no --with-libpng-compat=no
	@touch $@

$(LIBPNG_BUILD_DIR)/.libpng-configpatched:
	$(Q)cd $(ROOTFS)/usr/bin; \
	cat libpng-config | \
	sed -e 's;prefix="/usr";prefix="$(ROOTFS)/usr";' \
	-e 's;includedir="$${prefix}/include/libpng12";includedir="$(SYSROOT)/usr/include/libpng12";' \
	> libpng-config.new;\
	cp libpng-config.new libpng-config; rm libpng-config.new

$(LIBPNG_BUILD_DIR)/.libtoolpatched:
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)cd $(SYSROOT)/usr/lib32; \
	cat libpng.la | sed -e 's;\/usr\/lib;$(SYSROOT)\/usr\/lib32;' \
	> libpng.la.new;\
	cp libpng.la.new libpng.la; rm  libpng.la.new
else
	$(Q)cd $(SYSROOT)/usr/lib; \
	cat libpng.la | sed -e 's;\/usr\/lib;$(SYSROOT)\/usr\/lib;' \
	> libpng.la.new;\
	cp libpng.la.new libpng.la; rm  libpng.la.new
endif

$(LIBPNG_BUILD_DIR)/.pkgconfigpatched:
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)cd $(SYSROOT)/usr/lib32/pkgconfig; \
	cat libpng.pc | sed -e 's;prefix=\/usr;prefix=$(SYSROOT)\/usr;' \
	-e 's;includedir=$${prefix}/include/libpng12;includedir=$(SYSROOT)/usr/include/libpng12;' \
	> libpng.pc.new;\
	cp libpng.pc.new libpng.pc; rm  libpng.pc.new
else
	$(Q)cd $(SYSROOT)/usr/lib/pkgconfig; \
	cat libpng.pc | sed -e 's;prefix=\/usr;prefix=$(SYSROOT)\/usr;' \
	-e 's;includedir=$${prefix}/include/libpng12;includedir=$(SYSROOT)/usr/include/libpng12;' \
	> libpng.pc.new;\
	cp libpng.pc.new libpng.pc; rm  libpng.pc.new
endif

libpng_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup libpng-$(LIBPNG_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(LIBPNG_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(LIBPNG_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(LIBPNG_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/lib; rm -rf $(LIBPNG_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib/pkgconfig; rm -rf $(LIBPNG_PKGCONFIGS)
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cd $(SYSROOT)/usr/lib32; rm -rf $(LIBPNG_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib32/pkgconfig; rm -rf $(LIBPNG_PKGCONFIGS)
endif

