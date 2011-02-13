################################################################################
# Embtoolkit
# Copyright(C) 2009-2011 Abdoulaye Walsimou GAYE. All rights reserved.
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
# \file         pango.mk
# \brief	pango.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

PANGO_NAME := pango
PANGO_MAJOR_VERSION := $(call EMBTK_GET_PKG_VERSION,PANGO_MAJOR)
PANGO_VERSION := $(call EMBTK_GET_PKG_VERSION,PANGO)
PANGO_SITE := http://ftp.gnome.org/pub/gnome/sources/pango/$(PANGO_MAJOR_VERSION)
PANGO_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
PANGO_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/pango/$(PANGO_VERSION)
PANGO_PACKAGE := pango-$(PANGO_VERSION).tar.bz2
PANGO_SRC_DIR := $(PACKAGES_BUILD)/pango-$(PANGO_VERSION)
PANGO_BUILD_DIR := $(PACKAGES_BUILD)/pango-$(PANGO_VERSION)

PANGO_BINS = pango*
PANGO_SBINS =
PANGO_INCLUDES = pango*
PANGO_LIBS = pango-* pango* libpango*
PANGO_PKGCONFIGS = pango*.pc

ifeq ($(CONFIG_EMBTK_HAVE_PANGO_WITH_X),y)
PANGO_CONFIGURE_OPTS := --with-x
PANGO_DEPS := libx11_install
else
PANGO_CONFIGURE_OPTS := --without-x
endif

PANGO_DEPS += glib_install fontconfig_install cairo_install

pango_install:
	@test -e $(PANGO_BUILD_DIR)/.installed || \
	$(MAKE) $(PANGO_BUILD_DIR)/.installed
	$(Q)$(MAKE) $(PANGO_BUILD_DIR)/.special

$(PANGO_BUILD_DIR)/.installed: $(PANGO_DEPS) download_pango \
	$(PANGO_BUILD_DIR)/.decompressed $(PANGO_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	pango-$(PANGO_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(PANGO_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(PANGO_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	$(Q)$(MAKE) $(PANGO_BUILD_DIR)/.patchlibtool
	@touch $@

download_pango:
	$(call EMBTK_DOWNLOAD_PKG,PANGO)

$(PANGO_BUILD_DIR)/.decompressed:
	$(call EMBTK_DECOMPRESS_PKG,PANGO)

$(PANGO_BUILD_DIR)/.configured:
	$(call EMBTK_CONFIGURE_PKG,PANGO)

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
	@touch $@

pango_clean:
	$(call EMBTK_CLEANUP_PKG,PANGO)
