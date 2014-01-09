################################################################################
# Embtoolkit
# Copyright(C) 2009-2012 Abdoulaye Walsimou GAYE.
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

GDB_NAME		:= gdb
GDB_VERSION		:= $(call embtk_get_pkgversion,gdb)
GDB_SITE		:= http://ftp.gnu.org/gnu/gdb
GDB_PACKAGE		:= gdb-$(GDB_VERSION).tar.bz2
GDB_SRC_DIR		:= $(embtk_pkgb)/gdb-$(GDB_VERSION)
GDB_BUILD_DIR		:= $(embtk_pkgb)/gdb-$(GDB_VERSION)-build

GDBSERVER_NAME		:= $(GDB_NAME)
GDBSERVER_VERSION	:= $(GDB_VERSION)
GDBSERVER_SITE		:= $(GDB_SITE)
GDBSERVER_PACKAGE	:= $(GDB_PACKAGE)
GDBSERVER_SRC_DIR	:= $(GDB_SRC_DIR)
GDBSERVER_BUILD_DIR	:= $(embtk_pkgb)/gdbserver-$(GDB_VERSION)-build

GDB_DEPS := ncurses_install

GDB_CONFIGURE_OPTS := --disable-werror --disable-sim --disable-nls
GDB_CONFIGURE_OPTS += --with-bugurl="$(EMBTK_BUGURL)"
GDB_CONFIGURE_OPTS += --with-pkgversion="embtk-$(EMBTK_VERSION)"

GDBSERVER_DEPS := $(GDB_DEPS)
GDBSERVER_CONFIGURE_OPTS := $(GDB_CONFIGURE_OPTS)

#
# gdb
#
__GDB_INCLUDES	:= ansidecl.h bfd.h bfdlink.h dis-asm.h symcat.h gdb
__GDB_LIBS	:= lib*-sim.a  libbfd.*  libiberty.* libopcodes.*

GDB_BINS	:= gdb gdbtui run
GDB_BINS	+= $(if $(CONFIG_EMBTK_HAVE_GDBSERVER),,gdbserver)
GDB_INCLUDES	:= $(if $(CONFIG_EMBTK_HAVE_GDBSERVER),,$(__GDB_INCLUDES))
GDB_LIBS	:= $(if $(CONFIG_EMBTK_HAVE_GDBSERVER),,$(__GDB_LIBS))

#
# gdbserver
#
GDBSERVER_BINS		:= $(if $(CONFIG_EMBTK_HAVE_GDB),,gdbserver)
GDBSERVER_INCLUDES	:= $(if $(CONFIG_EMBTK_HAVE_GDB),,$(__GDB_INCLUDES))
GDBSERVER_LIBS		:= $(if $(CONFIG_EMBTK_HAVE_GDB),,$(__GDB_LIBS))

define embtk_postinstallonce_gdbserver
	rm -rf $(addprefix $(embtk_sysroot)/usr/bin/,$(GDB_BINS))
endef

#
# GDB for host development machine
#
GDB_HOST_NAME		:= gdb
GDB_HOST_VERSION	:= $(GDB_VERSION)
GDB_HOST_SITE		:= $(GDB_SITE)
GDB_HOST_SITE_MIRROR3	:= $(GDB_SITE_MIRROR3)
GDB_HOST_PACKAGE	:= $(GDB_PACKAGE)
GDB_HOST_SRC_DIR	:= $(embtk_toolsb)/gdb-$(GDB_VERSION)
GDB_HOST_BUILD_DIR	:= $(embtk_toolsb)/gdb-$(GDB_VERSION)

GDB_HOST_CONFIGURE_ENV	:= CC=$(HOSTCC_CACHED)
GDB_HOST_CONFIGURE_ENV	+= CXX=$(HOSTCXX_CACHED)
GDB_HOST_CONFIGURE_ENV	+= CC_FOR_TARGET=$(TARGETCC_CACHED)
GDB_HOST_CONFIGURE_ENV	+= CXX_FOR_TARGET=$(TARGETCXX_CACHED)
GDB_HOST_CONFIGURE_ENV	+= AR_FOR_TARGET=$(TARGETAR)
GDB_HOST_CONFIGURE_ENV	+= LD_FOR_TARGET=$(TARGETLD)
GDB_HOST_CONFIGURE_ENV	+= NM_FOR_TARGET=$(TARGETNM)
GDB_HOST_CONFIGURE_ENV	+= RANLIB_FOR_TARGET=$(TARGETRANLIB)
GDB_HOST_CONFIGURE_ENV	+= STRIP_FOR_TARGET=$(TARGETSTRIP)
GDB_HOST_CONFIGURE_ENV	+= OBJDUMP_FOR_TARGET=$(TARGETOBJDUMP)

GDB_HOST_CONFIGURE_OPTS	:= --disable-werror --enable-sim --disable-nls
GDB_HOST_CONFIGURE_OPTS	+= --with-bugurl="$(EMBTK_BUGURL)"
GDB_HOST_CONFIGURE_OPTS	+= --with-pkgversion="embtk-$(EMBTK_VERSION)"
GDB_HOST_CONFIGURE_OPTS	+= --target=$(STRICT_GNU_TARGET)
GDB_HOST_PREFIX		:= $(embtk_tools)

define embtk_cleanup_gdb_host
	rm -rf $(GDB_HOST_BUILD_DIR)
endef
