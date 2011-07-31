################################################################################
# Embtoolkit
# Copyright(C) 2011 Abdoulaye Walsimou GAYE.
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
# \file         gdkpixbuf.mk
# \brief	gdkpixbuf.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         July 2011
################################################################################

GDKPIXBUF_NAME		:= gdkpixbuf
GDKPIXBUF_MAJOR_VERSION	:= $(call embtk_get_pkgversion,gdkpixbuf_major)
GDKPIXBUF_VERSION	:= $(call embtk_get_pkgversion,gdkpixbuf)
GDKPIXBUF_SITE		:= http://ftp.gnome.org/pub/GNOME/sources/gdk-pixbuf/$(GDKPIXBUF_MAJOR_VERSION)
GDKPIXBUF_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
GDKPIXBUF_PATCH_SITE	:= ftp://ftp.embtoolkit.org/embtoolkit.org/gdk-pixbuf/$(GDKPIXBUF_VERSION)
GDKPIXBUF_PACKAGE	:= gdk-pixbuf-$(GDKPIXBUF_VERSION).tar.bz2
GDKPIXBUF_SRC_DIR	:= $(PACKAGES_BUILD)/gdk-pixbuf-$(GDKPIXBUF_VERSION)
GDKPIXBUF_BUILD_DIR	:= $(PACKAGES_BUILD)/gdk-pixbuf-$(GDKPIXBUF_VERSION)

GDKPIXBUF_BINS		:=
GDKPIXBUF_SBINS		:=
GDKPIXBUF_INCLUDES	:=
GDKPIXBUF_LIBS		:=
GDKPIXBUF_LIBEXECS	:=
GDKPIXBUF_PKGCONFIGS	:=

GDKPIXBUF_CONFIGURE_ENV		:=
GDKPIXBUF_CONFIGURE_OPTS	:= --without-gdiplus --without-libjasper

GDKPIXBUF_DEPS			:= libpng_install libjpeg_install		\
				libtiff_install glib_install

gdkpixbuf_install:
	$(call embtk_install_pkg,gdkpixbuf)

gdkpixbuf_clean:
	$(call embtk_cleanup_pkg,gdkpixbuf)

#
# gdk-pixbuf for host development machine.
#

GDKPIXBUF_HOST_NAME		:= $(GDKPIXBUF_NAME)
GDKPIXBUF_HOST_VERSION		:= $(GDKPIXBUF_VERSION)
GDKPIXBUF_HOST_SITE		:= $(GDKPIXBUF_SITE)
GDKPIXBUF_HOST_SITE_MIRROR1	:= $(GDKPIXBUF_SITE_MIRROR1)
GDKPIXBUF_HOST_SITE_MIRROR2	:= $(GDKPIXBUF_SITE_MIRROR2)
GDKPIXBUF_HOST_SITE_MIRROR3	:= $(GDKPIXBUF_SITE_MIRROR3)
GDKPIXBUF_HOST_PATCH_SITE	:= $(GDKPIXBUF_PATCH_SITE)
GDKPIXBUF_HOST_PACKAGE		:= $(GDKPIXBUF_PACKAGE)
GDKPIXBUF_HOST_SRC_DIR		:= $(TOOLS_BUILD)/gdk-pixbuf-$(GDKPIXBUF_VERSION)
GDKPIXBUF_HOST_BUILD_DIR	:= $(TOOLS_BUILD)/gdk-pixbuf-$(GDKPIXBUF_VERSION)

GDKPIXBUF_HOST_SET_RPATH	:= y
GDKPIXBUF_HOST_CONFIGURE_OPTS	:= --without-gdiplus --without-libjasper

GDKPIXBUF_HOST_DEPS		:= libpng_host_install libjpeg_host_install	\
				libtiff_host_install glib_host_install

gdkpixbuf_host_install:
	$(call embtk_install_hostpkg,gdkpixbuf_host)

#
# Common targets
#
download_gdkpixbuf download_gdkpixbuf_host:
	$(call embtk_download_pkg,gdkpixbuf)
