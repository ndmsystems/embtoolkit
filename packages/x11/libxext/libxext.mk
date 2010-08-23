################################################################################
# Embtoolkit
# Copyright(C) 2010 Abdoulaye Walsimou GAYE. All rights reserved.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
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

LIBXEXT_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_LIBXEXT_VERSION_STRING)))
LIBXEXT_SITE := http://xorg.freedesktop.org/archive/individual/lib
LIBXEXT_PACKAGE := libXext-$(LIBXEXT_VERSION).tar.bz2
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

LIBXEXT_DEPS = libx11_install

libxext_install:
	@test -e $(LIBXEXT_BUILD_DIR)/.installed || \
	$(MAKE) $(LIBXEXT_BUILD_DIR)/.installed

$(LIBXEXT_BUILD_DIR)/.installed: $(LIBXEXT_DEPS) download_libxext \
	$(LIBXEXT_BUILD_DIR)/.decompressed $(LIBXEXT_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	libxext-$(LIBXEXT_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH,$(LIBXEXT_BUILD_DIR))
	$(Q)$(MAKE) -C $(LIBXEXT_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBXEXT_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_libxext:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(LIBXEXT_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(LIBXEXT_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(LIBXEXT_PACKAGE) \
	$(LIBXEXT_SITE)/$(LIBXEXT_PACKAGE)

$(LIBXEXT_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LIBXEXT_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjf $(DOWNLOAD_DIR)/$(LIBXEXT_PACKAGE)
	@touch $@

$(LIBXEXT_BUILD_DIR)/.configured:
	$(Q)cd $(LIBXEXT_BUILD_DIR); \
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
	--target=$(STRICT_GNU_TARGET) --libdir=/usr/$(LIBDIR) \
	--prefix=/usr --disable-malloc0returnsnull
	@touch $@

libxext_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup libxext-$(LIBXEXT_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(LIBXEXT_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(LIBXEXT_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(LIBXEXT_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(LIBXEXT_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(LIBXEXT_PKGCONFIGS)
	$(Q)-rm -rf $(LIBXEXT_BUILD_DIR)*

