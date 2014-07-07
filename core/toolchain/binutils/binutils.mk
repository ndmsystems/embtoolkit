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
# \file         binutils.mk
# \brief	binutils.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

BINUTILS_NAME		:= binutils
BINUTILS_VERSION	:= $(call embtk_get_pkgversion,binutils)
BINUTILS_SITE		:= http://ftp.gnu.org/gnu/binutils
BINUTILS_GIT_SITE	:= git://sourceware.org/git/binutils.git
BINUTILS_PACKAGE	:= binutils-$(BINUTILS_VERSION).tar.bz2
BINUTILS_SRC_DIR	:= $(embtk_toolsb)/binutils-$(BINUTILS_VERSION)
BINUTILS_BUILD_DIR	:= $(embtk_toolsb)/binutils-build

BINUTILS_KEEP_SRC_DIR	:= $(embtk_toolchain_has_llvm-y)

BINUTILS_CONFIGURE_OPTS	:= --disable-werror --with-sysroot=$(embtk_sysroot)
BINUTILS_CONFIGURE_OPTS	+= --disable-nls --disable-multilib
BINUTILS_CONFIGURE_OPTS	+= --enable-gold --enable-plugins
BINUTILS_CONFIGURE_OPTS	+= --target=$(STRICT_GNU_TARGET)

BINUTILS_PREFIX		:= $(embtk_tools)

define embtk_beforeinstall_binutils
	$(if $(CONFIG_EMBTK_CLIB_MUSL),$(call __embtk_fixgconfigsfor_pkg,binutils))
	$(if $(findstring freebsd,$(embtk_buildhost_os)),
		bfdmk=$(call __embtk_pkg_srcdir,binutils)/bfd/Makefile.in;	\
		goldmk=$(call __embtk_pkg_srcdir,binutils)/gold/Makefile.in;	\
		sed -e 's/-ldl//g' < $$bfdmk > $$bfdmk.tmp;			\
			mv $$bfdmk.tmp $$bfdmk;					\
		sed -e 's/-ldl//g' < $$goldmk > $$goldmk.tmp;			\
			mv $$goldmk.tmp $$goldmk;)
	bfdtxi=$(call __embtk_pkg_srcdir,binutils)/bfd/doc/bfd.texinfo;	\
	sed -e 's/@colophon/@@colophon/' -e 's/doc@cygnus.com/doc@@cygnus.com/'	\
		< $$bfdtxi > $$bfdtxi.tmp; mv $$bfdtxi.tmp $$bfdtxi
endef

define embtk_install_binutils
	$(call embtk_makeinstall_hostpkg,binutils,autotooled)
endef
