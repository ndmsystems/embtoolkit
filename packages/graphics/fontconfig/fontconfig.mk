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
# \file         fontconfig.mk
# \brief	fontconfig.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

FONTCONFIG_NAME		:= fontconfig
FONTCONFIG_VERSION	:= $(call embtk_get_pkgversion,fontconfig)
FONTCONFIG_SITE		:= http://fontconfig.org/release
FONTCONFIG_PACKAGE	:= fontconfig-$(FONTCONFIG_VERSION).tar.gz
FONTCONFIG_SRC_DIR	:= $(embtk_pkgb)/fontconfig-$(FONTCONFIG_VERSION)
FONTCONFIG_BUILD_DIR	:= $(embtk_pkgb)/fontconfig-$(FONTCONFIG_VERSION)

FONTCONFIG_BINS		:= fc-cache fc-cat fc-list fc-match fc-query fc-scan
FONTCONFIG_INCLUDES	:= fontconfig
FONTCONFIG_LIBS		:= libfontconfig*
FONTCONFIG_PKGCONFIGS	:= fontconfig.pc

LIBXML2_CFLAGS-y	:= -I$(embtk_sysroot)/usr/include/libxml2
LIBXML2_LIBS-y		:= -L$(embtk_sysroot)/usr/$(LIBDIR) -lxml2

FREETYPE_CFLAGS-y	= $(call embtk_pkgconfig-cflags,freetype2)
FREETYPE_LIBS-y		= $(call embtk_pkgconfig-libs,freetype2)

FONTCONFIG_CONFIGURE_ENV	= LIBXML2_CFLAGS="$(LIBXML2_CFLAGS-y)"
FONTCONFIG_CONFIGURE_ENV	+= LIBXML2_CFLAGS="$(LIBXML2_LIBS-y)"
FONTCONFIG_CONFIGURE_ENV	+= FREETYPE_CFLAGS="$(FREETYPE_CFLAGS-y)"
FONTCONFIG_CONFIGURE_ENV	+= FREETYPE_LIBS="$(FREETYPE_LIBS-y)"

FONTCONFIG_CONFIGURE_OPTS	:= --with-arch=$(STRICT_GNU_TARGET)	\
				--disable-docs --program-prefix=""	\
				--with-freetype-config=true

FONTCONFIG_MAKE_OPTS		= LIBXML2_CFLAGS="$(LIBXML2_CFLAGS-y)"
FONTCONFIG_MAKE_OPTS		+= LIBXML2_LIBS="$(LIBXML2_LIBS-y)"
FONTCONFIG_MAKE_OPTS		+= FREETYPE_CFLAGS="$(FREETYPE_CFLAGS-y)"
FONTCONFIG_MAKE_OPTS		+= FREETYPE_LIBS="$(FREETYPE_LIBS-y)"

FONTCONFIG_DEPS			:= libxml2_install freetype_install

define embtk_postinstall_fontconfig
	$(Q)-cp -R $(embtk_sysroot)/usr/etc/fonts $(embtk_rootfs)/etc/
endef
