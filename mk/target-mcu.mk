################################################################################
# Embtoolkit
# Copyright(C) 2009 Abdoulaye Walsimou GAYE. All rights reserved.
#
# This program is free software; you can distribute it and/or modify it
# under the terms of the GNU General Public License
# (Version 2 or later) published by the Free Software Foundation.
#
# This program is distributed in the hope it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
################################################################################
#
# \file         target_mcu.mk
# \brief	target_mcu.mk of Embtoolkit. Here we define LINUX_ARCH,
# \brief	GNU_ARCH and GNU_TARGET.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

#ARM
ifeq ($(CONFIG_EMBTK_ARCH_ARM),y)
include $(EMBTK_ROOT)/mk/arm-arch.mk
endif

#M68K

#MIPS
ifeq ($(CONFIG_EMBTK_ARCH_MIPS),y)
include $(EMBTK_ROOT)/mk/mips-arch.mk
endif


