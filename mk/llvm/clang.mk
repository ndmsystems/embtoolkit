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
# \file         clang.mk
# \brief	clang.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         October 2012
################################################################################

CLANG_NAME		:= clang
CLANG_VERSION		:= $(call embtk_get_pkgversion,clang)
CLANG_SITE		:= http://llvm.org/releases/$(CLANG_VERSION)
#CLANG_GIT_SITE		:= http://llvm.org/git/clang.git
CLANG_GIT_SITE		:= git://www.embtoolkit.org/clang.git
CLANG_PACKAGE		:= clang-$(CLANG_VERSION).src.tar.gz
CLANG_SRC_DIR		:= $(embtk_toolsb)/clang-$(CLANG_VERSION).src
CLANG_BUILD_DIR		:= $(embtk_toolsb)/clang-build

define embtk_install_clang
	$(call embtk_pinfo,"Compile/Install of clang will be done within llvm...")
	$(call embtk_download_pkg,clang)
	$(call embtk_decompress_pkg,clang)
endef
