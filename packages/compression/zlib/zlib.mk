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
# \file         zlib.mk
# \brief	zlib.mk of Embtoolkit.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         June 2009
################################################################################

ZLIB_NAME		:= zlib
ZLIB_VERSION		:= $(call embtk_get_pkgversion,zlib)
ZLIB_SITE		:= http://zlib.net
ZLIB_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
ZLIB_PACKAGE		:= zlib-$(ZLIB_VERSION).tar.bz2
ZLIB_SRC_DIR		:= $(PACKAGES_BUILD)/zlib-$(ZLIB_VERSION)
ZLIB_BUILD_DIR		:= $(PACKAGES_BUILD)/zlib-$(ZLIB_VERSION)

##########################
# zlib on target machine #
##########################
ZLIB_BINS		=
ZLIB_SBINS		=
ZLIB_INCLUDES		= zconf.h zlib.h
ZLIB_LIBS		= libz.*
ZLIB_PKGCONFIGS		= zlib.pc

ZLIB_LINUX_ARCH		:= $(if $(CONFIG_EMBTK_64BITS_FS),--64,)

ZLIB_CONFIGURE_ENV	:=
ZLIB_CONFIGURE_OPTS	:= $(ZLIB_LINUX_ARCH) --enable-shared


zlib_install:
	$(Q)test -e $(ZLIB_BUILD_DIR)/.installed || \
	$(MAKE) $(ZLIB_BUILD_DIR)/.installed

$(ZLIB_BUILD_DIR)/.installed: download_zlib \
	$(ZLIB_SRC_DIR)/.decompressed \
	$(ZLIB_BUILD_DIR)/.configured
	$(Q)$(MAKE) -C $(ZLIB_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(ZLIB_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)touch $@

$(ZLIB_SRC_DIR)/.decompressed:
	$(call embtk_decompress_pkg,zlib)

$(ZLIB_BUILD_DIR)/.configured:
	$(call embtk_pinfo,"Configure $(ZLIB_PACKAGE)...")
	$(call EMBTK_PRINT_CONFIGURE_OPTS,"$(ZLIB_CONFIGURE_OPTS)")
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
	LDFLAGS="-L$(SYSROOT)/$(LIBDIR) -L$(SYSROOT)/usr/$(LIBDIR)"	\
	CPPFLAGS="-I$(SYSROOT)/usr/include"				\
	PKG_CONFIG=$(PKGCONFIG_BIN)					\
	PKG_CONFIG_PATH=$(EMBTK_PKG_CONFIG_PATH)			\
	$(ZLIB_CONFIGURE_ENV)						\
	$(CONFIG_SHELL) $(ZLIB_SRC_DIR)/configure			\
	--libdir=/usr/$(LIBDIR)	--prefix=/usr --sysconfdir=/etc		\
	$(ZLIB_CONFIGURE_OPTS)
	@touch $@

zlib_clean:
	$(call embtk_cleanup_pkg,zlib)

########################
# zlib on host machine #
########################
ZLIB_HOST_NAME		:= $(ZLIB_NAME)
ZLIB_HOST_VERSION	:= $(ZLIB_VERSION)
ZLIB_HOST_SITE		:= $(ZLIB_SITE)
ZLIB_HOST_SITE_MIRROR1	:= $(ZLIB_SITE_MIRROR1)
ZLIB_HOST_SITE_MIRROR2	:= $(ZLIB_SITE_MIRROR2)
ZLIB_HOST_SITE_MIRROR3	:= $(ZLIB_SITE_MIRROR3)
ZLIB_HOST_PACKAGE	:= $(ZLIB_PACKAGE)
ZLIB_HOST_SRC_DIR	:= $(TOOLS_BUILD)/zlib-$(ZLIB_VERSION)
ZLIB_HOST_BUILD_DIR	:= $(TOOLS_BUILD)/zlib-$(ZLIB_VERSION)

ZLIB_HOST_CONFIGURE_ENV	:= CC=$(HOSTCC_CACHED)

zlib_host_install:
	$(Q)test -e $(ZLIB_HOST_BUILD_DIR)/.installed || \
	$(MAKE) $(ZLIB_HOST_BUILD_DIR)/.installed

$(ZLIB_HOST_BUILD_DIR)/.installed: download_zlib \
	$(ZLIB_HOST_SRC_DIR)/.decompressed \
	$(ZLIB_HOST_BUILD_DIR)/.configured
	$(Q)$(MAKE) -C $(ZLIB_HOST_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(ZLIB_HOST_BUILD_DIR) install
	$(Q)touch $@

$(ZLIB_HOST_SRC_DIR)/.decompressed:
	$(call embtk_decompress_pkg,zlib_host)

$(ZLIB_HOST_BUILD_DIR)/.configured:
	$(call embtk_pinfo,"Configure $(ZLIB_HOST_PACKAGE) for host...")
	$(call EMBTK_PRINT_CONFIGURE_OPTS,"$(ZLIB_HOST_CONFIGURE_OPTS)")
	$(Q)cd $(ZLIB_HOST_BUILD_DIR);					\
	CPPFLAGS="-I$(HOSTTOOLS)/usr/include"				\
	LDFLAGS="-L$(HOSTTOOLS)/$(LIBDIR) -L$(HOSTTOOLS)/usr/$(LIBDIR)"	\
	$(ZLIB_HOST_CONFIGURE_ENV)					\
	$(CONFIG_SHELL) $(ZLIB_HOST_SRC_DIR)/configure			\
	--prefix=$(HOSTTOOLS)/usr $(ZLIB_HOST_CONFIGURE_OPTS)
	$(Q)touch $@

zlib_host_clean:

##########
# Common #
##########

#zlib download
download_zlib download_zlib_host:
	$(call embtk_download_pkg,zlib)
