################################################################################
# Embtoolkit
# Copyright(C) 2009-2011 Abdoulaye Walsimou GAYE. All rights reserved.
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
# \file         libpng.mk
# \brief	libpng.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         October 2009
################################################################################

LIBPNG_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_LIBPNG_VERSION_STRING)))
LIBPNG_SITE := http://download.sourceforge.net/libpng
LIBPNG_PACKAGE := libpng-$(LIBPNG_VERSION).tar.gz
LIBPNG_BUILD_DIR := $(PACKAGES_BUILD)/libpng-$(LIBPNG_VERSION)

LIBPNG_BINS = libpng*
LIBPNG_SBINS =
LIBPNG_INCLUDES = libpng* png*
LIBPNG_LIBS = libpng*
LIBPNG_PKGCONFIGS = libpng*

LIBPNG_DEPS := zlib_target_install

libpng_install:
	@test -e $(LIBPNG_BUILD_DIR)/.installed || \
	$(MAKE) $(LIBPNG_BUILD_DIR)/.installed

$(LIBPNG_BUILD_DIR)/.installed:  $(LIBPNG_DEPS) download_libpng \
	$(LIBPNG_BUILD_DIR)/.decompressed $(LIBPNG_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	libpng-$(LIBPNG_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH, $(LIBPNG_BUILD_DIR))
	$(Q)$(MAKE) -C $(LIBPNG_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBPNG_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_libpng:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(LIBPNG_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(LIBPNG_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(LIBPNG_PACKAGE) \
	$(LIBPNG_SITE)/$(LIBPNG_PACKAGE)

$(LIBPNG_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LIBPNG_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzvf $(DOWNLOAD_DIR)/$(LIBPNG_PACKAGE)
	@touch $@

$(LIBPNG_BUILD_DIR)/.configured:
	cd $(LIBPNG_BUILD_DIR); \
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
	CPPFLAGS="-I$(SYSROOT)/usr/include" \
	PKG_CONFIG=$(PKGCONFIG_BIN) \
	PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--prefix=/usr --enable-static=no --with-libpng-compat=no \
	--libdir=/usr/$(LIBDIR)
	@touch $@

libpng_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup libpng-$(LIBPNG_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(LIBPNG_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(LIBPNG_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(LIBPNG_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(LIBPNG_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(LIBPNG_PKGCONFIGS)
	$(Q)-rm -rf $(LIBPNG_BUILD_DIR)*

