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
# \file         zlib.mk
# \brief	zlib.mk of Embtoolkit.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         June 2009
################################################################################

ZLIB_NAME		:= zlib
ZLIB_VERSION		:= $(call embtk_get_pkgversion,zlib)
ZLIB_SITE		:= http://zlib.net
ZLIB_MIRROR1		:= http://sourceforge.net/projects/libpng/files/zlib/$(ZLIB_VERSION)
ZLIB_PACKAGE		:= zlib-$(ZLIB_VERSION).tar.bz2
ZLIB_SRC_DIR		:= $(embtk_pkgb)/zlib-$(ZLIB_VERSION)
ZLIB_BUILD_DIR		:= $(embtk_pkgb)/zlib-$(ZLIB_VERSION)


ZLIB_BINS		:=
ZLIB_SBINS		:=
ZLIB_INCLUDES		:= zconf.h zlib.h
ZLIB_LIBS		:= libz.*
ZLIB_PKGCONFIGS		:= zlib.pc

ZLIB_CONFIGURE_ENV	:=
ZLIB_CONFIGURE_OPTS	:= --enable-shared

define embtk_install_zlib
	$(call embtk_makeinstall_pkg,zlib)
endef

define embtk_configure_zlib
	$(Q)cd $(ZLIB_BUILD_DIR);					\
	CC=$(TARGETCC_CACHED)						\
	CXX=$(TARGETCXX_CACHED)						\
	AR=$(TARGETAR)							\
	RANLIB=$(TARGETRANLIB)						\
	AS=$(CROSS_COMPILE)as						\
	LD=$(TARGETLD)							\
	NM=$(TARGETNM)							\
	STRIP=$(TARGETSTRIP)						\
	OBJDUMP=$(TARGETOBJDUMP)					\
	OBJCOPY=$(TARGETOBJCOPY)					\
	CFLAGS="$(TARGET_CFLAGS)"					\
	CXXFLAGS="$(TARGET_CFLAGS)"					\
	LDFLAGS="-L$(embtk_sysroot)/$(LIBDIR) -L$(embtk_sysroot)/usr/$(LIBDIR)"	\
	CPPFLAGS="-I$(embtk_sysroot)/usr/include"				\
	PKG_CONFIG=$(PKGCONFIG_BIN)					\
	PKG_CONFIG_PATH=$(EMBTK_PKG_CONFIG_PATH)			\
	$(ZLIB_CONFIGURE_ENV)						\
	$(CONFIG_EMBTK_SHELL) $(ZLIB_SRC_DIR)/configure			\
		--libdir=/usr/$(LIBDIR)	--prefix=/usr --sysconfdir=/etc	\
		$(ZLIB_CONFIGURE_OPTS)
	$(Q)touch $(ZLIB_BUILD_DIR)/.configured
endef

define embtk_beforeinstall_zlib
	$(embtk_configure_zlib)
endef
