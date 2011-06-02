################################################################################
# Embtoolkit
# Copyright(C) 2009-2011 Abdoulaye Walsimou GAYE.
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
GDB_VERSION		:= $(call EMBTK_GET_PKG_VERSION,GDB)
GDB_SITE		:= http://ftp.gnu.org/gnu/gdb
GDB_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
GDB_PATCH_SITE		:= ftp://ftp.embtoolkit.org/embtoolkit.org/gdb/$(GDB_VERSION)
GDB_PACKAGE		:= gdb-$(GDB_VERSION).tar.bz2
GDB_SRC_DIR		:= $(PACKAGES_BUILD)/gdb-$(GDB_VERSION)
GDB_BUILD_DIR		:= $(PACKAGES_BUILD)/gdb-$(GDB_VERSION)

# GDB installed files
GDBSERVER_BIN	:= $(if $(CONFIG_EMBTK_HAVE_GDBSERVER),,gdbserver)
GDB_BINS	:= gdb $(GDBSERVER_BIN) gdbtui run
GDB_SBINS	:=
GDB_INCLUDES	:= $(if $(CONFIG_EMBTK_HAVE_GDBSERVER),			\
			,,ansidecl.h bfd.h bfdlink.h dis-asm.h symcat.h)
GDB_LIBS	:= $(if $(CONFIG_EMBTK_HAVE_GDBSERVER),			\
			,,lib*-sim.a  libbfd.*  libiberty.* libopcodes.*)
GDB_LIBEXECS	:=
GDB_PKGCONFIGS	:=

GDB_CONFIGURE_ENV	:=
GDB_CONFIGURE_OPTS	:= --disable-werror --disable-sim		\
			--with-bugurl="$(EMBTK_BUGURL)"			\
			--with-pkgversion="embtk-$(EMBTK_VERSION)"

GDB_DEPS := ncurses_install

#
# GDB for target
#
gdbfull_install:
	$(call EMBTK_INSTALL_PKG,GDB)

gdbserver_install:
	@test -e $(GDB_BUILD_DIR)/.gdbserver_installed ||		\
	$(MAKE) $(GDB_BUILD_DIR)/.gdbserver_installed

$(GDB_BUILD_DIR)/.gdbserver_installed: $(GDB_DEPS)			\
		download_gdb						\
		$(GDB_BUILD_DIR)/.gdbserver_decompressed		\
		$(GDB_BUILD_DIR)/.gdbserver_configured
	$(Q)$(MAKE) -C $(GDB_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(GDB_BUILD_DIR)/gdb/gdbserver			\
		DESTDIR=$(SYSROOT)/$(GDB_SYSROOT_SUFFIX) install
	$(Q)$(MAKE) libtool_files_adapt
	@touch $@

$(GDB_BUILD_DIR)/.gdbserver_configured:
	$(call EMBTK_CONFIGURE_PKG,GDB)
	@touch $@

$(GDB_BUILD_DIR)/.gdbserver_decompressed:
	$(call EMBTK_DECOMPRESS_PKG,GDB)
	@touch $@

gdbserver_clean gdbfull_clean:
	$(call EMBTK_CLEANUP_PKG,GDB)

#
# GDB for host development machine
#
GDB_HOST_NAME		:= gdb
GDB_HOST_VERSION	:= $(GDB_VERSION)
GDB_HOST_SITE		:= $(GDB_SITE)
GDB_HOST_SITE_MIRROR3	:= $(GDB_SITE_MIRROR3)
GDB_HOST_PATCH_SITE	:= $(GDB_PATCH_SITE)
GDB_HOST_PACKAGE	:= $(GDB_PACKAGE)
GDB_HOST_SRC_DIR	:= $(TOOLS_BUILD)/gdb-$(GDB_VERSION)
GDB_HOST_BUILD_DIR	:= $(TOOLS_BUILD)/gdb-$(GDB_VERSION)

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

GDB_HOST_CONFIGURE_OPTS	:= --disable-werror --disable-sim		\
			--with-bugurl="$(EMBTK_BUGURL)"			\
			--with-pkgversion="embtk-$(EMBTK_VERSION)"	\
			--target=$(STRICT_GNU_TARGET)
GDB_HOST_PREFIX := $(TOOLS)

gdb_host_install:
	$(call EMBTK_INSTALL_HOSTPKG,GDB_HOST)

gdb_host_clean:
	$(call EMBTK_GENERIC_MSG,"Clean up gdb host")

#
# Common for target and host development machine
#
download_gdb:
	$(call EMBTK_DOWNLOAD_PKG,GDB)
