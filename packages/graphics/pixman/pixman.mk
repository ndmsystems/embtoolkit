################################################################################
# Embtoolkit
# Copyright(C) 2009-2010 Abdoulaye Walsimou GAYE. All rights reserved.
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
# \file         pixman.mk
# \brief	pixman.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

PIXMAN_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_PIXMAN_VERSION_STRING)))
PIXMAN_SITE := http://www.cairographics.org/releases
PIXMAN_PACKAGE := pixman-$(PIXMAN_VERSION).tar.gz
PIXMAN_BUILD_DIR := $(PACKAGES_BUILD)/pixman-$(PIXMAN_VERSION)

PIXMAN_BINS =
PIXMAN_SBINS =
PIXMAN_INCLUDES = pixman-*
PIXMAN_LIBS = libpixman-*
PIXMAN_PKGCONFIGS = pixman-*.pc

pixman_install:
	@test -e $(PIXMAN_BUILD_DIR)/.installed || \
	$(MAKE) $(PIXMAN_BUILD_DIR)/.installed

$(PIXMAN_BUILD_DIR)/.installed: download_pixman \
	$(PIXMAN_BUILD_DIR)/.decompressed $(PIXMAN_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	pixman-$(PIXMAN_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH, $(PIXMAN_BUILD_DIR))
	$(Q)$(MAKE) -C $(PIXMAN_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(PIXMAN_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_pixman:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(PIXMAN_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(PIXMAN_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(PIXMAN_PACKAGE) \
	$(PIXMAN_SITE)/$(PIXMAN_PACKAGE)

$(PIXMAN_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(PIXMAN_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzf $(DOWNLOAD_DIR)/$(PIXMAN_PACKAGE)
	@touch $@

$(PIXMAN_BUILD_DIR)/.configured:
	$(Q)cd $(PIXMAN_BUILD_DIR); \
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
	--prefix=/usr
	@touch $@

pixman_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup pixman-$(PIXMAN_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(PIXMAN_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(PIXMAN_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(PIXMAN_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(PIXMAN_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(PIXMAN_PKGCONFIGS)
	$(Q)-rm -rf $(PIXMAN_BUILD_DIR)*

