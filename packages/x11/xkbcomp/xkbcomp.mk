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
# \file         xkbcomp.mk
# \brief	xkbcomp.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

XKBCOMP_NAME		:= xkbcomp
XKBCOMP_VERSION		:= $(call embtk_get_pkgversion,xkbcomp)
XKBCOMP_SITE		:= http://xorg.freedesktop.org/archive/individual/app
XKBCOMP_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
XKBCOMP_PACKAGE		:= xkbcomp-$(XKBCOMP_VERSION).tar.bz2
XKBCOMP_SRC_DIR		:= $(embtk_pkgb)/xkbcomp-$(XKBCOMP_VERSION)
XKBCOMP_BUILD_DIR	:= $(embtk_pkgb)/xkbcomp-$(XKBCOMP_VERSION)

XKBCOMP_BINS		= xkbcomp
XKBCOMP_SBINS		=
XKBCOMP_INCLUDES	=
XKBCOMP_LIBS 		=
XKBCOMP_PKGCONFIGS	=

XKBCOMP_DEPS		= libxkbfile_install
