################################################################################
# Embtoolkit
# Copyright(C) 2010-2011 Abdoulaye Walsimou GAYE. All rights reserved.
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
# \file         xcbutil.mk
# \brief	xcbutil.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2009
################################################################################

XCBUTIL_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_XCBUTIL_VERSION_STRING)))
XCBUTIL_SITE := http://xcb.freedesktop.org/dist
XCBUTIL_PACKAGE := xcb-util-$(XCBUTIL_VERSION).tar.bz2
XCBUTIL_BUILD_DIR := $(PACKAGES_BUILD)/xcb-util-$(XCBUTIL_VERSION)

XCBUTIL_BINS =
XCBUTIL_SBINS =
XCBUTIL_INCLUDES = xcb/xcb_atom.h xcb/xcb_aux.h xcb/xcb_bitops.h \
		xcb/xcb_event.h xcb/xcb_icccm.h xcb/xcb_image.h \
		xcb/xcb_keysyms.h xcb/xcb_pixel.h xcb/xcb_property.h \
		xcb/xcb_renderutil.h xcb/xcb_reply.h
XCBUTIL_LIBS = libxcb-atom.* libxcb-aux.* libxcb-event.* libxcb-icccm.* \
		libxcb-image.* libxcb-keysyms.* libxcb-property.* \
		libxcb-render-util.* libxcb-reply.*
XCBUTIL_PKGCONFIGS = xcb-atom.pc xcb-aux.pc xcb-event.pc xcb-icccm.pc \
		xcb-image.pc xcb-keysyms.pc xcb-property.pc xcb-renderutil.pc \
		xcb-reply.pc

XCBUTIL_DEPS = libxcb_install

xcbutil_install:
	@test -e $(XCBUTIL_BUILD_DIR)/.installed || \
	$(MAKE) $(XCBUTIL_BUILD_DIR)/.installed

$(XCBUTIL_BUILD_DIR)/.installed: $(XCBUTIL_DEPS) download_xcbutil \
	$(XCBUTIL_BUILD_DIR)/.decompressed $(XCBUTIL_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	xcbutil-$(XCBUTIL_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH,$(XCBUTIL_BUILD_DIR))
	$(Q)$(MAKE) -C $(XCBUTIL_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(XCBUTIL_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	$(Q)$(MAKE) $(XCBUTIL_BUILD_DIR)/.patchlibtool
	@touch $@

download_xcbutil:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(XCBUTIL_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(XCBUTIL_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(XCBUTIL_PACKAGE) \
	$(XCBUTIL_SITE)/$(XCBUTIL_PACKAGE)

$(XCBUTIL_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(XCBUTIL_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjf $(DOWNLOAD_DIR)/$(XCBUTIL_PACKAGE)
	@touch $@

$(XCBUTIL_BUILD_DIR)/.configured:
	cd $(XCBUTIL_BUILD_DIR); \
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
	./configure $XORG_CONFIG --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) --libdir=/usr/$(LIBDIR) --prefix=/usr
	@touch $@

xcbutil_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup xcbutil-$(XCBUTIL_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(XCBUTIL_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(XCBUTIL_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(XCBUTIL_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(XCBUTIL_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(XCBUTIL_PKGCONFIGS)
	$(Q)-rm -rf $(XCBUTIL_BUILD_DIR)*

$(XCBUTIL_BUILD_DIR)/.patchlibtool:
	@XCBUTIL_LT_FILES=`find $(SYSROOT)/usr/$(LIBDIR)/libxcb-* -type f -name *.la`; \
	for i in $$XCBUTIL_LT_FILES; \
	do \
	sed \
	-i "s; /usr/$(LIBDIR)/libxcb-event.la ; $(SYSROOT)/usr/$(LIBDIR)/libxcb-event.la ;" $$i; \
	sed \
	-i "s; /usr/$(LIBDIR)/libxcb-aux.la ; $(SYSROOT)/usr/$(LIBDIR)/libxcb-aux.la ;" $$i; \
	sed \
	-i "s; /usr/$(LIBDIR)/libxcb-property.la ; $(SYSROOT)/usr/$(LIBDIR)/libxcb-property.la ;" $$i; \
	sed \
	-i "s; /usr/$(LIBDIR)/libxcb-atom.la ; $(SYSROOT)/usr/$(LIBDIR)/libxcb-atom.la ;" $$i; \
	done

