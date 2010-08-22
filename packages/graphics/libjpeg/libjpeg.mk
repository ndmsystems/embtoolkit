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
# \file         libjpeg.mk
# \brief	libjpeg.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         October 2009
################################################################################

LIBJPEG_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_LIBJPEG_VERSION_STRING)))
LIBJPEG_SITE := http://www.ijg.org/files
LIBJPEG_PACKAGE := jpegsrc.v$(LIBJPEG_VERSION).tar.gz
LIBJPEG_BUILD_DIR := $(PACKAGES_BUILD)/jpeg-$(LIBJPEG_VERSION)

LIBJPEG_BINS := cjpeg djpeg jpegtran rdjpgcom wrjpgcom
LIBJPEG_SBINS :=
LIBJPEG_LIBS := libjpeg*
LIBJEPG_INCLUDES := jconfig.h jerror.h jmorecfg.h jpeglib.h

libjpeg_install:
	@test -e $(LIBJPEG_BUILD_DIR)/.installed || \
	$(MAKE) $(LIBJPEG_BUILD_DIR)/.installed

$(LIBJPEG_BUILD_DIR)/.installed: download_libjpeg \
	$(LIBJPEG_BUILD_DIR)/.decompressed $(LIBJPEG_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	jpeg-$(LIBJPEG_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH, $(LIBJPEG_BUILD_DIR))
	$(Q)$(MAKE) -C $(LIBJPEG_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBJPEG_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	@touch $@

download_libjpeg:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(LIBJPEG_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(LIBJPEG_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(LIBJPEG_PACKAGE) \
	$(LIBJPEG_SITE)/$(LIBJPEG_PACKAGE)

$(LIBJPEG_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LIBJPEG_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzvf $(DOWNLOAD_DIR)/$(LIBJPEG_PACKAGE)
	@touch $@

$(LIBJPEG_BUILD_DIR)/.configured:
	cd $(LIBJPEG_BUILD_DIR); \
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
	--prefix=/usr --enable-static=no --program-suffix=""
	@touch $@

libjpeg_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup jpeg-$(LIBJPEG_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(LIBJPEG_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(LIBJPEG_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(LIBJPEG_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(LIBJPEG_LIBS)
	$(Q)-rm -rf $(LIBJPEG_BUILD_DIR)

