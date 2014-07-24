################################################################################
# Embtoolkit
# Copyright(C) 2010-2014 Abdoulaye Walsimou GAYE.
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
# \file         libelf.mk
# \brief	libelf.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         January 2010
################################################################################

LIBELF_NAME		:= libelf
LIBELF_VERSION		:= $(call embtk_get_pkgversion,libelf)
LIBELF_SITE		:= http://www.mr511.de/software
LIBELF_PACKAGE		:= libelf-$(LIBELF_VERSION).tar.gz
LIBELF_SRC_DIR		:= $(embtk_pkgb)/libelf-$(LIBELF_VERSION)
LIBELF_BUILD_DIR	:= $(embtk_pkgb)/libelf-$(LIBELF_VERSION)

LIBELF_INCLUDES		:= libelf gelf.h libelf.h nlist.h
LIBELF_LIBS		:= libelf.a
LIBELF_PKGCONFIGS	:= libelf.pc

LIBELF_CONFIGURE_OPTS	:= --enable-elf64 --disable-nls
