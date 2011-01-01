################################################################################
# Embtoolkit
# Copyright(C) 2010-2011 Abdoulaye Walsimou GAYE. All rights reserved.
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

#lua
include $(EMBTK_ROOT)/packages/scripting-languages/lua/lua.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LUA) += lua_install

#microperl
include $(EMBTK_ROOT)/packages/scripting-languages/perl/perl.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_MICROPERL) += microperl_install

