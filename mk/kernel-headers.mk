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
# \file         kernel-headers.mk
# \brief	kernel-headers.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         May 2009
#########################################################################################

LINUX_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_LINUX_VERSION_STRING)))
LINUX_SITE := ftp://ftp.kernel.org/pub/linux/kernel/v2.6
LINUX_PACKAGE := linux-$(LINUX_VERSION).tar.bz2
LINUX_BUILD_DIR := $(TOOLS_BUILD)/linux-$(LINUX_VERSION)

kernel-headers_install:  download_linux $(LINUX_BUILD_DIR)/.decompressed
	$(call INSTALL_MESSAGE,"headers linux-$(LINUX_VERSION)")
	PATH=$(PATH):$(TOOLS)/bin/ $(MAKE) -C $(LINUX_BUILD_DIR) \
	headers_install ARCH=$(LINUX_ARCH) CROSS_COMPILE=$(GNU_TARGET)- \
	INSTALL_HDR_PATH=$(SYSROOT)/usr

download_linux: 
	@test -e $(DOWNLOAD_DIR)/$(LINUX_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(LINUX_PACKAGE) $(LINUX_SITE)/$(LINUX_PACKAGE)

$(LINUX_BUILD_DIR)/.decompressed:
	$(call DECOMPRESS_MESSAGE,$(LINUX_PACKAGE))
	@tar -C $(TOOLS_BUILD) -xjf $(DOWNLOAD_DIR)/$(LINUX_PACKAGE)
	@touch $@

