################################################################################
# Embtoolkit
# Copyright(C) 2009-2011 Abdoulaye Walsimou GAYE.
#
# This program is free software; you can distribute it and/or modify it
##
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
# \file         ccache.mk
# \brief	ccache.mk of Embtoolkit. Here we install ccache to speed up
# \brief	recompilation.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

CCACHE_NAME		:= ccache
CCACHE_VERSION		:= $(call embtk_get_pkgversion,ccache)
CCACHE_SITE		:= http://samba.org/ftp/ccache
CCACHE_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
CCACHE_PATCH_SITE	:= ftp://ftp.embtoolkit.org/embtoolkit.org/ccache/$(CCACHE_VERSION)
CCACHE_PACKAGE		:= ccache-$(CCACHE_VERSION).tar.bz2
CCACHE_SRC_DIR		:= $(TOOLS_BUILD)/ccache-$(CCACHE_VERSION)
CCACHE_BUILD_DIR	:= $(TOOLS_BUILD)/ccachehost-build

CCACHE_HOST_DIR		:= $(HOSTTOOLS)/usr/local/ccachehost
CCACHE_DIR		:= $(EMBTK_ROOT)/.ccache
HOSTCC_CACHED		:= "$(CCACHE_HOST_DIR)/bin/ccache $(HOSTCC)"
HOSTCXX_CACHED		:= "$(CCACHE_HOST_DIR)/bin/ccache $(HOSTCXX)"
TARGETCC_CACHED		:= "$(CCACHE_HOST_DIR)/bin/ccache $(TARGETCC)"
TARGETCXX_CACHED	:= "$(CCACHE_HOST_DIR)/bin/ccache $(TARGETCXX)"

export CCACHE_DIR HOSTCC_CACHED HOSTCXX_CACHED TARGETCC_CACHED TARGETCXX_CACHED

CCACHE_PREFIX		:= $(CCACHE_HOST_DIR)

ccache_install:
	$(call embtk_install_hostpkg,ccache)
