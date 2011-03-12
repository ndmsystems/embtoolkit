################################################################################
# Embtoolkit
# Copyright(C) 2010-2011 Abdoulaye Walsimou GAYE.
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
# \file         xcbutil.mk
# \brief	xcbutil.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2009
################################################################################

XCBUTIL_NAME := xcb-util
XCBUTIL_VERSION := $(call EMBTK_GET_PKG_VERSION,XCBUTIL)
XCBUTIL_SITE := http://xcb.freedesktop.org/dist
XCBUTIL_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
XCBUTIL_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/xcb-util/$(XCBUTIL_VERSION)
XCBUTIL_PACKAGE := xcb-util-$(XCBUTIL_VERSION).tar.bz2
XCBUTIL_SRC_DIR := $(PACKAGES_BUILD)/xcb-util-$(XCBUTIL_VERSION)
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
	$(call EMBTK_INSTALL_PKG,XCBUTIL)
	$(Q)$(MAKE) $(XCBUTIL_BUILD_DIR)/.patchlibtool

download_xcbutil:
	$(call EMBTK_DOWNLOAD_PKG,XCBUTIL)

xcbutil_clean:
	$(call EMBTK_CLEANUP_PKG,XCBUTIL)

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
