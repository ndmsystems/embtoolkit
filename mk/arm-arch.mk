################################################################################
# GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# Copyright(C) 2009 GAYE Abdoulaye Walsimou. All rights reserved.
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
# \file         arm-arch.mk
# \brief	arm-arch.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         June 2009
################################################################################

LINUX_ARCH := arm
GNU_TARGET_ARCH := arm
EMBTK_MCU_FLAG := $(subst ",,$(strip $(CONFIG_EMBTK_ARM_MCU_STRING)))

ifeq ($(CONFIG_EMBTK_ARCH_ARM_BIG_ENDIAN),y)
GNU_TARGET := armeb-linux
STRICT_GNU_TARGET := armeb-unknown-linux-gnueabi
else
GNU_TARGET := armel-linux
STRICT_GNU_TARGET := armel-unknown-linux-gnueabi
endif

#GCC configure options
GCC_WITH_CPU := --with-cpu=$(subst ",,$(strip $(CONFIG_EMBTK_ARM_MCU_STRING)))

#GCC extra configure options for arm
ifeq ($(CONFIG_EMBTK_GCC_LANGUAGE_JAVA),y)
GCC3_CONFIGURE_EXTRA_OPTIONS += --enable-sjlj-exceptions
endif

#Hard or soft floating point?
ifeq ($(CONFIG_EMBTK_SOFTFLOAT),y)
EMBTK_TARGET_FLOAT_CFLAGS := -mfloat-abi=soft
else
EMBTK_TARGET_FLOAT_CFLAGS := -mfloat-abi=hard
endif

