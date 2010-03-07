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
# \file         xextproto.mk
# \brief	xextproto.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         March 2010
################################################################################

XEXTPROTO_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_XEXTPROTO_VERSION_STRING)))
XEXTPROTO_SITE := http://xorg.freedesktop.org/archive/individual/proto
XEXTPROTO_PACKAGE := xextproto-$(XEXTPROTO_VERSION).tar.bz2
XEXTPROTO_BUILD_DIR := $(PACKAGES_BUILD)/xextproto-$(XEXTPROTO_VERSION)

XEXTPROTO_BINS =
XEXTPROTO_SBINS =
XEXTPROTO_INCLUDES = X11/extensions/ag.h X11/extensions/cupproto.h \
		X11/extensions/dpmsconst.h X11/extensions/EVIproto.h \
		X11/extensions/lbx.h X11/extensions/mitmiscproto.h \
		X11/extensions/secur.h X11/extensions/shapeproto.h \
		X11/extensions/syncconst.h X11/extensions/xtestext1const.h \
		X11/extensions/agproto.h X11/extensions/dbe.h \
		X11/extensions/dpmsproto.h X11/extensions/ge.h \
		X11/extensions/lbxproto.h X11/extensions/multibufconst.h \
		X11/extensions/securproto.h X11/extensions/shm.h \
		X11/extensions/syncproto.h X11/extensions/xtestext1proto.h \
		X11/extensions/cup.h X11/extensions/dbeproto.h \
		X11/extensions/EVI.h X11/extensions/geproto.h \
		X11/extensions/mitmiscconst.h X11/extensions/multibufproto.h \
		X11/extensions/shapeconst.h X11/extensions/shmproto.h \
		X11/extensions/xtestconst.h X11/extensions/xtestproto.h
XEXTPROTO_LIBS =
XEXTPROTO_PKGCONFIGS = xextproto.pc

xextproto_install: $(XEXTPROTO_BUILD_DIR)/.installed

$(XEXTPROTO_BUILD_DIR)/.installed: download_xextproto \
	$(XEXTPROTO_BUILD_DIR)/.decompressed $(XEXTPROTO_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	xextproto-$(XEXTPROTO_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(XEXTPROTO_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(XEXTPROTO_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_xextproto:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(XEXTPROTO_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(XEXTPROTO_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(XEXTPROTO_PACKAGE) \
	$(XEXTPROTO_SITE)/$(XEXTPROTO_PACKAGE)

$(XEXTPROTO_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(XEXTPROTO_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(XEXTPROTO_PACKAGE)
	@touch $@

$(XEXTPROTO_BUILD_DIR)/.configured:
	$(Q)cd $(XEXTPROTO_BUILD_DIR); \
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

xextproto_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup xextproto-$(XEXTPROTO_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(XEXTPROTO_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(XEXTPROTO_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(XEXTPROTO_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/lib; rm -rf $(XEXTPROTO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib/pkgconfig; rm -rf $(XEXTPROTO_PKGCONFIGS)
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cd $(SYSROOT)/usr/lib32; rm -rf $(XEXTPROTO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib32/pkgconfig; rm -rf $(XEXTPROTO_PKGCONFIGS)
endif

