################################################################################
# Embtoolkit
# Copyright(C) 2009-2010 Abdoulaye Walsimou GAYE. All rights reserved.
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
# \file         pango.mk
# \brief	pango.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
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

PANGO_DEPS := glib_install fontconfig_install cairo_install

pango_install:
	@test -e $(PANGO_BUILD_DIR)/.installed || \
	$(MAKE) $(PANGO_BUILD_DIR)/.installed
	$(Q)$(MAKE) $(PANGO_BUILD_DIR)/.special

$(PANGO_BUILD_DIR)/.installed: $(PANGO_DEPS) download_pango \
	$(PANGO_BUILD_DIR)/.decompressed $(PANGO_BUILD_DIR)/.configured
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
	LDFLAGS="-L$(SYSROOT)/$(LIBDIR) -L$(SYSROOT)/usr/$(LIBDIR)" \
	CPPFLGAS="-I$(SYSROOT)/usr/include" \
	PKG_CONFIG=$(PKGCONFIG_BIN) \
	PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
	PKG_CONFIG_LIBDIR=$(SYSROOT)/usr/lib \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) --libdir=/usr/$(LIBDIR) \
	--prefix=/usr --without-x
	@touch $@

$(PANGO_BUILD_DIR)/.patchlibtool:
	$(Q)PANGO_LT_FILES=`find $(SYSROOT)/usr/$(LIBDIR)/* -type f -name *.la`; \
	for i in $$PANGO_LT_FILES; \
	do \
	sed \
	-e "s;\/usr\/$(LIBDIR)\/libpangoft2-1.0.la ; $(SYSROOT)\/usr\/$(LIBDIR)\/libpangoft2-1.0.la ;" \
	-e "s;\/usr\/$(LIBDIR)\/libpango-1.0.la ; $(SYSROOT)\/usr\/$(LIBDIR)\/libpango-1.0.la ;" \
	< $$i > $$i.new; \
	mv $$i.new $$i; \
	done

.PHONY: pango_clean $(PANGO_BUILD_DIR)/.special

$(PANGO_BUILD_DIR)/.special:
	$(Q)-cp -R $(SYSROOT)/usr/$(LIBDIR)/pango $(ROOTFS)/usr/$(LIBDIR)/

pango_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup pango-$(PANGO_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(PANGO_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(PANGO_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(PANGO_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(PANGO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(PANGO_PKGCONFIGS)
	$(Q)-rm -rf $(PANGO_BUILD_DIR)*

