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
CCACHE_SRC_DIR		:= $(embtk_toolsb)/ccache-$(CCACHE_VERSION)
CCACHE_BUILD_DIR	:= $(embtk_toolsb)/ccachehost-build

CCACHE_HOST_DIR		:= $(embtk_htools)/usr/local/ccachehost
CCACHE_DIR		:= $(EMBTK_ROOT)/.ccache
CCACHE_BIN		:= $(CCACHE_HOST_DIR)/bin/ccache

# Variables for use in env
HOSTCC_CACHED		:= "$(CCACHE_BIN) $(HOSTCC)"
HOSTCXX_CACHED		:= "$(CCACHE_BIN) $(HOSTCXX)"

TARGETCC_CACHED		:= "$(CCACHE_BIN) $(TARGETCC)"
TARGETCXX_CACHED	:= "$(CCACHE_BIN) $(TARGETCXX)"

TARGETGCC_CACHED	:= "$(CCACHE_BIN) $(TARGETGCC)"
TARGETGCXX_CACHED	:= "$(CCACHE_BIN) $(TARGETGCXX)"

TARGETCLANG_CACHED	:= "$(CCACHE_BIN) $(TARGETCLANG)"
TARGETCLANGXX_CACHED	:= "$(CCACHE_BIN) $(TARGETCLANGXX)"

# Variables for use directly
hostcc_cached		:= $(CCACHE_BIN) $(HOSTCC)
hostcxx_cached		:= $(CCACHE_BIN) $(HOSTCXX)

targetcc_cached		:= $(CCACHE_BIN) $(TARGETCC)
targetcxx_cached	:= $(CCACHE_BIN) $(TARGETCXX)

targetgcc_cached	:= $(CCACHE_BIN) $(TARGETGCC)
targetgcxx_cached	:= $(CCACHE_BIN) $(TARGETGCXX)

targetclang_cached	:= $(CCACHE_BIN) $(TARGETCLANG)
targetclangxx_cached	:= $(CCACHE_BIN) $(TARGETCLANGXX)

export CCACHE_DIR HOSTCC_CACHED HOSTCXX_CACHED TARGETCC_CACHED TARGETCXX_CACHED

CCACHE_PREFIX		:= $(CCACHE_HOST_DIR)

define embtk_install_ccache
	$(call __embtk_install_hostpkg,ccache)
endef
