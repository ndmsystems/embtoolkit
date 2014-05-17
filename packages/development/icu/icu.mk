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
# \file         icu.mk
# \brief        icu.mk of Embtoolkit.
# \author       Ricardo Crudo <ricardo.crudo@gmail.com>
# \date         May 2014
################################################################################

ICU_NAME	:= icu
ICU_VERSION	:= $(call embtk_get_pkgversion,icu)
ICU_SITE	:= http://download.icu-project.org/files/icu4c/$(ICU_VERSION)
ICU_PACKAGE	:= icu4c-$(subst .,_,$(ICU_VERSION))-src.tgz
ICU_SRC_DIR	:= $(embtk_pkgb)/icu
ICU_BUILD_DIR	:= $(embtk_pkgb)/icu-$(ICU_VERSION)-build

ICU_DEPS	:= icu_host_install

ICU_BINS	:= derb genbrk gencfu gencnval gendict genrb icu-config icuinfo
ICU_SBINS	:= genccode gencmn gennorm2 gensprep icupkg
ICU_BINS	+= makeconv  pkgdata
ICU_INCLUDES	+= layout unicode
ICU_LIBS	:= icu libicu*
ICU_PKGCONFIGS	:= icu-*.pc
ICU_SHARES	:= icu

ICU_CONFIGURE_OPTS := --disable-extras --disable-tests --disable-samples
ICU_CONFIGURE_OPTS += --enable-release --enable-shared --enable-static
ICU_CONFIGURE_OPTS += --with-cross-build=$(embtk_toolsb)/icu-$(ICU_VERSION)-build

ICU_CONFIGURE_DIR	:= source

#
# icu for host
#
ICU_HOST_NAME		:= $(ICU_NAME)
ICU_HOST_VERSION	:= $(ICU_VERSION)
ICU_HOST_SITE		:= $(ICU_SITE)
ICU_HOST_PACKAGE	:= $(ICU_PACKAGE)
ICU_HOST_SRC_DIR	:= $(embtk_toolsb)/icu
ICU_HOST_BUILD_DIR	= $(embtk_toolsb)/icu-$(ICU_VERSION)-build

ICU_HOST_CONFIGURE_OPTS := --disable-extras --disable-tests --disable-samples
ICU_HOST_CONFIGURE_OPTS += --enable-release

ICU_HOST_KEEP_SRC_DIR	:= y
ICU_HOST_CONFIGURE_DIR	:= $(ICU_CONFIGURE_DIR)
ICU_HOST_SET_RPATH	:= y
