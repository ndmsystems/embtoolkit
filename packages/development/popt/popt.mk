################################################################################
# Embtoolkit
# Copyright(C) 2014 Abdoulaye Walsimou GAYE.
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
# \file         popt.mk
# \brief	popt.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         January 2014
################################################################################

POPT_NAME		:= popt
POPT_VERSION		:= $(call embtk_get_pkgversion,popt)
POPT_SITE		:= http://rpm5.org/files/popt
POPT_PACKAGE		:= popt-$(POPT_VERSION).tar.gz
POPT_SRC_DIR		:= $(embtk_pkgb)/popt-$(POPT_VERSION)
POPT_BUILD_DIR		:= $(embtk_pkgb)/popt-$(POPT_VERSION)

POPT_INCLUDES		:= popt.h
POPT_LIBS		:= libpopt.*
POPT_PKGCONFIGS		:= popt.pc
