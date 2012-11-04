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
# \file         scripting-languages.mk
# \brief	scripting-languages.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         February 2010
################################################################################

# LUA and modules
include packages/scripting-languages/lua/lua.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LUA) += lua_install

include packages/scripting-languages/lua-modules/luafilesystem/luafilesystem.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LUAFILESYSTEM) += luafilesystem_install

include packages/scripting-languages/lua-modules/rings/rings.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_RINGS) += rings_install

include packages/scripting-languages/lua-modules/cgilua/cgilua.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_CGILUA) += cgilua_install

#microperl
include packages/scripting-languages/perl/perl.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_MICROPERL) += microperl_install

