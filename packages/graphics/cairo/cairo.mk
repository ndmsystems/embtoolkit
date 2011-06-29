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
# \file         cairo.mk
# \brief	cairo.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

CAIRO_NAME		:= cairo
CAIRO_VERSION		:= $(call EMBTK_GET_PKG_VERSION,CAIRO)
CAIRO_SITE		:= http://www.cairographics.org/releases
CAIRO_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
CAIRO_PATCH_SITE	:= ftp://ftp.embtoolkit.org/embtoolkit.org/cairo/$(CAIRO_VERSION)
CAIRO_PACKAGE		:= cairo-$(CAIRO_VERSION).tar.gz
CAIRO_SRC_DIR		:= $(PACKAGES_BUILD)/cairo-$(CAIRO_VERSION)
CAIRO_BUILD_DIR		:= $(PACKAGES_BUILD)/cairo-$(CAIRO_VERSION)

CAIRO_BINS =
CAIRO_SBINS =
CAIRO_INCLUDES = cairo
CAIRO_LIBS = libcairo*
CAIRO_PKGCONFIGS = cairo*.pc

CAIRO_CONFIG_OPTS-y :=
CAIRO_CONFIG_OPTS-n :=
CAIRO_DEPS := pixman_install libpng_install freetype_install fontconfig_install

ifeq ($(CONFIG_EMBTK_HAVE_CAIRO_WITH_DIRECTFB),y)
CAIRO_DEPS += directfb_install
CAIRO_CONFIG_OPTS-y += --enable-directfb=yes
else
CAIRO_CONFIG_OPTS-n += --enable-directfb=no
endif

ifeq ($(CONFIG_EMBTK_HAVE_CAIRO_WITH_LIBXCB),y)
CAIRO_DEPS += xcbutil_install libx11_install
CAIRO_CONFIG_OPTS-y += --enable-xcb=yes
else
CAIRO_CONFIG_OPTS-n += --enable-xcb=no
CAIRO_CONFIG_OPTS-n += --without-x
endif

CAIRO_CONFIGURE_OPTS := $(CAIRO_CONFIG_OPTS-n) $(CAIRO_CONFIG_OPTS-y)	\
		--enable-pthread=yes

CAIRO_CONFIGURE_ENV	:= png_CFLAGS=`$(PKG_CONFIG_BIN) libpng --cflags`
CAIRO_CONFIGURE_ENV	+= png_LIBS=`$(PKG_CONFIG_BIN) libpng --cflags`

cairo_install:
	$(call EMBTK_INSTALL_PKG,CAIRO)

download_cairo:
	$(call EMBTK_DOWNLOAD_PKG,CAIRO)

cairo_clean:
	$(call EMBTK_CLEANUP_PKG,CAIRO)
