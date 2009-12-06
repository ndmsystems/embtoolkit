################################################################################
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
################################################################################
#
# \file         strace.mk
# \brief	strace.mk of Embtoolkit.
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         August 2009
################################################################################

STRACE_VERSION:= 4.5.18
STRACE_SITE:=http://downloads.sourceforge.net/project/strace/strace/$(STRACE_VERSION)
STRACE_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/strace
STRACE_PACKAGE := strace-$(STRACE_VERSION).tar.bz2
STRACE_BUILD_DIR := $(PACKAGES_BUILD)/strace

strace_install: $(STRACE_BUILD_DIR)/.installed

$(STRACE_BUILD_DIR)/.installed: download_starce \
	$(STRACE_BUILD_DIR)/.decompressed $(STRACE_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	strace-$(STRACE_VERSION) in target...")
	@$(MAKE) -C $(STRACE_BUILD_DIR)
	cd $(STRACE_BUILD_DIR); \
	test -z $(ROOTFS)/usr/bin || mkdir -p $(ROOTFS)/usr/bin; \
	install -c strace $(ROOTFS)/usr/bin
	@touch $@

$(STRACE_BUILD_DIR)/.decompressed:
	@tar -C $(PACKAGES_BUILD) -xjf $(DOWNLOAD_DIR)/$(STRACE_PACKAGE)
	@cd $(PACKAGES_BUILD)/strace-$(STRACE_VERSION); \
	patch -p1 < $(DOWNLOAD_DIR)/strace-$(STRACE_VERSION).patch
	@mkdir -p $(STRACE_BUILD_DIR)
	@touch $@
download_starce:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading strace-$(STRACE_VERSION) if \
	necessary ...")
	@test -e $(DOWNLOAD_DIR)/$(STRACE_PACKAGE) || \
	wget $(STRACE_SITE)/$(STRACE_PACKAGE) \
	-O $(DOWNLOAD_DIR)/$(STRACE_PACKAGE)
	@test -e $(DOWNLOAD_DIR)/strace-$(STRACE_VERSION).patch || \
	wget -O $(DOWNLOAD_DIR)/strace-$(STRACE_VERSION).patch \
	$(STRACE_PATCH_SITE)/strace-$(STRACE_VERSION)-*.patch

$(STRACE_BUILD_DIR)/.configured:
	$(call EMBTK_GENERIC_MESSAGE,"Configuring \
	strace-$(STRACE_VERSION) for target...")
	cd $(STRACE_BUILD_DIR); \
	$(PACKAGES_BUILD)/strace-$(STRACE_VERSION)/configure \
	--prefix=$(ROOTFS)/usr \
	--build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	CC=$(TARGETCC_CACHED) \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="-L$(SYSROOT)/lib" \
	CPPFLAGS="-I$(SYSROOT)/usr/include"
	@touch $@

