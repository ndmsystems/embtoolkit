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
# \file         foo.mk
# \brief	foo.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

FOO_NAME := foo
FOO_VERSION := $(call EMBTK_GET_PKG_VERSION,FOO)
FOO_SITE := http://www.foo.org/download
FOO_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
FOO_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/foo/$(FOO_VERSION)
FOO_PACKAGE := foo-$(FOO_VERSION).tar.gz
FOO_BUILD_DIR := $(PACKAGES_BUILD)/foo-$(FOO_VERSION)
FOO_BUILD_SRC := $(PACKAGES_BUILD)/foo-$(FOO_VERSION)

FOO_BINS =
FOO_SBINS =
FOO_INCLUDES =
FOO_LIBS =
FOO_PKGCONFIGS =

FOO_CONFIGURE_OPTS :=

FOO_DEPS :=

foo_install:
	@test -e $(FOO_BUILD_DIR)/.installed || \
	$(MAKE) $(FOO_BUILD_DIR)/.installed

$(FOO_BUILD_DIR)/.installed: $(FOO_DEPS) download_foo \
	$(FOO_BUILD_DIR)/.decompressed $(FOO_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	foo-$(FOO_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(FOO_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(FOO_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_foo:
	$(call EMBTK_DOWNLOAD_PKG,FOO)

$(FOO_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(FOO_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzf $(DOWNLOAD_DIR)/$(FOO_PACKAGE)
ifeq ($(CONFIG_EMBTK_FOO_NEED_PATCH),y)
	@cd $(FOO_BUILD_DIR); \
	patch -p1 < $(DOWNLOAD_DIR)/foo-$(FOO_VERSION).patch
endif
	@touch $@

$(FOO_BUILD_DIR)/.configured:
	$(call EMBTK_CONFIGURE_PKG,FOO)

foo_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup foo...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(FOO_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(FOO_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(FOO_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(FOO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(FOO_PKGCONFIGS)
	$(Q)-rm -rf $(FOO_BUILD_DIR)*

