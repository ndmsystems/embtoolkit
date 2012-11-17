################################################################################
# Embtoolkit
# Copyright(C) 2012 Abdoulaye Walsimou GAYE <awg@embtoolkit.org>.
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
# \file         compiler-rt.mk
# \brief	compiler-rt.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         October 2012
################################################################################

COMPILER-RT_NAME	:= compiler-rt
COMPILER-RT_VERSION	:= $(call embtk_get_pkgversion,compiler-rt)
COMPILER-RT_SITE	:= http://llvm.org/releases/$(COMPILER-RT_VERSION)
COMPILER-RT_GIT_SITE	:= http://llvm.org/git/compiler-rt.git
COMPILER-RT_PACKAGE	:= compiler-rt-$(COMPILER-RT_VERSION).src.tar.gz
COMPILER-RT_SRC_DIR	:= $(embtk_toolsb)/compiler-rt-$(COMPILER-RT_VERSION).src
COMPILER-RT_BUILD_DIR	:= $(embtk_toolsb)/compiler-rt-build

COMPILER-RT_CONFIGURE_OPTS	:=
COMPILER-RT_PREFIX		:= $(embtk_tools)

define embtk_install_compiler-rt
	$(call __embtk_install_pkg,compiler-rt)
endef
