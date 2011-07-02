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
# \file         lzo.mk
# \brief	lzo.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

LZO_NAME		:= lzo
LZO_VERSION		:= $(call embtk_get_pkgversion,LZO)
LZO_SITE		:= http://www.oberhumer.com/opensource/lzo/download
LZO_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
LZO_PATCH_SITE		:= ftp://ftp.embtoolkit.org/embtoolkit.org/lzo/$(LZO_VERSION)
LZO_PACKAGE		:= lzo-$(LZO_VERSION).tar.gz
LZO_SRC_DIR		:= $(PACKAGES_BUILD)/lzo-$(LZO_VERSION)
LZO_BUILD_DIR		:= $(PACKAGES_BUILD)/lzo-$(LZO_VERSION)

LZO_BINS =
LZO_SBINS =
LZO_INCLUDES = lzo
LZO_LIBS = liblzo2.*
LZO_LIBEXECS =
LZO_PKGCONFIGS =

LZO_CONFIGURE_ENV :=
LZO_CONFIGURE_OPTS :=

LZO_DEPS :=

lzo_install:
	$(call embtk_install_pkg,LZO)

lzo_clean:
	$(call embtk_cleanup_pkg,LZO)

#
# lzo common targets
#

download_lzo download_lzo_host:
	$(call embtk_download_pkg,LZO)

#
# LZO for host development machine
#
LZO_HOST_NAME		:= $(LZO_NAME)
LZO_HOST_VERSION	:= $(LZO_VERSION)
LZO_HOST_SITE		:= $(LZO_SITE)
LZO_HOST_SITE_MIRROR1	:= $(LZO_SITE_MIRROR1)
LZO_HOST_SITE_MIRROR2	:= $(LZO_SITE_MIRROR2)
LZO_HOST_SITE_MIRROR3	:= $(LZO_SITE_MIRROR3)
LZO_HOST_PATCH_SITE	:= $(LZO_PATCH_SITE)
LZO_HOST_PACKAGE	:= $(LZO_PACKAGE)
LZO_HOST_SRC_DIR	:= $(TOOLS_BUILD)/lzo-$(LZO_VERSION)
LZO_HOST_BUILD_DIR	:= $(TOOLS_BUILD)/lzo-$(LZO_VERSION)

lzo_host_install:
	$(call embtk_install_hostpkg,LZO_HOST)
