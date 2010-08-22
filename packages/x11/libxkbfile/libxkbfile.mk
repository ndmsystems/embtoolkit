################################################################################
# Embtoolkit
# Copyright(C) 2010 Abdoulaye Walsimou GAYE. All rights reserved.
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
# \file         libxkbfile.mk
# \brief	libxkbfile.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         February 2010
################################################################################

LIBXKBFILE_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_LIBXKBFILE_VERSION_STRING)))
LIBXKBFILE_SITE := http://xorg.freedesktop.org/archive/individual/lib
LIBXKBFILE_PACKAGE := libxkbfile-$(LIBXKBFILE_VERSION).tar.bz2
LIBXKBFILE_BUILD_DIR := $(PACKAGES_BUILD)/libxkbfile-$(LIBXKBFILE_VERSION)

LIBXKBFILE_BINS =
LIBXKBFILE_SBINS =
LIBXKBFILE_INCLUDES = X11/extensions/XKBbells.h X11/extensions/XKBconfig.h \
		X11/extensions/XKBfile.h X11/extensions/XKBrules.h \
		X11/extensions/XKMformat.h X11/extensions/XKM.h
LIBXKBFILE_LIBS = libxkbfile.*
LIBXKBFILE_PKGCONFIGS =

LIBXKBFILE_DEPS = kbproto_install libx11_install

libxkbfile_install:
	@test -e $(LIBXKBFILE_BUILD_DIR)/.installed || \
	$(MAKE) $(LIBXKBFILE_BUILD_DIR)/.installed

$(LIBXKBFILE_BUILD_DIR)/.installed: $(LIBXKBFILE_DEPS) download_libxkbfile \
	$(LIBXKBFILE_BUILD_DIR)/.decompressed $(LIBXKBFILE_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	libxkbfile-$(LIBXKBFILE_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH,$(LIBXKBFILE_BUILD_DIR))
	$(Q)$(MAKE) -C $(LIBXKBFILE_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBXKBFILE_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_libxkbfile:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(LIBXKBFILE_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(LIBXKBFILE_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(LIBXKBFILE_PACKAGE) \
	$(LIBXKBFILE_SITE)/$(LIBXKBFILE_PACKAGE)

$(LIBXKBFILE_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LIBXKBFILE_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(LIBXKBFILE_PACKAGE)
	@touch $@

$(LIBXKBFILE_BUILD_DIR)/.configured:
	$(Q)cd $(LIBXKBFILE_BUILD_DIR); \
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

libxkbfile_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup libxkbfile-$(LIBXKBFILE_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(LIBXKBFILE_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(LIBXKBFILE_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(LIBXKBFILE_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(LIBXKBFILE_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(LIBXKBFILE_PKGCONFIGS)
	$(Q)-rm -rf $(LIBXKBFILE_BUILD_DIR)

