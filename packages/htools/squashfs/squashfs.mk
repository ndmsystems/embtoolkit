################################################################################
# Embtoolkit
# Copyright(C) 2009-2014 Abdoulaye Walsimou GAYE.
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
# \file         squashfs.mk
# \brief	squashfs.mk of Embtoolkit.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         August 2009
################################################################################

SQUASHFS_HOST_NAME	:= squashfs
SQUASHFS_HOST_VERSION	:= $(call embtk_get_pkgversion,squashfs_host)
SQUASHFS_HOST_SITE	:= http://sourceforge.net/projects/squashfs/files/squashfs/squashfs$(SQUASHFS_HOST_VERSION)
SQUASHFS_HOST_PACKAGE	:= squashfs$(SQUASHFS_HOST_VERSION).tar.gz
SQUASHFS_HOST_SRC_DIR	:= $(embtk_toolsb)/squashfs$(SQUASHFS_HOST_VERSION)
SQUASHFS_HOST_BUILD_DIR	:= $(embtk_toolsb)/squashfs-$(SQUASHFS_HOST_VERSION)-build

MKSQUASHFS_BIN := $(embtk_htools)/usr/bin/mksquashfs
UNSQUASHFS_BIN := $(embtk_htools)/usr/bin/unsquashfs

SQUASHFS_HOST_DEPS := zlib_host_install

# Build cppflags
__embtk_squashfs_cppflags	:= -I$(embtk_htools)/usr/include
ifneq ($(embtk_buildhost_os),linux)
__embtk_squashfs_cppflags	+= -DFNM_EXTMATCH=0
endif

SQUASHFS_HOST_MAKE_ENV	:= CC=$(HOSTCC_CACHED)
SQUASHFS_HOST_MAKE_ENV	+= CPPFLAGS="$(__embtk_squashfs_cppflags)"
SQUASHFS_HOST_MAKE_ENV 	+= LDFLAGS="-L$(embtk_htools)/usr/lib"
SQUASHFS_HOST_MAKE_ENV	+= EXTRA_CFLAGS="-include sys/stat.h"

SQUASHFS_HOST_MAKE_OPTS	:= XATTR_SUPPORT=0
SQUASHFS_HOST_MAKE_OPTS	+= INSTALL_DIR="$(embtk_htools)/usr/bin"

define embtk_beforeinstall_squashfs_host
	rm -rf $(SQUASHFS_HOST_BUILD_DIR)
	ln -sf $(SQUASHFS_HOST_SRC_DIR)/squashfs-tools $(SQUASHFS_HOST_BUILD_DIR)
endef

define embtk_install_squashfs_host
	$(call embtk_makeinstall_hostpkg,squashfs_host)
endef

define embtk_cleanup_squashfs_tools
	rm -rf $(SQUASHFS_HOST_SRC_DIR)
endef
