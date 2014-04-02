################################################################################
# Embtoolkit
# Copyright(C) 2012-2014 Abdoulaye Walsimou GAYE <awg@embtoolkit.org>.
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

CLANG_HOST_NAME		:= clang
CLANG_HOST_VERSION	:= $(call embtk_get_pkgversion,clang_host)
CLANG_HOST_SITE		:= http://llvm.org/releases/$(CLANG_HOST_VERSION)
#CLANG_HOST_GIT_SITE	:= http://llvm.org/git/clang.git
CLANG_HOST_GIT_SITE	:= git://www.embtoolkit.org/clang.git
CLANG_HOST_PACKAGE	:= clang-$(CLANG_HOST_VERSION).src.tar.gz
CLANG_HOST_SRC_DIR	:= $(embtk_toolsb)/clang-$(CLANG_HOST_VERSION).src
CLANG_HOST_BUILD_DIR	:= $(embtk_toolsb)/clang-$(CLANG_HOST_VERSION)-build

define embtk_install_clang_host
	$(call embtk_pinfo,"Compile/Install of clang will be done within llvm...")
	$(call embtk_download_pkg,clang_host)
	$(call embtk_decompress_pkg,clang_host)
endef
