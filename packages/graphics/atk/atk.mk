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
# \file         atk.mk
# \brief	atk.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

ATK_MAJOR_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_ATK_MAJOR_VERSION_STRING)))
ATK_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_ATK_VERSION_STRING)))
ATK_SITE := http://ftp.gnome.org/pub/gnome/sources/atk/$(ATK_MAJOR_VERSION)
ATK_PACKAGE := atk-$(ATK_VERSION).tar.bz2
ATK_BUILD_DIR := $(PACKAGES_BUILD)/atk-$(ATK_VERSION)

ATK_BINS =
ATK_SBINS =
ATK_INCLUDES = atk-*
ATK_LIBS = libatk-*
ATK_PKGCONFIGS = atk.pc

atk_install:
	@test -e $(ATK_BUILD_DIR)/.installed || \
	$(MAKE) $(ATK_BUILD_DIR)/.installed

$(ATK_BUILD_DIR)/.installed: glib_install download_atk \
	$(ATK_BUILD_DIR)/.decompressed $(ATK_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	atk-$(ATK_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH, $(ATK_BUILD_DIR))
	$(Q)$(MAKE) -C $(ATK_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(ATK_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_atk:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(ATK_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(ATK_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(ATK_PACKAGE) \
	$(ATK_SITE)/$(ATK_PACKAGE)

$(ATK_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(ATK_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjf $(DOWNLOAD_DIR)/$(ATK_PACKAGE)
	@touch $@

$(ATK_BUILD_DIR)/.configured:
	$(Q)cd $(ATK_BUILD_DIR); \
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

atk_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup atk...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(ATK_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(ATK_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(ATK_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(ATK_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(ATK_PKGCONFIGS)
	$(Q)-rm -rf $(ATK_BUILD_DIR)

