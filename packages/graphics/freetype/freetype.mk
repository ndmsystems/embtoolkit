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
# \file         freetype.mk
# \brief	freetype.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         October 2009
################################################################################

FREETYPE_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_FREETYPE_VERSION_STRING)))
FREETYPE_SITE := http://mirrors.linhub.com/savannah/freetype
FREETYPE_PACKAGE := freetype-$(FREETYPE_VERSION).tar.bz2
FREETYPE_BUILD_DIR := $(PACKAGES_BUILD)/freetype-$(FREETYPE_VERSION)

freetype_install: $(FREETYPE_BUILD_DIR)/.installed

$(FREETYPE_BUILD_DIR)/.installed: zlib_target_install download_freetype \
	$(FREETYPE_BUILD_DIR)/.decompressed $(FREETYPE_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	freetype-$(FREETYPE_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(FREETYPE_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(FREETYPE_BUILD_DIR) DESTDIR=$(ROOTFS) install
	$(Q)$(MAKE) $(FREETYPE_BUILD_DIR)/.libtoolpatched
	$(Q)$(MAKE) $(FREETYPE_BUILD_DIR)/.pkgconfigpatched
	$(Q)$(MAKE) $(FREETYPE_BUILD_DIR)/.freetype-configpatched
	$(Q)-mv $(ROOTFS)/usr/include/* $(SYSROOT)/usr/include/
	$(Q)rm -rf $(ROOTFS)/usr/include
	@touch $@

download_freetype:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(FREETYPE_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(FREETYPE_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(FREETYPE_PACKAGE) \
	$(FREETYPE_SITE)/$(FREETYPE_PACKAGE)

$(FREETYPE_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(FREETYPE_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(FREETYPE_PACKAGE)
	@touch $@

$(FREETYPE_BUILD_DIR)/.configured:
	$(Q)cd $(FREETYPE_BUILD_DIR); \
	PKG_CONFIG=$(PKGCONFIG_BIN) \
	PKG_CONFIG_PATH=$(ROOTFS)/usr/lib/pkgconfig \
	PKG_CONFIG_SYSROOT_DIR=$(ROOTFS) \
	CC=$(TARGETCC_CACHED) CFLAGS=$(TARGET_CFLAGS) \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--prefix=/usr \
	--datarootdir=$(SYSROOT)/usr --enable-static=no
	@touch $@

$(FREETYPE_BUILD_DIR)/.freetype-configpatched:
	$(Q)cd $(ROOTFS)/usr/bin; \
	cat freetype-config | \
	sed -e 's;prefix=/usr;prefix=$(ROOTFS)/usr;' \
	-e 's;includedir=$${prefix}/include;includedir=$(SYSROOT)/usr/include;' \
	> freetype-config.new;\
	cp freetype-config.new freetype-config; rm freetype-config.new

$(FREETYPE_BUILD_DIR)/.libtoolpatched:
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)cd $(ROOTFS)/usr/lib32; \
	cat libfreetype.la | sed -e 's;\/usr\/lib;$(ROOTFS)\/usr\/lib32;' \
	> libfreetype.la.new;\
	cp libfreetype.la.new libfreetype.la; rm  libfreetype.la.new
else
	$(Q)cd $(ROOTFS)/usr/lib; \
	cat libfreetype.la | sed -e 's;\/usr\/lib;$(ROOTFS)\/usr\/lib;' \
	> libfreetype.la.new;\
	cp libfreetype.la.new libfreetype.la; rm  libfreetype.la.new
endif

$(FREETYPE_BUILD_DIR)/.pkgconfigpatched:
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)cd $(ROOTFS)/usr/lib32/pkgconfig;\
	cat freetype2.pc | sed -e 's;prefix=/usr;prefix=$(ROOTFS)/usr;' \
	-e 's;includedir=$${prefix}/include;includedir=$(SYSROOT)/usr/include;' \
	> freetype2.pc.new;\
	cp freetype2.pc.new freetype2.pc; rm freetype2.pc.new freetype2.pc.tmp
else
	$(Q)cd $(ROOTFS)/usr/lib/pkgconfig; \
	cat freetype2.pc | sed -e 's;prefix=/usr;prefix=$(ROOTFS)/usr;' \
	-e 's;includedir=$${prefix}/include;includedir=$(SYSROOT)/usr/include;' \
	> freetype2.pc.new;\
	cp freetype2.pc.new freetype2.pc; rm freetype2.pc.new
endif

