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
# \file         videoproto.mk
# \brief	videoproto.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

VIDEOPROTO_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_VIDEOPROTO_VERSION_STRING)))
VIDEOPROTO_SITE := http://ftp.x.org/pub/individual/proto
VIDEOPROTO_PACKAGE := videoproto-$(VIDEOPROTO_VERSION).tar.bz2
VIDEOPROTO_BUILD_DIR := $(PACKAGES_BUILD)/videoproto-$(VIDEOPROTO_VERSION)

VIDEOPROTO_BINS =
VIDEOPROTO_SBINS =
VIDEOPROTO_INCLUDES =	X11/extensions/vldXvMC.h X11/extensions/Xv.h \
			X11/extensions/XvMC.h X11/extensions/XvMCproto.h \
			X11/extensions/Xvproto.h
VIDEOPROTO_LIBS =
VIDEOPROTO_PKGCONFIGS = videoproto.pc

videoproto_install:
	@test -e $(VIDEOPROTO_BUILD_DIR)/.installed || \
	$(MAKE) $(VIDEOPROTO_BUILD_DIR)/.installed

$(VIDEOPROTO_BUILD_DIR)/.installed: download_videoproto \
	$(VIDEOPROTO_BUILD_DIR)/.decompressed $(VIDEOPROTO_BUILD_DIR)/.configured
	$(call embtk_generic_message,"Compiling and installing \
	videoproto-$(VIDEOPROTO_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(VIDEOPROTO_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(VIDEOPROTO_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_videoproto:
	$(call embtk_generic_message,"Downloading $(VIDEOPROTO_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(VIDEOPROTO_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(VIDEOPROTO_PACKAGE) \
	$(VIDEOPROTO_SITE)/$(VIDEOPROTO_PACKAGE)

$(VIDEOPROTO_BUILD_DIR)/.decompressed:
	$(call embtk_generic_message,"Decompressing $(VIDEOPROTO_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(VIDEOPROTO_PACKAGE)
	@touch $@

$(VIDEOPROTO_BUILD_DIR)/.configured:
	$(Q)cd $(VIDEOPROTO_BUILD_DIR); \
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
	PKG_CONFIG_PATH=$(EMBTK_PKG_CONFIG_PATH) \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) --libdir=/usr/$(LIBDIR) --prefix=/usr \
	--disable-malloc0returnsnull
	@touch $@

videoproto_clean:
	$(call embtk_generic_message,"cleanup videoproto-$(VIDEOPROTO_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(VIDEOPROTO_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(VIDEOPROTO_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(VIDEOPROTO_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(VIDEOPROTO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(VIDEOPROTO_PKGCONFIGS)
	$(Q)-rm -rf $(VIDEOPROTO_BUILD_DIR)*

