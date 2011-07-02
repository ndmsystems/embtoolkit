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
AUTOMAKE_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
AUTOMAKE_PATCH_SITE	:= ftp://ftp.embtoolkit.org/embtoolkit.org/automake/$(AUTOMAKE_VERSION)
AUTOMAKE_PACKAGE	:= automake-$(AUTOMAKE_VERSION).tar.bz2
AUTOMAKE_SRC_DIR	:= $(TOOLS_BUILD)/automake-$(AUTOMAKE_VERSION)
AUTOMAKE_BUILD_DIR	:= $(TOOLS_BUILD)/automake-$(AUTOMAKE_VERSION)

AUTOMAKE_DIR	:= $(HOSTTOOLS)/usr
ACLOCAL		:= $(AUTOMAKE_DIR)/bin/aclocal
AUTOMAKE	:= $(AUTOMAKE_DIR)/bin/automake
export ACLOCAL AUTOMAKE

automake_install:
	$(call embtk_install_hostpkg,AUTOMAKE)

download_automake:
	$(call embtk_download_pkg,AUTOMAKE)
