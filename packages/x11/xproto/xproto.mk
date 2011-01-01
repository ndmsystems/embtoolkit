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
# \file         xproto.mk
# \brief	xproto.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

XPROTO_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_XPROTO_VERSION_STRING)))
XPROTO_SITE := http://ftp.x.org/pub/individual/proto
XPROTO_PACKAGE := xproto-$(XPROTO_VERSION).tar.bz2
XPROTO_BUILD_DIR := $(PACKAGES_BUILD)/xproto-$(XPROTO_VERSION)

XPROTO_BINS =
XPROTO_SBINS =
XPROTO_INCLUDES = X11/keysymdef.h X11/Xalloca.h X11/Xatom.h X11/XF86keysym.h \
		X11/Xfuncs.h Xmd.h X11/Xos.h X11/Xpoll.h X11/Xprotostr.h \
		X11/keysym.h X11/Xarch.h X11/Xdefs.h X11/Xfuncproto.h X11/X.h \
		X11/Xosdefs.h  X11/Xos_r.h X11/Xproto.h X11/Xthreads.h
XPROTO_LIBS =
XPROTO_PKGCONFIGS = xproto.pc

xproto_install:
	@test -e $(XPROTO_BUILD_DIR)/.installed || \
	$(MAKE) $(XPROTO_BUILD_DIR)/.installed

$(XPROTO_BUILD_DIR)/.installed: download_xproto \
	$(XPROTO_BUILD_DIR)/.decompressed $(XPROTO_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	xproto-$(XPROTO_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(XPROTO_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(XPROTO_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_xproto:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(XPROTO_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(XPROTO_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(XPROTO_PACKAGE) \
	$(XPROTO_SITE)/$(XPROTO_PACKAGE)

$(XPROTO_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(XPROTO_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(XPROTO_PACKAGE)
	@touch $@

$(XPROTO_BUILD_DIR)/.configured:
	$(Q)cd $(XPROTO_BUILD_DIR); \
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
	--target=$(STRICT_GNU_TARGET) --prefix=/usr --libdir=/usr/$(LIBDIR) \
	--disable-malloc0returnsnull
	@touch $@

xproto_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup xproto...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(XPROTO_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(XPROTO_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(XPROTO_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(XPROTO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(XPROTO_PKGCONFIGS)
	$(Q)-rm -rf $(XPROTO_BUILD_DIR)*

