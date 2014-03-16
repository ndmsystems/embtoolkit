################################################################################
# Embtoolkit
# Copyright(C) 2009-2014 Abdoulaye Walsimou GAYE.
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

CCACHE_HOST_NAME		:= ccache
CCACHE_HOST_VERSION		:= $(call embtk_get_pkgversion,ccache_host)
CCACHE_HOST_SITE		:= http://samba.org/ftp/ccache
CCACHE_HOST_PACKAGE		:= ccache-$(CCACHE_HOST_VERSION).tar.bz2
CCACHE_HOST_SRC_DIR		:= $(embtk_toolsb)/ccache-$(CCACHE_HOST_VERSION)
CCACHE_HOST_BUILD_DIR		:= $(embtk_toolsb)/ccachehost-build

define embtk_postinstallonce_ccache_host
	CCACHE_DIR=$(CCACHE_DIR) $(CCACHE_BIN) --max-size=2GB
endef
