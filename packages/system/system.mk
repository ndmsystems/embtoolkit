################################################################################
# Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# Copyright(C) 2010 Abdoulaye Walsimou GAYE. All rights reserved.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
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
# \file         system.mk
# \brief	system.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         July 2010
################################################################################

#dbus
include $(EMBTK_ROOT)/packages/system/dbus/dbus.mk
ROOTFS_COMPONENTS_CLEAN += dbus_clean
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_DBUS) += dbus_install

#util-linux-ng
include $(EMBTK_ROOT)/packages/system/utillinuxng/utillinuxng.mk
ROOTFS_COMPONENTS_CLEAN += utillinuxng_clean
