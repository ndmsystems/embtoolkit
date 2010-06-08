################################################################################
# GAYE Abdoulaye Walsimou, <awg@embtoolkit.org>
# Copyright(C) 2010 GAYE Abdoulaye Walsimou. All rights reserved.
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
# \file         recordproto.mk
# \brief	recordproto.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <awg@embtoolkit.org>
# \date         June 2010
################################################################################

RECORDPROTO_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_RECORDPROTO_VERSION_STRING)))
RECORDPROTO_SITE := http://ftp.x.org/pub/individual/proto
RECORDPROTO_PACKAGE := recordproto-$(RECORDPROTO_VERSION).tar.bz2
RECORDPROTO_BUILD_DIR := $(PACKAGES_BUILD)/recordproto-$(RECORDPROTO_VERSION)

RECORDPROTO_BINS =
RECORDPROTO_SBINS =
RECORDPROTO_INCLUDES = X11/extensions/recordconst.h \
			X11/extensions/recordproto.h X11/extensions/recordstr.h
RECORDPROTO_LIBS =
RECORDPROTO_PKGCONFIGS = recordproto.pc

ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
PKG_CONFIG_PATH=$(SYSROOT)/usr/lib32/pkgconfig
else
PKG_CONFIG_PATH=$(SYSROOT)/usr/lib/pkgconfig
endif

recordproto_install: $(RECORDPROTO_BUILD_DIR)/.installed

$(RECORDPROTO_BUILD_DIR)/.installed: download_recordproto \
	$(RECORDPROTO_BUILD_DIR)/.decompressed $(RECORDPROTO_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	recordproto-$(RECORDPROTO_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(RECORDPROTO_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(RECORDPROTO_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_recordproto:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(RECORDPROTO_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(RECORDPROTO_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(RECORDPROTO_PACKAGE) \
	$(RECORDPROTO_SITE)/$(RECORDPROTO_PACKAGE)

$(RECORDPROTO_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(RECORDPROTO_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(RECORDPROTO_PACKAGE)
	@touch $@

$(RECORDPROTO_BUILD_DIR)/.configured:
	$(Q)cd $(RECORDPROTO_BUILD_DIR); \
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
	--target=$(STRICT_GNU_TARGET) --prefix=/usr --libdir=/usr/$(LIBDIR)
	@touch $@

recordproto_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup recordproto-$(RECORDPROTO_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(RECORDPROTO_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(RECORDPROTO_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(RECORDPROTO_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/lib; rm -rf $(RECORDPROTO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib/pkgconfig; rm -rf $(RECORDPROTO_PKGCONFIGS)
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cd $(SYSROOT)/usr/lib32; rm -rf $(RECORDPROTO_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib32/pkgconfig; rm -rf $(RECORDPROTO_PKGCONFIGS)
endif

