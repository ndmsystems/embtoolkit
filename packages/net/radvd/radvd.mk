################################################################################
# Embtoolkit
# Copyright(C) 2012 Averell KINOUANI.
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
# \file         radvd.mk
# \brief	radvd.mk of Embtoolkit
# \author       Averell KINOUANI <a.kinouani@embtoolkit.org>
# \date         February 2015
################################################################################

RADVD_NAME		:= radvd
RADVD_VERSION		:= $(call embtk_get_pkgversion,radvd)
RADVD_SITE		:= http://www.litech.org/radvd/dist/
RADVD_PACKAGE		:= radvd-$(RADVD_VERSION).tar.gz
RADVD_SRC_DIR		:= $(embtk_pkgb)/radvd-$(RADVD_VERSION)
RADVD_BUILD_DIR	        := $(embtk_pkgb)/radvd-$(RADVD_VERSION)

RADVD_SBINS		:= radvd

RADVD_CONFIGURE_OPTS  	:= --program-transform-name=radvd
RADVD_CONFIGURE_OPTS	+= --without-check
