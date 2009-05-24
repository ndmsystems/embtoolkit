#########################################################################################
# GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# Copyright(C) 2009 GAYE Abdoulaye Walsimou. All rights reserved.
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
#########################################################################################
#
# \file         eglibc.mk
# \brief	eglibc.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         May 2009
#########################################################################################
EGLIBC_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_EGLIBC_VERSION_STRING)))
EGLIBC_SITE := http://www.eglibc.org
EGLIBC_PACKAGE := eglibc-$(EGLIBC_VERSION).tar.bz2
EGLIBC_HEADERS_BUILD_DIR := $(TOOLS_BUILD)/eglibc-headers
EGLIBC_BUILD_DIR := $(TOOLS_BUILD)/eglibc

#EGLIBC options
include $(EMBTK_ROOT)/mk/eglibc-options-parse.mk

#Hard or soft floating point
ifeq ($(CONFIG_EMBTK_SOFTFLOAT),y)
EGLIBC_FLOAT_TYPE := --with-fp=no
else
EGLIBC_FLOAT_TYPE := --with-fp=yes
endif

eglibc-headers_install: $(EGLIBC_HEADERS_BUILD_DIR)/.installed
eglibc_install: $(EGLIBC_BUILD_DIR)/.installed

$(EGLIBC_HEADERS_BUILD_DIR)/.installed: eglibc_download $(EGLIBC_HEADERS_BUILD_DIR)/.decompressed \
	EGLIBC_OPTIONS_PARSE $(EGLIBC_HEADERS_BUILD_DIR)/.configured
	$(call INSTALL_MESSAGE,"headers eglibc-$(EGLIBC_VERSION)")
	$(MAKE) -C $(EGLIBC_HEADERS_BUILD_DIR) install-headers install_root=$(SYSROOT) \
	install-bootstrap-headers=yes && \
	$(MAKE) -C $(EGLIBC_HEADERS_BUILD_DIR) csu/subdir_lib
	@cp $(EGLIBC_HEADERS_BUILD_DIR)/csu/crt1.o $(SYSROOT)/usr/lib/
	@cp $(EGLIBC_HEADERS_BUILD_DIR)/csu/crti.o $(SYSROOT)/usr/lib/
	@cp $(EGLIBC_HEADERS_BUILD_DIR)/csu/crtn.o $(SYSROOT)/usr/lib/
	$(TOOLS)/bin/$(STRICT_GNU_TARGET)-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o \
	$(SYSROOT)/usr/lib/libc.so
	@touch $@

eglibc_download:
	@echo "downloading eglibc"

$(EGLIBC_HEADERS_BUILD_DIR)/.decompressed:
	$(call DECOMPRESS_MESSAGE,$(EGLIBC_PACKAGE))
	@tar -C $(TOOLS_BUILD) -xjf $(DOWNLOAD_DIR)/$(EGLIBC_PACKAGE)
	@cp -R $(TOOLS_BUILD)/eglibc-$(EGLIBC_VERSION)/ports \
	$(TOOLS_BUILD)/eglibc-$(EGLIBC_VERSION)/libc/
	@mkdir -p $(EGLIBC_HEADERS_BUILD_DIR)
	@mkdir -p $(EGLIBC_BUILD_DIR)
	@touch $@

$(EGLIBC_HEADERS_BUILD_DIR)/.configured:
	$(call CONFIGURE_MESSAGE,eglibc-$(EGLIBC_VERSION))
	cd $(EGLIBC_HEADERS_BUILD_DIR); BUILD_CC=$(HOSTCC_CACHED) \
	CFLAGS="-Os -pipe $(EMBTK_TARGET_ABI)" \
	CC=$(TOOLS)/bin/$(STRICT_GNU_TARGET)-gcc \
	CXX=$(TOOLS)/bin/$(STRICT_GNU_TARGET)-g++ \
	AR=$(TOOLS)/bin/$(STRICT_GNU_TARGET)-ar \
	RANLIB=$(TOOLS)/bin/$(STRICT_GNU_TARGET)-ranlib \
	$(TOOLS_BUILD)/eglibc-$(EGLIBC_VERSION)/libc/configure --prefix=/usr \
	--with-headers=$(SYSROOT)/usr/include \
	--host=$(GNU_TARGET) --build=$(HOST_BUILD) $(EGLIBC_FLOAT_TYPE) \
	--disable-profile --without-gd --without-cvs --enable-add-ons \
	--enable-kernel="2.6.0"
	@touch $@

$(EGLIBC_BUILD_DIR)/.installed: $(EGLIBC_BUILD_DIR)/.configured
	$(call INSTALL_MESSAGE,eglibc-$(EGLIBC_VERSION))
	PATH=$(PATH):$(TOOLS)/bin/ $(MAKE) -C $(EGLIBC_BUILD_DIR) && \
	PATH=$(PATH):$(TOOLS)/bin/ $(MAKE) -C $(EGLIBC_BUILD_DIR) install \
	install_root=$(SYSROOT)
	@touch $@

$(EGLIBC_BUILD_DIR)/.configured:
	$(call CONFIGURE_MESSAGE,eglibc-$(EGLIBC_VERSION))
	cd $(EGLIBC_BUILD_DIR); BUILD_CC=$(HOSTCC_CACHED) \
	CFLAGS="-Os -pipe $(EMBTK_TARGET_ABI)" \
	CC=$(TARGETCC_CACHED) \
	CXX=$(TARGETCXX_CACHED) \
	AR=$(TARGETAR) \
	RANLIB=$(TARGETRANLIB) \
	$(TOOLS_BUILD)/eglibc-$(EGLIBC_VERSION)/libc/configure --prefix=/usr \
	--with-headers=$(SYSROOT)/usr/include \
	--host=$(GNU_TARGET) --build=$(HOST_BUILD) $(EGLIBC_FLOAT_TYPE) \
	--disable-profile --without-gd --without-cvs --enable-add-ons \
	--enable-kernel="2.6.0"
	@touch $@
