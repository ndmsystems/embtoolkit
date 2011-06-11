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
# \file         system.mk
# \brief	system.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         July 2010
################################################################################

#dbus
include $(EMBTK_ROOT)/packages/system/dbus/dbus.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_DBUS) += dbus_install

# e2fsprogs
include $(EMBTK_ROOT)/packages/system/e2fsprogs/e2fsprogs.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_E2FSPROGS) += e2fsprogs_install
HOSTTOOLS_COMPONENTS-$(CONFIG_EMBTK_HOST_HAVE_E2FSPROGS) += e2fsprogs_host_install

#upstart
include $(EMBTK_ROOT)/packages/system/upstart/upstart.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_UPSTART) += upstart_install
