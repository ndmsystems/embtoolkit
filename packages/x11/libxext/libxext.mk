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
# \file         libxext.mk
# \brief	libxext.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

LIBXEXT_NAME := libXext
LIBXEXT_VERSION := $(call EMBTK_GET_PKG_VERSION,LIBXEXT)
LIBXEXT_SITE := http://xorg.freedesktop.org/archive/individual/lib
LIBXEXT_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
LIBXEXT_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/expat/$(LIBXEXT_VERSION)
LIBXEXT_PACKAGE := libXext-$(LIBXEXT_VERSION).tar.bz2
LIBXEXT_SRC_DIR := $(PACKAGES_BUILD)/libXext-$(LIBXEXT_VERSION)
LIBXEXT_BUILD_DIR := $(PACKAGES_BUILD)/libXext-$(LIBXEXT_VERSION)

LIBXEXT_BINS =
LIBXEXT_SBINS =
LIBXEXT_INCLUDES = X11/extensions/dpms.h X11/extensions/lbxbuf.h \
		X11/extensions/lbximage.h X11/extensions/multibuf.h \
		X11/extensions/shape.h X11/extensions/Xag.h \
		X11/extensions/Xdbe.h X11/extensions/Xext.h \
		X11/extensions/XLbx.h X11/extensions/xtestext1.h \
		X11/extensions/extutil.h X11/extensions/lbxbufstr.h \
		X11/extensions/MITMisc.h X11/extensions/security.h \
		X11/extensions/sync.h X11/extensions/Xcup.h \
		X11/extensions/XEVI.h X11/extensions/Xge.h X11/extensions/XShm.h
LIBXEXT_LIBS = libXext.*
LIBXEXT_PKGCONFIGS =

LIBXEXT_CONFIGURE_OPTS := --disable-malloc0returnsnull

LIBXEXT_DEPS = libx11_install

libxext_install:
	@test -e $(LIBXEXT_BUILD_DIR)/.installed || \
	$(MAKE) $(LIBXEXT_BUILD_DIR)/.installed

$(LIBXEXT_BUILD_DIR)/.installed: $(LIBXEXT_DEPS) download_libxext \
	$(LIBXEXT_BUILD_DIR)/.decompressed $(LIBXEXT_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	libxext-$(LIBXEXT_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(LIBXEXT_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBXEXT_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_libxext:
	$(call EMBTK_DOWNLOAD_PKG,LIBXEXT)

$(LIBXEXT_BUILD_DIR)/.decompressed:
	$(call EMBTK_DECOMPRESS_PKG,LIBXEXT)

$(LIBXEXT_BUILD_DIR)/.configured:
	$(call EMBTK_CONFIGURE_PKG,LIBXEXT)

libxext_clean:
	$(call EMBTK_CLEANUP_PKG,LIBXEXT)
