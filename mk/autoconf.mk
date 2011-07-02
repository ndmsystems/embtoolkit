################################################################################
# Embtoolkit
# Copyright(C) 2010-2011 Abdoulaye Walsimou GAYE.
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
# \file         autoconf.mk
# \brief	autoconf.mk of Embtoolkit.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         February 2010
################################################################################

AUTOCONF_NAME		:= autoconf
AUTOCONF_VERSION	:= $(call embtk_get_pkgversion,AUTOCONF)
AUTOCONF_SITE		:= http://ftp.gnu.org/gnu/autoconf
AUTOCONF_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
AUTOCONF_PATCH_SITE	:= ftp://ftp.embtoolkit.org/embtoolkit.org/autoconf/$(AUTOCONF_VERSION)
AUTOCONF_PACKAGE	:= autoconf-$(AUTOCONF_VERSION).tar.bz2
AUTOCONF_SRC_DIR	:= $(TOOLS_BUILD)/autoconf-$(AUTOCONF_VERSION)
AUTOCONF_BUILD_DIR	:= $(TOOLS_BUILD)/autoconf-$(AUTOCONF_VERSION)

# autoconf binaries
AUTOCONF_DIR	:= $(HOSTTOOLS)/usr
AUTOCONF	:= $(AUTOCONF_DIR)/bin/autoconf
AUTOHEADER	:= $(AUTOCONF_DIR)/bin/autoheader
AUTOM4TE	:= $(AUTOCONF_DIR)/bin/autom4te
AUTORECONF	:= $(AUTOCONF_DIR)/bin/autoreconf
AUTOSCAN	:= $(AUTOCONF_DIR)/bin/autoscan
AUTOUPDATE	:= $(AUTOCONF_DIR)/bin/autoupdate
IFNAMES		:= $(AUTOCONF_DIR)/bin/ifnames
export AUTOCONF AUTOHEADER AUTOM4TE AUTORECONF AUTOSCAN AUTOUPDATE IFNAMES

autoconf_install:
	$(call embtk_install_hostpkg,AUTOCONF)

download_autoconf:
	$(call embtk_download_pkg,AUTOCONF)
