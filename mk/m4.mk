################################################################################
# Embtoolkit
# Copyright(C) 2010-2011 Abdoulaye Walsimou GAYE.
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
# \file         m4.mk
# \brief	m4.mk of Embtoolkit.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         February 2010
################################################################################

M4_NAME		:= m4
M4_VERSION	:= $(call embtk_get_pkgversion,m4)
M4_SITE		:= http://ftp.gnu.org/gnu/m4
M4_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
M4_PACKAGE	:= m4-$(M4_VERSION).tar.bz2
M4_SRC_DIR	:= $(embtk_toolsb)/m4-$(M4_VERSION)
M4_BUILD_DIR	:= $(embtk_toolsb)/m4-$(M4_VERSION)

# m4 binaries
M4_DIR	:= $(embtk_htools)/usr
M4_BIN	:= $(M4_DIR)/bin/m4
M4	:= $(M4_BIN)
export M4

define embtk_install_m4
	$(call __embtk_install_hostpkg,m4)
endef
