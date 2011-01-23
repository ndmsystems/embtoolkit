#################################################################################
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
# \file         kernel-headers.mk
# \brief	kernel-headers.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

LINUX_NAME := linux
LINUX_VERSION := $(call EMBTK_GET_PKG_VERSION,LINUX)
ifeq ($(CONFIG_EMBTK_LINUX_HAVE_MIRROR),y)
LINUX_SITE := $(subst ",,$(strip $(CONFIG_EMBTK_LINUX_HAVE_MIRROR_SITE)))
else
LINUX_SITE := http://ftp.kernel.org/pub/linux/kernel/v2.6
endif
LINUX_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
LINUX_PACKAGE := linux-$(LINUX_VERSION).tar.bz2
LINUX_SRC_DIR := $(TOOLS_BUILD)/linux-$(LINUX_VERSION)
LINUX_BUILD_DIR := $(TOOLS_BUILD)/linux-$(LINUX_VERSION)

kernel-headers_install:  download_linux $(LINUX_BUILD_DIR)/.decompressed
	$(call EMBTK_INSTALL_MSG,"headers linux-$(LINUX_VERSION)")
	PATH=$(PATH):$(TOOLS)/bin/ $(MAKE) -C $(LINUX_BUILD_DIR) \
	headers_install ARCH=$(LINUX_ARCH) CROSS_COMPILE=$(STRICT_GNU_TARGET)- \
	INSTALL_HDR_PATH=$(SYSROOT)/usr
	$(MAKE) -C $(LINUX_BUILD_DIR) distclean
	$(MAKE) -C $(LINUX_BUILD_DIR) headers_install INSTALL_HDR_PATH=$(HOSTTOOLS)/usr

download_linux: 
	$(call EMBTK_DOWNLOAD_PKG,LINUX)

$(LINUX_BUILD_DIR)/.decompressed:
	$(call EMBTK_DECOMPRESS_HOSTPKG,LINUX)

