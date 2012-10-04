#################################################################################
# Embtoolkit
# Copyright(C) 2009-2011 Abdoulaye Walsimou GAYE.
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
# \file         linux.mk
# \brief	linux.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

__LINUX_SITE_BASE	= http://ftp.kernel.org/pub/linux/kernel
__LINUX_SITE_LONGTERM	= $(strip $(if $(LINUX_LONGTERMV),			\
					/longterm/$(LINUX_LONGTERMV)))
__LINUX_SITE		= $(strip $(if $(CONFIG_EMBTK_LINUX_HAVE_MIRROR),	\
	$(patsubst '"',,$(strip $(CONFIG_EMBTK_LINUX_HAVE_MIRROR_SITE))),	\
	$(__LINUX_SITE_BASE)/$(LINUX_MAJORV)$(__LINUX_SITE_LONGTERM)))

LINUX_NAME		:= linux
LINUX_MAJORV		:= $(call embtk_get_pkgversion,linux_major)
LINUX_LONGTERMV		:= $(call embtk_get_pkgversion,linux_longterm)
LINUX_VERSION		:= $(call embtk_get_pkgversion,linux)
LINUX_SITE		:= $(call __LINUX_SITE)
LINUX_PACKAGE		:= linux-$(LINUX_VERSION).tar.bz2
LINUX_SRC_DIR		:= $(embtk_toolsb)/linux-$(LINUX_VERSION)
LINUX_BUILD_DIR		:= $(embtk_toolsb)/linux-$(LINUX_VERSION)
LINUX_HEADERS_KCONFIGS_NAME := LINUX

linux_headers_install:
	$(Q)test -e $(LINUX_BUILD_DIR)/.headers_installed ||			\
				$(MAKE) $(LINUX_BUILD_DIR)/.headers_installed

$(LINUX_BUILD_DIR)/.headers_installed:
	$(call embtk_pinfo,"Installing linux-$(LINUX_VERSION) headers...")
	$(call embtk_download_pkg,linux)
	$(call embtk_decompress_pkg,linux)
	$(Q)PATH=$(PATH):$(embtk_tools)/bin/ $(MAKE) -C $(LINUX_BUILD_DIR) 		\
		headers_install ARCH=$(LINUX_ARCH)				\
		CROSS_COMPILE=$(STRICT_GNU_TARGET)-				\
		INSTALL_HDR_PATH=$(embtk_sysroot)/usr
	$(MAKE) -C $(LINUX_BUILD_DIR) distclean
	$(MAKE) -C $(LINUX_BUILD_DIR) headers_install				\
		INSTALL_HDR_PATH=$(HOSTTOOLS)/usr
	$(Q)touch $@

download_linux download_linux_headers:
	$(call embtk_download_pkg,linux)

#
# clean target
#
define embtk_linux_clean
	if [ -d $(LINUX_BUILD_DIR) ]; then					\
		$(MAKE) -C $(LINUX_BUILD_DIR) distclean;			\
		rm -rf $(LINUX_BUILD_DIR)/.headers_installed;			\
	fi
endef

linux_clean linux_headers_clean:
	$(embtk_linux_clean)
