################################################################################
# Embtoolkit
# Copyright(C) 2009-2012 Abdoulaye Walsimou GAYE.
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
# \file         zlib_host.mk
# \brief	zlib_host.mk of Embtoolkit.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         June 2009
################################################################################

ZLIB_HOST_NAME		:= zlib
ZLIB_HOST_VERSION	:= $(call embtk_get_pkgversion,zlib_host)
ZLIB_HOST_SITE		:= http://zlib.net
ZLIB_HOST_PACKAGE	:= zlib-$(ZLIB_HOST_VERSION).tar.bz2
ZLIB_HOST_SRC_DIR	:= $(TOOLS_BUILD)/zlib-$(ZLIB_HOST_VERSION)
ZLIB_HOST_BUILD_DIR	:= $(TOOLS_BUILD)/zlib-$(ZLIB_HOST_VERSION)

ZLIB_HOST_CONFIGURE_ENV	:= CC=$(HOSTCC_CACHED)

zlib_host_install:
	$(Q)test -e $(ZLIB_HOST_BUILD_DIR)/.installed || \
	$(MAKE) $(ZLIB_HOST_BUILD_DIR)/.installed

$(ZLIB_HOST_BUILD_DIR)/.installed: download_zlib_host \
	$(ZLIB_HOST_SRC_DIR)/.decompressed \
	$(ZLIB_HOST_BUILD_DIR)/.configured
	$(embtk_pinfo,"Compile/Install $(ZLIB_HOST_PACKAGE) for host")
	$(Q)$(MAKE) -C $(ZLIB_HOST_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(ZLIB_HOST_BUILD_DIR) install
	$(Q)touch $@

$(ZLIB_HOST_SRC_DIR)/.decompressed:
	$(call embtk_decompress_pkg,zlib_host)

$(ZLIB_HOST_BUILD_DIR)/.configured:
	$(call embtk_pinfo,"Configure $(ZLIB_HOST_PACKAGE) for host...")
	$(Q)cd $(ZLIB_HOST_BUILD_DIR);					\
	CPPFLAGS="-I$(HOSTTOOLS)/usr/include"				\
	LDFLAGS="-L$(HOSTTOOLS)/$(LIBDIR) -L$(HOSTTOOLS)/usr/$(LIBDIR)"	\
	$(ZLIB_HOST_CONFIGURE_ENV)					\
	$(CONFIG_SHELL) $(ZLIB_HOST_SRC_DIR)/configure			\
	--prefix=$(HOSTTOOLS)/usr $(ZLIB_HOST_CONFIGURE_OPTS)
	$(Q)touch $@

zlib_host_clean:
	$(call embtk_pinfo,"Clean up zlib for host")
