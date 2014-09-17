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
# \file         gdb_host.mk
# \brief	gdb_host.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         July 2009
################################################################################

GDB_HOST_NAME		:= gdb
GDB_HOST_VERSION	:= $(call embtk_pkg_version,gdb_host)
GDB_HOST_SITE		:= gdb-$(GDB_HOST_VERSION).tar.bz2
GDB_HOST_PACKAGE	:= gdb-$(GDB_HOST_VERSION).tar.bz2
GDB_HOST_SRC_DIR	:= $(embtk_toolsb)/gdb-$(GDB_HOST_VERSION)
GDB_HOST_BUILD_DIR	:= $(embtk_toolsb)/gdb-$(GDB_HOST_VERSION)

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
