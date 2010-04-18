################################################################################
# GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# Copyright(C) 2009-2010 GAYE Abdoulaye Walsimou. All rights reserved.
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
# \file         cairo.mk
# \brief	cairo.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         December 2009
################################################################################

CAIRO_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_CAIRO_VERSION_STRING)))
CAIRO_SITE := http://www.cairographics.org/releases
CAIRO_PACKAGE := cairo-$(CAIRO_VERSION).tar.gz
CAIRO_BUILD_DIR := $(PACKAGES_BUILD)/cairo-$(CAIRO_VERSION)

CAIRO_BINS =
CAIRO_SBINS =
CAIRO_INCLUDES = cairo
CAIRO_LIBS = libcairo*
CAIRO_PKGCONFIGS = cairo*.pc

CAIRO_CONFIG_OPTS-y :=
CAIRO_CONFIG_OPTS-n :=
CAIRO_DEPS := pixman_install libpng_install freetype_install fontconfig_install

ifeq ($(CONFIG_EMBTK_HAVE_CAIRO_WITH_DIRECTFB),y)
CAIRO_DEPS += directfb_install
CAIRO_CONFIG_OPTS-y += --enable-directfb=yes
else
CAIRO_CONFIG_OPTS-n += --enable-directfb=no
endif

ifeq ($(CONFIG_EMBTK_HAVE_CAIRO_WITH_LIBXCB),y)
CAIRO_DEPS += xcbutil_install libx11_install
CAIRO_CONFIG_OPTS-y += --enable-xcb=yes
else
CAIRO_CONFIG_OPTS-n += --enable-xcb=no
CAIRO_CONFIG_OPTS-n += --without-x
endif

cairo_install: $(CAIRO_BUILD_DIR)/.installed

$(CAIRO_BUILD_DIR)/.installed: $(CAIRO_DEPS) download_cairo \
	$(CAIRO_BUILD_DIR)/.decompressed $(CAIRO_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	cairo-$(CAIRO_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH, $(CAIRO_BUILD_DIR))
	$(Q)$(MAKE) -C $(CAIRO_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(CAIRO_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_cairo:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(CAIRO_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(CAIRO_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(CAIRO_PACKAGE) \
	$(CAIRO_SITE)/$(CAIRO_PACKAGE)

$(CAIRO_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(CAIRO_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzf $(DOWNLOAD_DIR)/$(CAIRO_PACKAGE)
	@touch $@

$(CAIRO_BUILD_DIR)/.configured:
	$(Q)cd $(CAIRO_BUILD_DIR); \
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
	CFLAGS="$(TARGET_CFLAGS) -I$(SYSROOT)/usr/include" \
	CXXFLAGS="$(TARGET_CFLAGS) -I$(SYSROOT)/usr/include" \
	LDFLAGS="-L$(SYSROOT)/$(LIBDIR) -L$(SYSROOT)/usr/$(LIBDIR)" \
	CPPFLGAS="-I$(SYSROOT)/usr/include" \
	PKG_CONFIG=$(PKGCONFIG_BIN) \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) --libdir=/usr/$(LIBDIR) \
	--prefix=/usr $(CAIRO_CONFIG_OPTS-y)  $(CAIRO_CONFIG_OPTS-n)
	@touch $@

cairo_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup cairo-$(CAIRO_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(CAIRO_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(CAIRO_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(CAIRO_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/lib; rm -rf $(CAIRO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib/pkgconfig; rm -rf $(CAIRO_PKGCONFIGS)
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cd $(SYSROOT)/usr/lib32; rm -rf $(CAIRO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib32/pkgconfig; rm -rf $(CAIRO_PKGCONFIGS)
endif

