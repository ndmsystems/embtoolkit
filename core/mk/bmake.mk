################################################################################
# Embtoolkit
# Copyright(C) 2013-2014 Abdoulaye Walsimou GAYE.
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
# \file         bmake.mk
# \brief	bmake.mk of Embtoolkit.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         April 2013
################################################################################

BMAKE_NAME		:= bmake
BMAKE_VERSION		:= $(call embtk_get_pkgversion,bmake)
BMAKE_SITE		:= http://ftp.netbsd.org/pub/NetBSD/misc/sjg
BMAKE_PACKAGE		:= bmake-$(BMAKE_VERSION).tar.gz
BMAKE_SRC_DIR		:= $(embtk_toolsb)/bmake
BMAKE_BUILD_DIR		:= $(embtk_toolsb)/bmake-build

define __embtk_install_bmake
	cd $(BMAKE_BUILD_DIR) && MAKEFLAGS=""					\
		$(BMAKE_SRC_DIR)/boot-strap					\
			--prefix=$(embtk_htools)/usr --install
endef

define embtk_install_bmake
	$(__embtk_install_bmake)
endef

define embtk_cleanup_bmake
	rm -rf $(BMAKE_BUILD_DIR)
endef
