################################################################################
# Embtoolkit
# Copyright(C) 2010-2012 Abdoulaye Walsimou GAYE.
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
LIBELF_SRC_DIR		:= $(PACKAGES_BUILD)/libelf-$(LIBELF_VERSION)
LIBELF_BUILD_DIR	:= $(PACKAGES_BUILD)/libelf-$(LIBELF_VERSION)

LIBELF_BINS		:=
LIBELF_SBINS		:=
LIBELF_INCLUDES		:= libelf gelf.h libelf.h nlist.h
LIBELF_LIBS		:= libelf.a
LIBELF_PKGCONFIGS	:= libelf.pc

LIBELF_CONFIGURE_OPTS	:= --enable-elf64 --disable-nls

#
# libelf for host development machine
#

LIBELF_HOST_NAME	:= $(LIBELF_NAME)
LIBELF_HOST_VERSION	:= $(LIBELF_VERSION)
LIBELF_HOST_SITE	:= $(LIBELF_SITE)
LIBELF_HOST_PACKAGE	:= $(LIBELF_PACKAGE)
LIBELF_HOST_SRC_DIR	:= $(TOOLS_BUILD)/libelf-$(LIBELF_VERSION)
LIBELF_HOST_BUILD_DIR	:= $(TOOLS_BUILD)/libelf-$(LIBELF_VERSION)

LIBELF_HOST_CONFIGURE_OPTS	:= --enable-elf64 --disable-nls
