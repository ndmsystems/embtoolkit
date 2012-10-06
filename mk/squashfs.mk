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
# \file         squashfs.mk
# \brief	squashfs.mk of Embtoolkit.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         August 2009
################################################################################

SQUASHFS_TOOLS_NAME		:= squashfs
SQUASHFS_TOOLS_VERSION		:= $(call embtk_get_pkgversion,squashfs_tools)
SQUASHFS_TOOLS_SITE		:= http://sourceforge.net/projects/squashfs/files/squashfs/squashfs$(SQUASHFS_TOOLS_VERSION)
SQUASHFS_TOOLS_PACKAGE		:= squashfs$(SQUASHFS_TOOLS_VERSION).tar.gz
SQUASHFS_TOOLS_SRC_DIR		:= $(embtk_toolsb)/squashfs$(SQUASHFS_TOOLS_VERSION)
SQUASHFS_TOOLS_BUILD_DIR	:= $(SQUASHFS_TOOLS_SRC_DIR)/squashfs-tools

MKSQUASHFS_BIN	:= $(embtk_htools)/usr/bin/mksquashfs
UNSQUASHFS_BIN	:= $(embtk_htools)/usr/bin/unsquashfs

SQUASHFS_TOOLS_DEPS := zlib_host_install

squashfs_tools_install: $(SQUASHFS_TOOLS_DEPS)
	$(Q)test -e $(SQUASHFS_TOOLS_BUILD_DIR)/.installed || 			\
	$(MAKE) $(SQUASHFS_TOOLS_BUILD_DIR)/.installed

$(SQUASHFS_TOOLS_BUILD_DIR)/.installed:
	$(call embtk_pinfo,"Compile/Install squashFS host tools")
	$(call embtk_download_pkg,squashfs_tools)
	$(call embtk_decompress_pkg,squashfs_tools)
	$(Q)$(MAKE) -C $(SQUASHFS_TOOLS_BUILD_DIR)				\
		CC=$(HOSTCC_CACHED)						\
		CPPFLAGS="-I$(embtk_htools)/usr/include"				\
		LDFLAGS="-L$(embtk_htools)/usr/lib"
	$(Q)mkdir -p $(embtk_htools)
	$(Q)mkdir -p $(embtk_htools)/usr
	$(Q)mkdir -p $(embtk_htools)/usr/bin
	$(Q)install $(SQUASHFS_TOOLS_BUILD_DIR)/mksquashfs $(embtk_htools)/usr/bin
	$(Q)install $(SQUASHFS_TOOLS_BUILD_DIR)/unsquashfs $(embtk_htools)/usr/bin
	$(Q)touch $@

squashfs_tools_clean:
	$(call embtk_pinfo,"Cleaning squashfs in host ...")
