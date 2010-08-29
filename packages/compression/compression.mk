################################################################################
# Embtoolkit
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
# \file         compression.mk
# \brief	compression.mk of Embtoolkit.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         August 2010
################################################################################

#zlib for host and target
include $(EMBTK_ROOT)/packages/compression/zlib/zlib.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_ZLIB) += zlib_target_install
HOSTTOOLS_COMPONENTS-$(CONFIG_EMBTK_HOST_HAVE_ZLIB) += zlib_host_install
