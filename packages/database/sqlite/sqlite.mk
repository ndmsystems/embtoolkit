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
# \file         sqlite.mk
# \brief	sqlite.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         October 2010
################################################################################

SQLITE_NAME := sqlite
SQLITE_VERSION := $(call EMBTK_GET_PKG_VERSION,SQLITE)
SQLITE_SITE := http://www.sqlite.org
SQLITE_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
SQLITE_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/sqlite/$(SQLITE_VERSION)
SQLITE_PACKAGE := sqlite-amalgamation-$(SQLITE_VERSION).tar.gz
SQLITE_SRC_DIR := $(PACKAGES_BUILD)/sqlite-$(SQLITE_VERSION)
SQLITE_BUILD_DIR := $(PACKAGES_BUILD)/sqlite-$(SQLITE_VERSION)

SQLITE_BINS = sqlite3
SQLITE_SBINS =
SQLITE_INCLUDES = sqlite3.h sqlite3ext.h
SQLITE_LIBS = libsqlite3.*
SQLITE_PKGCONFIGS = sqlite3.pc

SQLITE_CONFIGURE_OPTS := --enable-threadsafe --enable-readline \
	--enable-threadsafe --enable-dynamic-extensions
	

SQLITE_DEPS :=

sqlite_install:
	@test -e $(SQLITE_BUILD_DIR)/.installed || \
	$(MAKE) $(SQLITE_BUILD_DIR)/.installed

$(SQLITE_BUILD_DIR)/.installed: $(SQLITE_DEPS) download_sqlite \
	$(SQLITE_BUILD_DIR)/.decompressed $(SQLITE_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	sqlite-$(SQLITE_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(SQLITE_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(SQLITE_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_sqlite:
	$(call EMBTK_DOWNLOAD_PKG,SQLITE)

$(SQLITE_BUILD_DIR)/.decompressed:
	$(call EMBTK_DECOMPRESS_PKG,SQLITE)

$(SQLITE_BUILD_DIR)/.configured:
	$(call EMBTK_CONFIGURE_PKG,SQLITE)

sqlite_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup sqlite...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(SQLITE_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(SQLITE_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(SQLITE_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(SQLITE_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(SQLITE_PKGCONFIGS)
	$(Q)-rm -rf $(SQLITE_BUILD_DIR)*

