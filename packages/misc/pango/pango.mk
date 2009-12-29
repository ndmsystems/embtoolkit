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
# \file         pango.mk
# \brief	pango.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         December 2009
################################################################################

PANGO_MAJOR_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_PANGO_MAJOR_VERSION_STRING)))
PANGO_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_PANGO_VERSION_STRING)))
PANGO_SITE := http://ftp.gnome.org/pub/gnome/sources/pango/$(PANGO_MAJOR_VERSION)
PANGO_PACKAGE := pango-$(PANGO_VERSION).tar.bz2
PANGO_BUILD_DIR := $(PACKAGES_BUILD)/pango-$(PANGO_VERSION)

PANGO_BINS = pango*
PANGO_SBINS =
PANGO_INCLUDES = pango*
PANGO_LIBS = pango-* pango* libpango*
PANGO_PKGCONFIGS = pango*.pc

ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
PKG_CONFIG_PATH=$(SYSROOT)/usr/lib32/pkgconfig
else
PKG_CONFIG_PATH=$(SYSROOT)/usr/lib/pkgconfig
endif

pango_install: $(PANGO_BUILD_DIR)/.installed $(PANGO_BUILD_DIR)/.special

$(PANGO_BUILD_DIR)/.installed: $(GLIB_BUILD_DIR)/.installed \
	$(FONTCONFIG_BUILD_DIR)/.installed $(CAIRO_BUILD_DIR)/.installed \
	download_pango $(PANGO_BUILD_DIR)/.decompressed \
	$(PANGO_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	pango-$(PANGO_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH, $(PANGO_BUILD_DIR))
	$(Q)$(MAKE) -C $(PANGO_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(PANGO_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	$(Q)$(MAKE) $(PANGO_BUILD_DIR)/.patchlibtool
	@touch $@

download_pango:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(PANGO_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(PANGO_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(PANGO_PACKAGE) \
	$(PANGO_SITE)/$(PANGO_PACKAGE)

$(PANGO_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(PANGO_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(PANGO_PACKAGE)
	@touch $@

$(PANGO_BUILD_DIR)/.configured:
	$(Q)cd $(PANGO_BUILD_DIR); \
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
	LDFLAGS="-L$(SYSROOT)/lib -L$(SYSROOT)/usr/lib \
	-L$(SYSROOT)/lib32 -L$(SYSROOT)/usr/lib32" \
	CPPFLGAS="-I$(SYSROOT)/usr/include" \
	PKG_CONFIG=$(PKGCONFIG_BIN) \
	PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
	PKG_CONFIG_LIBDIR=$(SYSROOT)/usr/lib \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) \
	--prefix=/usr --without-x
	@touch $@

$(PANGO_BUILD_DIR)/.patchlibtool:
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)PANGO_LT_FILES=`find $(SYSROOT)/usr/lib32/pango/* -type f -name *.la`; \
	for i in $$PANGO_LT_FILES; \
	do \
	sed \
	-e "s; \/usr\/lib32\/libpangoft2-1.0.la ; $(SYSROOT)\/usr\/lib32\/libpangoft2-1.0.la ;" \
	-e "s; \/usr\/lib32\/libpango-1.0.la ; $(SYSROOT)\/usr\/lib32\/libpango-1.0.la ;" \
	< $$i > $$i.new; \
	mv $$i.new $$i; \
	done
else
	$(Q)PANGO_LT_FILES=`find $(SYSROOT)/usr/lib/* -type f -name *.la`; \
	for i in $$PANGO_LT_FILES; \
	do \
	sed \
	-e "s; \/usr\/lib\/libpangoft2-1.0.la ; $(SYSROOT)\/usr\/lib\/libpangoft2-1.0.la ;" \
	-e "s; \/usr\/lib\/libpango-1.0.la ; $(SYSROOT)\/usr\/lib\/libpango-1.0.la ;" \
	< $$i > $$i.new; \
	mv $$i.new $$i; \
	done
endif

.PHONY: pango_clean $(PANGO_BUILD_DIR)/.special

$(PANGO_BUILD_DIR)/.special:
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cp -R $(SYSROOT)/usr/lib32/pango $(ROOTFS)/usr/lib32/
else
	$(Q)-cp -R $(SYSROOT)/usr/lib/pango $(ROOTFS)/usr/lib/
endif
	@touch $@

pango_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup pango-$(PANGO_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(PANGO_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(PANGO_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(PANGO_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/lib; rm -rf $(PANGO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib/pkgconfig; rm -rf $(PANGO_PKGCONFIGS)
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cd $(SYSROOT)/usr/lib32; rm -rf $(PANGO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib32/pkgconfig; rm -rf $(PANGO_PKGCONFIGS)
endif

