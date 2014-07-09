################################################################################
# Embtoolkit
# Copyright(C) 2013-2014 Abdoulaye Walsimou GAYE.
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
# \file         gmake.mk
# \brief	gmake.mk of Embtoolkit.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2013
################################################################################

GMAKE_HOST_NAME		:= gmake
GMAKE_HOST_VERSION	:= $(call embtk_get_pkgversion,gmake_host)
GMAKE_HOST_SITE		:= http://ftp.gnu.org/gnu/make
GMAKE_HOST_PACKAGE	:= make-$(GMAKE_HOST_VERSION).tar.bz2
GMAKE_HOST_SRC_DIR	:= $(embtk_toolsb)/make-$(GMAKE_HOST_VERSION)
GMAKE_HOST_BUILD_DIR	:= $(embtk_toolsb)/make-$(GMAKE_HOST_VERSION)

GMAKE_HOST_CONFIGURE_OPTS := --program-transform-name='s;make;gmake;'
