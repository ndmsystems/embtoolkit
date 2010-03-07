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
# \file         xcbdemo.mk
# \brief	xcbdemo.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         March 2010
################################################################################

XCBDEMO_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_XCBDEMO_VERSION_STRING)))
XCBDEMO_SITE := http://xcb.freedesktop.org/dist
XCBDEMO_PACKAGE := xcb-demo-$(XCBDEMO_VERSION).tar.bz2
XCBDEMO_BUILD_DIR := $(PACKAGES_BUILD)/xcb-demo-$(XCBDEMO_VERSION)

XCBDEMO_BINS =
XCBDEMO_SBINS =
XCBDEMO_INCLUDES =
XCBDEMO_LIBS =
XCBDEMO_PKGCONFIGS =

XCBDEMO_DEPS = xcbutil_install

xcbdemo_install: $(XCBDEMO_BUILD_DIR)/.installed

$(XCBDEMO_BUILD_DIR)/.installed: download_xcbdemo \
	$(XCBDEMO_BUILD_DIR)/.decompressed $(XCBDEMO_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	xcbdemo-$(XCBDEMO_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(XCBDEMO_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(XCBDEMO_BUILD_DIR) DESTDIR=$(SYSROOT)/testxcbdemo install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_xcbdemo:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(XCBDEMO_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(XCBDEMO_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(XCBDEMO_PACKAGE) \
	$(XCBDEMO_SITE)/$(XCBDEMO_PACKAGE)

$(XCBDEMO_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(XCBDEMO_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjf $(DOWNLOAD_DIR)/$(XCBDEMO_PACKAGE)
	@touch $@

$(XCBDEMO_BUILD_DIR)/.configured:
	$(Q)cd $(XCBDEMO_BUILD_DIR); \
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
	CFLAGS="$(TARGET_CFLAGS) -I$(SYSROOT)/usr/include -I$(SYSROOT)/usr/include/xcb" \
	CXXFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="-L$(SYSROOT)/$(LIBDIR) -L$(SYSROOT)/usr/$(LIBDIR)" \
	CPPFLGAS="-I$(SYSROOT)/usr/include -I$(SYSROOT)/usr/include/xcb" \
	PKG_CONFIG=$(PKGCONFIG_BIN) \
	PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) --libdir=/usr/$(LIBDIR) \
	--prefix=/usr
	@touch $@

xcbdemo_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup xcbdemo-$(XCBDEMO_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(XCBDEMO_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(XCBDEMO_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(XCBDEMO_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(XCBDEMO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(XCBDEMO_PKGCONFIGS)

$(XCBDEMO_BUILD_DIR)/.x11patch:
	@XCBDEMO_C_FILES=`find $(XCBDEMO_BUILD_DIR)/tests -type f`; \
	for i in $$XCBDEMO_C_FILES; \
	do \
	sed \
	-i "s;X11/XCB/;;g" $$i; \
	done

