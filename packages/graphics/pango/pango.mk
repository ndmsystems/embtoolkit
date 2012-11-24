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
# \file         pango.mk
# \brief	pango.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

PANGO_NAME		:= pango
PANGO_MAJOR_VERSION	:= $(call embtk_get_pkgversion,pango_major)
PANGO_VERSION		:= $(call embtk_get_pkgversion,pango)
PANGO_SITE		:= http://ftp.gnome.org/pub/gnome/sources/pango/$(PANGO_MAJOR_VERSION)
PANGO_PACKAGE		:= pango-$(PANGO_VERSION).tar.bz2
PANGO_SRC_DIR		:= $(embtk_pkgb)/pango-$(PANGO_VERSION)
PANGO_BUILD_DIR		:= $(embtk_pkgb)/pango-$(PANGO_VERSION)

PANGO_BINS		= pango*
PANGO_SBINS		=
PANGO_INCLUDES		= pango*
PANGO_LIBS		= pango-* pango* libpango*
PANGO_PKGCONFIGS	= pango*.pc


PANGO_CONFIGURE_OPTS-y	:= $(if $(CONFIG_EMBTK_HAVE_PANGO_WITH_X),		\
				--with-x,--without-x)
PANGO_DEPS-y		:= $(if $(CONFIG_EMBTK_HAVE_PANGO_WITH_X),		\
				libx11_install)

PANGO_CONFIGURE_OPTS	:= $(PANGO_CONFIGURE_OPTS-y)
PANGO_DEPS		:= glib_install fontconfig_install
PANGO_DEPS		+= $(PANGO_DEPS-y) cairo_install

define embtk_postinstall_pango
	$(Q)mkdir -p $(embtk_rootfs)
	$(Q)mkdir -p $(embtk_rootfs)/usr
	$(Q)mkdir -p $(embtk_rootfs)/usr/$(LIBDIR)
	$(Q)-cp -R $(embtk_sysroot)/usr/$(LIBDIR)/pango $(embtk_rootfs)/usr/$(LIBDIR)/
endef
