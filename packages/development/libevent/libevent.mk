################################################################################
# Embtoolkit
# Copyright(C) 2009-2010 Abdoulaye Walsimou GAYE. All rights reserved.
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
# \file         libevent.mk
# \brief	libevent.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

LIBEVENT_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_LIBEVENT_VERSION_STRING)))
LIBEVENT_SITE := http://www.monkey.org/~provos
LIBEVENT_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/libevent/$(LIBEVENT_VERSION)
LIBEVENT_PACKAGE := libevent-$(LIBEVENT_VERSION).tar.gz
LIBEVENT_BUILD_DIR := $(PACKAGES_BUILD)/libevent-$(LIBEVENT_VERSION)

LIBEVENT_BINS = event_rpcgen.py
LIBEVENT_SBINS =
LIBEVENT_INCLUDES = evdns.h event-config.h event.h evhttp.h evrpc.h evutil.h
LIBEVENT_LIBS = libevent*
LIBEVENT_PKGCONFIGS =

LIBEVENT_DEPS :=

libevent_install:
	@test -e $(LIBEVENT_BUILD_DIR)/.installed || \
	$(MAKE) $(LIBEVENT_BUILD_DIR)/.installed

$(LIBEVENT_BUILD_DIR)/.installed: $(LIBEVENT_DEPS) download_libevent \
	$(LIBEVENT_BUILD_DIR)/.decompressed $(LIBEVENT_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	libevent-$(LIBEVENT_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH,$(LIBEVENT_BUILD_DIR))
	$(Q)$(MAKE) -C $(LIBEVENT_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBEVENT_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_libevent:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(LIBEVENT_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(LIBEVENT_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(LIBEVENT_PACKAGE) \
	$(LIBEVENT_SITE)/$(LIBEVENT_PACKAGE)
ifeq ($(CONFIG_EMBTK_LIBEVENT_NEED_PATCH),y)
	@test -e $(DOWNLOAD_DIR)/libevent-$(LIBEVENT_VERSION).patch || \
	wget -O $(DOWNLOAD_DIR)/libevent-$(LIBEVENT_VERSION).patch \
	$(LIBEVENT_PATCH_SITE)/libevent-$(LIBEVENT_VERSION)-*.patch
endif

$(LIBEVENT_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LIBEVENT_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzf $(DOWNLOAD_DIR)/$(LIBEVENT_PACKAGE)
ifeq ($(CONFIG_EMBTK_LIBEVENT_NEED_PATCH),y)
	@cd $(LIBEVENT_BUILD_DIR); \
	patch -p1 < $(DOWNLOAD_DIR)/libevent-$(LIBEVENT_VERSION).patch
endif
	@touch $@

$(LIBEVENT_BUILD_DIR)/.configured:
	$(Q)cd $(LIBEVENT_BUILD_DIR); \
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
	--target=$(STRICT_GNU_TARGET) --libdir=/usr/$(LIBDIR) \
	--prefix=/usr
	@touch $@

libevent_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup libevent...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(LIBEVENT_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(LIBEVENT_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(LIBEVENT_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(LIBEVENT_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(LIBEVENT_PKGCONFIGS)
	$(Q)-rm -rf $(LIBEVENT_BUILD_DIR)*

