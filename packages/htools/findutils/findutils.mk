################################################################################
# Embtoolkit
# Copyright(C) 2009-2012 Abdoulaye Walsimou GAYE.
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
# \file         findutils.mk
# \brief	findutils for host development machine
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         October 2014
################################################################################

FINDUTILS_HOST_NAME		:= findutils
FINDUTILS_HOST_VERSION		:= $(call embtk_get_pkgversion,findutils_host)
FINDUTILS_HOST_SITE		:= http://ftp.gnu.org/pub/gnu/findutils
FINDUTILS_HOST_PACKAGE		:= findutils-$(FINDUTILS_HOST_VERSION).tar.gz
FINDUTILS_HOST_SRC_DIR		:= $(embtk_toolsb)/findutils-$(FINDUTILS_HOST_VERSION)
FINDUTILS_HOST_BUILD_DIR	:= $(embtk_toolsb)/findutils-$(FINDUTILS_HOST_VERSION)-build

FINDUTILS_HOST_CONFIGURE_OPTS := --disable-nls
