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
# \file         libxcb.mk
# \brief	libxcb.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         March 2010
################################################################################

LIBXCB_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_LIBXCB_VERSION_STRING)))
LIBXCB_SITE := http://xcb.freedesktop.org/dist
LIBXCB_PACKAGE := libxcb-$(LIBXCB_VERSION).tar.gz
LIBXCB_BUILD_DIR := $(PACKAGES_BUILD)/libxcb-$(LIBXCB_VERSION)

LIBXCB_BINS =
LIBXCB_SBINS =
LIBXCB_INCLUDES = xcb
LIBXCB_LIBS = libxcb*
LIBXCB_PKGCONFIGS = xcb*

LIBXCB_DEPS = xcbproto_install libpthreadstubs_install libxau_install

libxcb_install: $(LIBXCB_BUILD_DIR)/.installed

$(LIBXCB_BUILD_DIR)/.installed: $(LIBXCB_DEPS) download_libxcb \
	$(LIBXCB_BUILD_DIR)/.decompressed $(LIBXCB_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	libxcb-$(LIBXCB_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH,$(LIBXCB_BUILD_DIR))
	$(Q)$(MAKE) -C $(LIBXCB_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBXCB_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	$(Q)$(MAKE) $(LIBXCB_BUILD_DIR)/.patchlibtool
	@touch $@

download_libxcb:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(LIBXCB_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(LIBXCB_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(LIBXCB_PACKAGE) \
	$(LIBXCB_SITE)/$(LIBXCB_PACKAGE)

$(LIBXCB_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LIBXCB_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzf $(DOWNLOAD_DIR)/$(LIBXCB_PACKAGE)
	@touch $@

$(LIBXCB_BUILD_DIR)/.configured:
	$(Q)cd $(LIBXCB_BUILD_DIR); \
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

libxcb_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup libxcb-$(LIBXCB_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(LIBXCB_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(LIBXCB_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(LIBXCB_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(LIBXCB_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(LIBXCB_PKGCONFIGS)

$(LIBXCB_BUILD_DIR)/.patchlibtool:
	@LIBXCB_LT_FILES=`find $(SYSROOT)/usr/$(LIBDIR)/libxcb-* -type f -name *.la`; \
	for i in $$LIBXCB_LT_FILES; \
	do \
	sed \
	-i "s; /usr/$(LIBDIR)/libxcb.la ; $(SYSROOT)/usr/$(LIBDIR)/libxcb.la ;" $$i; \
	done

