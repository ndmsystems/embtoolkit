################################################################################
# Embtoolkit
# Copyright(C) 2012 Abdoulaye Walsimou GAYE.
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
# \file         odhcp6c.mk
# \brief	odhcp6c.mk of Embtoolkit
# \author       Averell KINOUANI <averell.kinouani@embtoolkit.org>
# \date         July 2015
################################################################################

ODHCP6C_NAME            := odhcp6c
ODHCP6C_SITE            := https://github.com/sbyx/odhcp6c/archive/
ODHCP6C_VERSION         := $(call embtk_get_pkgversion,odhcp6c)
ODHCP6C_PACKAGE         := v$(ODHCP6C_VERSION).tar.gz
ODHCP6C_SRC_DIR         := $(embtk_pkgb)/odhcp6c-$(ODHCP6C_VERSION)
ODHCP6C_BUILD_DIR       := $(embtk_pkgb)/odhcp6c-$(ODHCP6C_VERSION)

ODHCP6C_BINS            := odhcp6c


ODHCP6C_CMAKE_OPTS	:= "SET(CMAKE_SYSTEM_NAME Linux)\n\
			SET(CMAKE_C_COMPILER $(TARGETCC))\n\
			SET(CMAKE_CXX_COMPILER $(TARGETCXX))\n\
			SET(CMAKE_FIND_ROOT_PATH $(embtk_tools))\n\
			SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)\n\
			SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY $(embtk_sysroot)/usr/lib)\n\
			SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE $(embtk_sysroot)/usr/include)\n\
			SET(CMAKE_INSTALL_PREFIX $(embtk_sysroot)/usr)\n"


define embtk_install_odhcp6c
	printf $(ODHCP6C_CMAKE_OPTS) >> $(ODHCP6C_BUILD_DIR)/CMakeLists.txt;	\
	(cd $(ODHCP6C_BUILD_DIR)/ && cmake .; make; make install)
endef

