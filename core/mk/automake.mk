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
# \file         automake.mk
# \brief	automake.mk of Embtoolkit.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         February 2010
################################################################################

AUTOMAKE_NAME		:= automake
AUTOMAKE_VERSION	:= $(call embtk_get_pkgversion,AUTOMAKE)
AUTOMAKE_SITE		:= http://ftp.gnu.org/gnu/automake
AUTOMAKE_PACKAGE	:= automake-$(AUTOMAKE_VERSION).tar.xz
AUTOMAKE_SRC_DIR	:= $(embtk_toolsb)/automake-$(AUTOMAKE_VERSION)
AUTOMAKE_BUILD_DIR	:= $(embtk_toolsb)/automake-$(AUTOMAKE_VERSION)

AUTOMAKE_DIR	:= $(embtk_htools)/usr
ACLOCAL		:= $(AUTOMAKE_DIR)/bin/aclocal
AUTOMAKE	:= $(AUTOMAKE_DIR)/bin/automake
export ACLOCAL AUTOMAKE

define embtk_install_automake
	$(call __embtk_install_hostpkg,automake)
endef
