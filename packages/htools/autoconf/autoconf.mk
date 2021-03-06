################################################################################
# Embtoolkit
# Copyright(C) 2010-2014 Abdoulaye Walsimou GAYE.
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

AUTOCONF_HOST_NAME	:= autoconf
AUTOCONF_HOST_VERSION	:= $(call embtk_get_pkgversion,autoconf_host)
AUTOCONF_HOST_SITE	:= http://ftp.gnu.org/gnu/autoconf
AUTOCONF_HOST_PACKAGE	:= autoconf-$(AUTOCONF_HOST_VERSION).tar.bz2
AUTOCONF_HOST_SRC_DIR	:= $(embtk_toolsb)/autoconf-$(AUTOCONF_HOST_VERSION)
AUTOCONF_HOST_BUILD_DIR	:= $(embtk_toolsb)/autoconf-$(AUTOCONF_HOST_VERSION)
