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
# \file         armadillo.mk
# \brief        armadillo.mk of Embtoolkit.
# \author       Ricardo Crudo <ricardo.crudo@gmail.com>
# \date         May 2014
################################################################################

ARMADILLO_NAME		:= armadillo
ARMADILLO_VERSION	:= $(call embtk_get_pkgversion,armadillo)
ARMADILLO_SITE		:= http://sourceforge.net/projects/arma/files/
ARMADILLO_PACKAGE	:= armadillo-$(ARMADILLO_VERSION).tar.gz
ARMADILLO_SRC_DIR	:= $(embtk_pkgb)/armadillo-$(ARMADILLO_VERSION)
ARMADILLO_BUILD_DIR	:= $(embtk_pkgb)/armadillo-$(ARMADILLO_VERSION)

ARMADILLO_INCLUDES	:= armadillo*
ARMADILLO_LIBS		:= libarmadillo*
ARMADILLO_SHARES	:= Armadillo

ARMADILLO_CMAKE_OPTS	:= "SET(CMAKE_SYSTEM_NAME Linux)\n\
			SET(CMAKE_C_COMPILER $(TARGETCC))\n\
			SET(CMAKE_CXX_COMPILER $(TARGETCXX))\n\
			SET(CMAKE_FIND_ROOT_PATH $(embtk_tools))\n\
			SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)\n\
			SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY $(embtk_sysroot)/usr/lib)\n\
			SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE $(embtk_sysroot)/usr/include)\n\
			SET(CMAKE_INSTALL_PREFIX $(embtk_sysroot)/usr)\n"

# FIXME: For some strange reason (probably a bug) is needed run cmake twice
define embtk_install_armadillo
	$(call embtk_download_pkg,armadillo)
	$(call embtk_decompress_pkg,armadillo)
	rm -rf $(ARMADILLO_BUILD_DIR)/build
	mkdir $(ARMADILLO_BUILD_DIR)/build
	printf $(ARMADILLO_CMAKE_OPTS)						\
		> $(ARMADILLO_BUILD_DIR)/build/target.cmake
	cd $(ARMADILLO_BUILD_DIR)/build &&					\
		cmake -DCMAKE_TOOLCHAIN_FILE=target.cmake ..
	cd $(ARMADILLO_BUILD_DIR)/build &&					\
		cmake -DCMAKE_TOOLCHAIN_FILE=target.cmake ..
	$(MAKE) -C $(ARMADILLO_BUILD_DIR)/build
	$(MAKE) -C $(ARMADILLO_BUILD_DIR)/build install
endef
