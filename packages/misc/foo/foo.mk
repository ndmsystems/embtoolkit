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

FOO_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_FOO_VERSION_STRING)))
FOO_SITE := http://www.foo.org/download
FOO_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/foo/$(FOO_VERSION)
FOO_PACKAGE := foo-$(FOO_VERSION).tar.gz
FOO_BUILD_DIR := $(PACKAGES_BUILD)/foo-$(FOO_VERSION)

FOO_BINS =
FOO_SBINS =
FOO_INCLUDES =
FOO_LIBS =
FOO_PKGCONFIGS =

FOO_DEPS :=

foo_install:
	@test -e $(FOO_BUILD_DIR)/.installed || \
	$(MAKE) $(FOO_BUILD_DIR)/.installed

$(FOO_BUILD_DIR)/.installed: $(FOO_DEPS) download_foo \
	$(FOO_BUILD_DIR)/.decompressed $(FOO_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	foo-$(FOO_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH,$(FOO_BUILD_DIR))
	$(Q)$(MAKE) -C $(FOO_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(FOO_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_foo:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(FOO_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(FOO_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(FOO_PACKAGE) \
	$(FOO_SITE)/$(FOO_PACKAGE)
ifeq ($(CONFIG_EMBTK_FOO_NEED_PATCH),y)
	@test -e $(DOWNLOAD_DIR)/foo-$(FOO_VERSION).patch || \
	wget -O $(DOWNLOAD_DIR)/foo-$(FOO_VERSION).patch \
	$(FOO_PATCH_SITE)/foo-$(FOO_VERSION)-*.patch
endif

$(FOO_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(FOO_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzf $(DOWNLOAD_DIR)/$(FOO_PACKAGE)
ifeq ($(CONFIG_EMBTK_FOO_NEED_PATCH),y)
	@cd $(FOO_BUILD_DIR); \
	patch -p1 < $(DOWNLOAD_DIR)/foo-$(FOO_VERSION).patch
endif
	@touch $@

$(FOO_BUILD_DIR)/.configured:
	$(Q)cd $(FOO_BUILD_DIR); \
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
	CPPFLAGS="-I$(SYSROOT)/usr/include" \
	PKG_CONFIG=$(PKGCONFIG_BIN) \
	PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) --libdir=/usr/$(LIBDIR) \
	--prefix=/usr
	@touch $@

foo_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup foo...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(FOO_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(FOO_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(FOO_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(FOO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(FOO_PKGCONFIGS)
	$(Q)-rm -rf $(FOO_BUILD_DIR)*

