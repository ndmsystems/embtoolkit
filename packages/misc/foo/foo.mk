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
# \file         foo.mk
# \brief	foo.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         December 2009
################################################################################

FOO_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_FOO_VERSION_STRING)))
FOO_SITE := http://www.foo.org/download
FOO_PACKAGE := foo-$(FOO_VERSION).tar.gz
FOO_BUILD_DIR := $(PACKAGES_BUILD)/foo-$(FOO_VERSION)

FOO_BINS =
FOO_SBINS =
FOO_INCLUDES =
FOO_LIBS =
FOO_PKGCONFIGS =

foo_install: $(FOO_BUILD_DIR)/.installed

$(FOO_BUILD_DIR)/.installed: download_foo \
	$(FOO_BUILD_DIR)/.decompressed $(FOO_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	foo-$(FOO_VERSION) in your root filesystem...")
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

$(FOO_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(FOO_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzf $(DOWNLOAD_DIR)/$(FOO_PACKAGE)
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
	LDFLAGS="-L$(SYSROOT)/lib -L$(SYSROOT)/usr/lib \
	-L$(SYSROOT)/lib32 -L$(SYSROOT)/usr/lib32" \
	CPPFLGAS="-I$(SYSROOT)/usr/include" \
	PKG_CONFIG=$(PKGCONFIG_BIN) \
	PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) \
	--prefix=/usr
	@touch $@

foo_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup foo-$(FOO_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(FOO_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(FOO_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(FOO_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/lib; rm -rf $(FOO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib/pkgconfig; rm -rf $(FOO_PKGCONFIGS)
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cd $(SYSROOT)/usr/lib32; rm -rf $(FOO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib32/pkgconfig; rm -rf $(FOO_PKGCONFIGS)
endif

