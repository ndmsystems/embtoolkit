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
ZLIB_HOST_SRC_DIR	:= $(embtk_toolsb)/zlib-$(ZLIB_HOST_VERSION)
ZLIB_HOST_BUILD_DIR	:= $(embtk_toolsb)/zlib-$(ZLIB_HOST_VERSION)

ZLIB_HOST_CONFIGURE_ENV		:= CC=$(HOSTCC_CACHED)

define embtk_install_zlib_host
	$(call  embtk_makeinstall_hostpkg,zlib_host)
endef

define embtk_configure_zlib_host
	$(Q)cd $(ZLIB_HOST_BUILD_DIR);					\
	CPPFLAGS="-I$(embtk_htools)/usr/include"				\
	LDFLAGS="-L$(embtk_htools)/$(LIBDIR) -L$(embtk_htools)/usr/$(LIBDIR)"	\
	$(ZLIB_HOST_CONFIGURE_ENV)					\
	$(CONFIG_SHELL) $(ZLIB_HOST_SRC_DIR)/configure			\
		--prefix=$(embtk_htools)/usr $(ZLIB_HOST_CONFIGURE_OPTS)
	touch $(call __embtk_pkg_dotconfigured_f,zlib_host)
endef

define embtk_beforeinstall_zlib_host
	$(embtk_configure_zlib_host)
endef

define embtk_cleanup_zlib_host
	$(call embtk_pinfo,"Clean up zlib for host")
endef
