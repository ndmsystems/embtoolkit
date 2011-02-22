################################################################################
# Embtoolkit
# Copyright(C) 2010-2011 Abdoulaye Walsimou GAYE. All rights reserved.
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
# \file         libxcb.mk
# \brief	libxcb.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

LIBXCB_NAME := libxcb
LIBXCB_VERSION := $(call EMBTK_GET_PKG_VERSION,LIBXCB)
LIBXCB_SITE := http://xcb.freedesktop.org/dist
LIBXCB_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
LIBXCB_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/libxcb/$(LIBXCB_VERSION)
LIBXCB_PACKAGE := libxcb-$(LIBXCB_VERSION).tar.gz
LIBXCB_SRC_DIR := $(PACKAGES_BUILD)/libxcb-$(LIBXCB_VERSION)
LIBXCB_BUILD_DIR := $(PACKAGES_BUILD)/libxcb-$(LIBXCB_VERSION)

LIBXCB_BINS =
LIBXCB_SBINS =
LIBXCB_INCLUDES = xcb
LIBXCB_LIBS = libxcb*
LIBXCB_PKGCONFIGS = xcb*.pc

LIBXCB_CONFIGURE_OPTS := --enable-xinput

LIBXCB_DEPS = xcbproto_install libpthreadstubs_install libxau_install

libxcb_install:
	@test -e $(LIBXCB_BUILD_DIR)/.installed || \
	$(MAKE) $(LIBXCB_BUILD_DIR)/.installed

$(LIBXCB_BUILD_DIR)/.installed: $(LIBXCB_DEPS) download_libxcb \
	$(LIBXCB_BUILD_DIR)/.decompressed $(LIBXCB_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	libxcb-$(LIBXCB_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(LIBXCB_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBXCB_BUILD_DIR) DESTDIR=$(SYSROOT)/ install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	$(Q)$(MAKE) $(LIBXCB_BUILD_DIR)/.patchlibtool
	@touch $@

download_libxcb:
	$(call EMBTK_DOWNLOAD_PKG,LIBXCB)

$(LIBXCB_BUILD_DIR)/.decompressed:
	$(call EMBTK_DECOMPRESS_PKG,LIBXCB)

$(LIBXCB_BUILD_DIR)/.configured:
	$(call EMBTK_CONFIGURE_PKG,LIBXCB)

libxcb_clean:
	$(call EMBTK_CLEANUP_PKG,LIBXCB)

$(LIBXCB_BUILD_DIR)/.patchlibtool:
	@LIBXCB_LT_FILES=`find $(SYSROOT)/usr/$(LIBDIR)/libxcb-* -type f -name *.la`; \
	for i in $$LIBXCB_LT_FILES; \
	do \
	sed \
	-i "s; /usr/$(LIBDIR)/libxcb.la ; $(SYSROOT)/usr/$(LIBDIR)/libxcb.la ;" $$i; \
	done

