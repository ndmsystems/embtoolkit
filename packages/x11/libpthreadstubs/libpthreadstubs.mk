################################################################################
# GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# Copyright(C) 2010 GAYE Abdoulaye Walsimou. All rights reserved.
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
# \file         libpthreadstubs.mk
# \brief	libpthreadstubs.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         March 2010
################################################################################

LIBPTHREADSTUBS_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_LIBPTHREADSTUBS_VERSION_STRING)))
LIBPTHREADSTUBS_SITE := http://xcb.freedesktop.org/dist
LIBPTHREADSTUBS_PACKAGE := libpthread-stubs-$(LIBPTHREADSTUBS_VERSION).tar.bz2
LIBPTHREADSTUBS_BUILD_DIR := $(PACKAGES_BUILD)/libpthread-stubs-$(LIBPTHREADSTUBS_VERSION)

LIBPTHREADSTUBS_BINS =
LIBPTHREADSTUBS_SBINS =
LIBPTHREADSTUBS_INCLUDES =
LIBPTHREADSTUBS_LIBS =
LIBPTHREADSTUBS_PKGCONFIGS = pthread-stubs.pc

libpthreadstubs_install: $(LIBPTHREADSTUBS_BUILD_DIR)/.installed

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
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(LIBPTHREADSTUBS_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(LIBPTHREADSTUBS_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(LIBPTHREADSTUBS_PACKAGE) \
	$(LIBPTHREADSTUBS_SITE)/$(LIBPTHREADSTUBS_PACKAGE)

$(LIBPTHREADSTUBS_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LIBPTHREADSTUBS_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(LIBPTHREADSTUBS_PACKAGE)
	@touch $@

$(LIBPTHREADSTUBS_BUILD_DIR)/.configured:
	$(Q)cd $(LIBPTHREADSTUBS_BUILD_DIR); \
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
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) \
	--prefix=/usr --libdir=/usr/$(LIBDIR)
	@touch $@

libpthreadstubs_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup libpthreadstubs-$(LIBPTHREADSTUBS_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(LIBPTHREADSTUBS_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(LIBPTHREADSTUBS_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(LIBPTHREADSTUBS_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(LIBPTHREADSTUBS_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(LIBPTHREADSTUBS_PKGCONFIGS)

