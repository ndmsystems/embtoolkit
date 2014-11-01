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
# \brief	gdbserver.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         July 2009
################################################################################

GDBSERVER_NAME		:= gdb
GDBSERVER_VERSION	:= $(call embtk_pkg_version,gdbserver)
GDBSERVER_SITE		:= http://ftp.gnu.org/gnu/gdb
GDBSERVER_PACKAGE	:= gdb-$(GDBSERVER_VERSION).tar.xz
GDBSERVER_SRC_DIR	:= $(embtk_pkgb)/gdb-$(GDBSERVER_VERSION)
GDBSERVER_BUILD_DIR	:= $(embtk_pkgb)/gdbserver-$(GDBSERVER_VERSION)-build

GDBSERVER_DEPS           := $(GDBCOMMON_DEPS)
GDBSERVER_CONFIGURE_OPTS := $(GDBCOMMON_CONFIGURE_OPTS)

GDBSERVER_BINS		:= $(if $(CONFIG_EMBTK_HAVE_GDB),,gdbserver)
GDBSERVER_INCLUDES	:= $(if $(CONFIG_EMBTK_HAVE_GDB),,$(GDBCOMMON_INCLUDES))
GDBSERVER_LIBS		:= $(if $(CONFIG_EMBTK_HAVE_GDB),,$(GDBCOMMON_LIBS))

define embtk_postinstallonce_gdbserver
	rm -rf $(addprefix $(embtk_sysroot)/usr/bin/,$(GDBCOMMON_BINS))
endef
