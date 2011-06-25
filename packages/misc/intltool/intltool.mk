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
INTLTOOL_MAJOR_VERSION	:= $(call EMBTK_GET_PKG_VERSION,INTLTOOL_MAJOR)
INTLTOOL_VERSION	:= $(call EMBTK_GET_PKG_VERSION,INTLTOOL)
INTLTOOL_SITE		:= http://ftp.gnome.org/pub/gnome/sources/intltool/$(INTLTOOL_MAJOR_VERSION)
INTLTOOL_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
INTLTOOL_PATCH_SITE	:= ftp://ftp.embtoolkit.org/embtoolkit.org/intltool/$(INTLTOOL_VERSION)
INTLTOOL_PACKAGE	:= intltool-$(INTLTOOL_VERSION).tar.bz2
INTLTOOL_SRC_DIR	:= $(PACKAGES_BUILD)/intltool-$(INTLTOOL_VERSION)
INTLTOOL_BUILD_DIR	:= $(PACKAGES_BUILD)/intltool-$(INTLTOOL_VERSION)

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

intltool_install:
	$(call EMBTK_INSTALL_PKG,INTLTOOL)

intltool_clean:
	$(call EMBTK_CLEANUP_PKG,INTLTOOL)

#
# intltool for host
#
INTLTOOL_HOST_NAME		:= $(INTLTOOL_NAME)
INTLTOOL_HOST_VERSION		:= $(INTLTOOL_VERSION)
INTLTOOL_HOST_SITE		:= $(INTLTOOL_SITE)
INTLTOOL_HOST_SITE_MIRROR3	:= $(INTLTOOL_SITE_MIRROR3)
INTLTOOL_HOST_PATCH_SITE	:= $(INTLTOOL_PATCH_SITE)
INTLTOOL_HOST_PACKAGE		:= $(INTLTOOL_PACKAGE)
INTLTOOL_HOST_SRC_DIR		:= $(TOOLS_BUILD)/intltool-$(INTLTOOL_VERSION)
INTLTOOL_HOST_BUILD_DIR		:= $(TOOLS_BUILD)/intltool-$(INTLTOOL_VERSION)

intltool_host_install:
	$(call EMBTK_INSTALL_HOSTPKG,INTLTOOL_HOST)

#
# common targets
#
download_intltool download_intltool_host:
	$(call EMBTK_DOWNLOAD_PKG,INTLTOOL)
