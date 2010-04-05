################################################################################
# GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# Copyright(C) 2009-2010 GAYE Abdoulaye Walsimou. All rights reserved.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
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
# \file         freetype.mk
# \brief	freetype.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         October 2009
################################################################################

FREETYPE_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_FREETYPE_VERSION_STRING)))
FREETYPE_SITE := http://downloads.sourceforge.net/project/freetype/freetype2/$(FREETYPE_VERSION)
FREETYPE_PACKAGE := freetype-$(FREETYPE_VERSION).tar.bz2
FREETYPE_BUILD_DIR := $(PACKAGES_BUILD)/freetype-$(FREETYPE_VERSION)

FREETYPE_BINS = freetype*
FREETYPE_SBINS =
FREETYPE_INCLUDES = ft*build.h freetype*
FREETYPE_LIBS = libfreetype*
FREETYPE_PKGCONFIGS = freetype*.pc

freetype_install: $(FREETYPE_BUILD_DIR)/.installed

$(FREETYPE_BUILD_DIR)/.installed: zlib_target_install download_freetype \
	$(FREETYPE_BUILD_DIR)/.decompressed $(FREETYPE_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	freetype-$(FREETYPE_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH, $(FREETYPE_BUILD_DIR))
	$(Q)$(MAKE) -C $(FREETYPE_BUILD_DIR) $(J) \
	LIBTOOL=$(FREETYPE_BUILD_DIR)/builds/unix/libtool
	$(Q)$(MAKE) -C $(FREETYPE_BUILD_DIR) \
	LIBTOOL=$(FREETYPE_BUILD_DIR)/builds/unix/libtool \
	DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	$(Q)$(MAKE) $(FREETYPE_BUILD_DIR)/.freetype-configpatched
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
	CC=$(TARGETCC_CACHED) \
	CXX=$(TARGETCXX_CACHED) \
	AR=$(TARGETAR) \
	RANLIB=$(TARGETRANLIB) \
	AS=$(CROSS_COMPILE)as \
	LD=$(TARGETLD) \
	NM=$(TARGETNM) \
	STRIP=$(TARGETSTRIP) \
	OBJDUMP=$(TARGETOBJDUMP) \
	OBJCOPY=$(TARGETOBJCOPY) \
	CFLAGS="$(TARGET_CFLAGS)" \
	CXXFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="-L$(SYSROOT)/$(LIBDIR) -L$(SYSROOT)/usr/$(LIBDIR)" \
	CPPFLGAS="-I$(SYSROOT)/usr/include" \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--prefix=/usr --enable-static=no --libdir=/usr/$(LIBDIR)
	@touch $@

$(FREETYPE_BUILD_DIR)/.freetype-configpatched:
	$(Q)cd $(ROOTFS)/usr/bin; \
	cat freetype-config | \
	sed -e 's;prefix=/usr;prefix=$(ROOTFS)/usr;' \
	-e 's;includedir=$${prefix}/include;includedir=$(SYSROOT)/usr/include;' \
	> freetype-config.new;\
	cp freetype-config.new freetype-config; rm freetype-config.new

freetype_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup freetype-$(FREETYPE_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(FREETYPE_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(FREETYPE_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(FREETYPE_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/lib; rm -rf $(FREETYPE_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib/pkgconfig; rm -rf $(FREETYPE_PKGCONFIGS)
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cd $(SYSROOT)/usr/lib32; rm -rf $(FREETYPE_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib32/pkgconfig; rm -rf $(FREETYPE_PKGCONFIGS)
endif

