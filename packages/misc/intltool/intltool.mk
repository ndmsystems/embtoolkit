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
# \file         intltool.mk
# \brief	intltool.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         June 2011
################################################################################

INTLTOOL_NAME		:= intltool
INTLTOOL_MAJOR_VERSION	:= $(call embtk_get_pkgversion,intltool_major)
INTLTOOL_VERSION	:= $(call embtk_get_pkgversion,intltool)
INTLTOOL_SITE		:= http://ftp.gnome.org/pub/gnome/sources/intltool/$(INTLTOOL_MAJOR_VERSION)
INTLTOOL_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
INTLTOOL_PACKAGE	:= intltool-$(INTLTOOL_VERSION).tar.bz2
INTLTOOL_SRC_DIR	:= $(embtk_pkgb)/intltool-$(INTLTOOL_VERSION)
INTLTOOL_BUILD_DIR	:= $(embtk_pkgb)/intltool-$(INTLTOOL_VERSION)

#
# intltool for target
#
INTLTOOL_BINS		:=
INTLTOOL_SBINS		:=
INTLTOOL_INCLUDES	:=
INTLTOOL_LIBS		:=
INTLTOOL_LIBEXECS	:=
INTLTOOL_PKGCONFIGS	:=

INTLTOOL_CONFIGURE_ENV	:=
INTLTOOL_CONFIGURE_OPTS	:=

INTLTOOL_DEPS :=

#
# intltool for host
#
INTLTOOL_HOST_NAME		:= $(INTLTOOL_NAME)
INTLTOOL_HOST_VERSION		:= $(INTLTOOL_VERSION)
INTLTOOL_HOST_SITE		:= $(INTLTOOL_SITE)
INTLTOOL_HOST_SITE_MIRROR3	:= $(INTLTOOL_SITE_MIRROR3)
INTLTOOL_HOST_PATCH_SITE	:= $(INTLTOOL_PATCH_SITE)
INTLTOOL_HOST_PACKAGE		:= $(INTLTOOL_PACKAGE)
INTLTOOL_HOST_SRC_DIR		:= $(embtk_toolsb)/intltool-$(INTLTOOL_VERSION)
INTLTOOL_HOST_BUILD_DIR		:= $(embtk_toolsb)/intltool-$(INTLTOOL_VERSION)

