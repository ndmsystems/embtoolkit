################################################################################
# Embtoolkit
# Copyright(C) 2009-2012 Abdoulaye Walsimou GAYE <awg@embtoolkit.org>.
#
# This program is free software; you can distribute it and/or modify it
# under the terms of the GNU General Public License
# (Version 2 or later) published by the Free Software Foundation.
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
# \file         target-mcu.mk
# \brief	target-mcu.mk of Embtoolkit.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

# ARM
ifeq ($(CONFIG_EMBTK_ARCH_ARM),y)
include mk/arch/arm/arm.mk
endif

# MIPS
ifeq ($(CONFIG_EMBTK_ARCH_MIPS),y)
include mk/arch/mips/mips.mk
endif
