################################################################################
# Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
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
# \file         libxinerama.mk
# \brief	libxinerama.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         June 2010
################################################################################

LIBXINERAMA_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_LIBXINERAMA_VERSION_STRING)))
LIBXINERAMA_SITE := http://xorg.freedesktop.org/archive/individual/lib
LIBXINERAMA_PACKAGE := libXinerama-$(LIBXINERAMA_VERSION).tar.bz2
LIBXINERAMA_BUILD_DIR := $(PACKAGES_BUILD)/libXinerama-$(LIBXINERAMA_VERSION)

LIBXINERAMA_BINS =
LIBXINERAMA_SBINS =
LIBXINERAMA_INCLUDES = X11/extensions/Xinerama.h X11/extensions/panoramiXext.h
LIBXINERAMA_LIBS = libXinerama.*
LIBXINERAMA_PKGCONFIGS = xinerama.pc

LIBXINERAMA_DEPS = xineramaproto_install

libxinerama_install: $(LIBXINERAMA_BUILD_DIR)/.installed

$(LIBXINERAMA_BUILD_DIR)/.installed: $(LIBXINERAMA_DEPS) download_libxinerama \
	$(LIBXINERAMA_BUILD_DIR)/.decompressed $(LIBXINERAMA_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	libxinerama-$(LIBXINERAMA_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH,$(LIBXINERAMA_BUILD_DIR))
	$(Q)$(MAKE) -C $(LIBXINERAMA_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBXINERAMA_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_libxinerama:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(LIBXINERAMA_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(LIBXINERAMA_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(LIBXINERAMA_PACKAGE) \
	$(LIBXINERAMA_SITE)/$(LIBXINERAMA_PACKAGE)

$(LIBXINERAMA_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LIBXINERAMA_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjf $(DOWNLOAD_DIR)/$(LIBXINERAMA_PACKAGE)
	@touch $@

$(LIBXINERAMA_BUILD_DIR)/.configured:
	$(Q)cd $(LIBXINERAMA_BUILD_DIR); \
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
	--target=$(STRICT_GNU_TARGET) --libdir=/usr/$(LIBDIR) --prefix=/usr \
	--disable-malloc0returnsnull
	@touch $@

libxinerama_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup libxinerama-$(LIBXINERAMA_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(LIBXINERAMA_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(LIBXINERAMA_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(LIBXINERAMA_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(LIBXINERAMA_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(LIBXINERAMA_PKGCONFIGS)

