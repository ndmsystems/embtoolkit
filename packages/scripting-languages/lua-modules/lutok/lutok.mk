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
# \file         lutok.mk
# \brief	lutok.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         June 2014
################################################################################

LUTOK_NAME		:= lutok
LUTOK_VERSION		:= $(call embtk_get_pkgversion,lutok)
LUTOK_SITE		:= https://github.com/jmmv/lutok/releases/download/lutok-$(LUTOK_VERSION)
LUTOK_PACKAGE		:= lutok-$(LUTOK_VERSION).tar.gz
LUTOK_SRC_DIR		:= $(embtk_pkgb)/lutok-$(LUTOK_VERSION)
LUTOK_BUILD_DIR		:= $(embtk_pkgb)/lutok-$(LUTOK_VERSION)-build

LUTOK_LIBS		:= liblutok*
LUTOK_PKGCONFIGS	:= lutok.pc
LUTOK_SHARES		:= doc/lutok
LUTOK_LDFLAGS		:= -llua

LUTOK_DEPS		:= lua_install
