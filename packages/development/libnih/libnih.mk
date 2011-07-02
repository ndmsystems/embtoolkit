################################################################################
# Embtoolkit
# Copyright(C) 2009-2011 Abdoulaye Walsimou GAYE.
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
# \file         libnih.mk
# \brief	libnih.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

LIBNIH_NAME := libnih
LIBNIH_VERSION := $(call embtk_get_pkgversion,LIBNIH)
LIBNIH_MAJOR_VERSION := $(call embtk_get_pkgversion,LIBNIH_MAJOR)
LIBNIH_SITE := http://launchpad.net/libnih/$(LIBNIH_MAJOR_VERSION)/$(LIBNIH_VERSION)/+download
LIBNIH_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
LIBNIH_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/libnih/$(LIBNIH_VERSION)
LIBNIH_PACKAGE := libnih-$(LIBNIH_VERSION).tar.gz
LIBNIH_SRC_DIR := $(PACKAGES_BUILD)/libnih-$(LIBNIH_VERSION)
LIBNIH_BUILD_DIR := $(PACKAGES_BUILD)/libnih-$(LIBNIH_VERSION)

LIBNIH_BINS = nih-dbus-tool
LIBNIH_SBINS =
LIBNIH_INCLUDES = libnih-dbus.h libnih.h nih nih-dbus
LIBNIH_LIBS = libnih*
LIBNIH_PKGCONFIGS = libnih-dbus.pc libnih.pc

LIBNIH_DEPS := dbus_install

libnih_install:
	@test -e $(LIBNIH_BUILD_DIR)/.installed || \
	$(MAKE) $(LIBNIH_BUILD_DIR)/.installed

$(LIBNIH_BUILD_DIR)/.installed: $(LIBNIH_DEPS) download_libnih \
	$(LIBNIH_BUILD_DIR)/.decompressed $(LIBNIH_BUILD_DIR)/.configured
	$(call embtk_generic_message,"Compiling and installing \
	libnih-$(LIBNIH_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(LIBNIH_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBNIH_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_libnih:
	$(call embtk_download_pkg,LIBNIH)

$(LIBNIH_BUILD_DIR)/.decompressed:
	$(call embtk_decompress_pkg,LIBNIH)

$(LIBNIH_BUILD_DIR)/.configured:
	$(call embtk_configure_pkg,LIBNIH)

libnih_clean:
	$(call embtk_cleanup_pkg,LIBNIH)
