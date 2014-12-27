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
# \file         gdb.mk
# \brief	gdb.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         July 2009
################################################################################

GDB_NAME	:= gdb
GDB_VERSION	:= $(call embtk_get_pkgversion,gdb)
GDB_SITE	:= http://ftp.gnu.org/gnu/gdb
GDB_PACKAGE	:= gdb-$(GDB_VERSION).tar.xz
GDB_SRC_DIR	:= $(embtk_pkgb)/gdb-$(GDB_VERSION)
GDB_BUILD_DIR	:= $(embtk_pkgb)/gdb-$(GDB_VERSION)-build

GDB_DEPS           := $(GDBCOMMON_DEPS)
GDB_CONFIGURE_OPTS := $(GDBCOMMON_CONFIGURE_OPTS)

GDB_CONFIGURE_ENV  := $(GDBCOMMON_CONFIGURE_ENV)

GDB_BINS	:= $(GDBCOMMON_BINS)
GDB_BINS	+= $(if $(CONFIG_EMBTK_HAVE_GDBSERVER),,gdbserver)
GDB_INCLUDES	:= $(if $(CONFIG_EMBTK_HAVE_GDBSERVER),,$(GDBCOMMON_INCLUDES))
GDB_LIBS	:= $(if $(CONFIG_EMBTK_HAVE_GDBSERVER),,$(GDBCOMMON_LIBS))
