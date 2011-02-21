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
# \file         libpthreadstubs.mk
# \brief	libpthreadstubs.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

LIBPTHREADSTUBS_NAME := libpthread-stubs
LIBPTHREADSTUBS_VERSION := $(call EMBTK_GET_PKG_VERSION,LIBPTHREADSTUBS)
LIBPTHREADSTUBS_SITE := http://xcb.freedesktop.org/dist
LIBPTHREADSTUBS_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
LIBPTHREADSTUBS_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/libpthreadstubs/$(LIBPTHREADSTUBS_VERSION)
LIBPTHREADSTUBS_PACKAGE := libpthread-stubs-$(LIBPTHREADSTUBS_VERSION).tar.bz2
LIBPTHREADSTUBS_SRC_DIR := $(PACKAGES_BUILD)/libpthread-stubs-$(LIBPTHREADSTUBS_VERSION)
LIBPTHREADSTUBS_BUILD_DIR := $(PACKAGES_BUILD)/libpthread-stubs-$(LIBPTHREADSTUBS_VERSION)

LIBPTHREADSTUBS_BINS =
LIBPTHREADSTUBS_SBINS =
LIBPTHREADSTUBS_INCLUDES =
LIBPTHREADSTUBS_LIBS =
LIBPTHREADSTUBS_PKGCONFIGS = pthread-stubs.pc

libpthreadstubs_install:
	@test -e $(LIBPTHREADSTUBS_BUILD_DIR)/.installed || \
	$(MAKE) $(LIBPTHREADSTUBS_BUILD_DIR)/.installed

$(LIBPTHREADSTUBS_BUILD_DIR)/.installed: download_libpthreadstubs \
	$(LIBPTHREADSTUBS_BUILD_DIR)/.decompressed $(LIBPTHREADSTUBS_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	libpthreadstubs-$(LIBPTHREADSTUBS_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(LIBPTHREADSTUBS_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBPTHREADSTUBS_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_libpthreadstubs:
	$(call EMBTK_DOWNLOAD_PKG,LIBPTHREADSTUBS)

$(LIBPTHREADSTUBS_BUILD_DIR)/.decompressed:
	$(call EMBTK_DECOMPRESS_PKG,LIBPTHREADSTUBS)

$(LIBPTHREADSTUBS_BUILD_DIR)/.configured:
	$(call EMBTK_CONFIGURE_PKG,LIBPTHREADSTUBS)

libpthreadstubs_clean:
	$(call EMBTK_CLEANUP_PKG,LIBPTHREADSTUBS)
