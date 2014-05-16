################################################################################
# Embtoolkit
# Copyright(C) 2009-2014 Abdoulaye Walsimou GAYE.
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
# \file         lv2.mk
# \brief        lv2.mk of Embtoolkit.
# \author       Ricardo Crudo <ricardo.crudo@gmail.com>
# \date         May 2014
################################################################################

LV2_NAME	:= lv2
LV2_VERSION	:= $(call embtk_get_pkgversion,lv2)
LV2_SITE	:= http://lv2plug.in/spec
LV2_PACKAGE	:= lv2-$(LV2_VERSION).tar.bz2
LV2_SRC_DIR	:= $(embtk_pkgb)/lv2-$(LV2_VERSION)
LV2_BUILD_DIR	:= $(embtk_pkgb)/lv2-$(LV2_VERSION)


LV2_BINS	:= lv2specgen.py
LV2_INCLUDES	:= lv2 lv2.h
LV2_LIBS	:= lv2
LV2_PKGCONFIGS	:= lv2.pc lv2core.pc
LV2_SHARES	:= lv2specgen

LV2_CONFIGURE_OPTS  := --no-plugins
