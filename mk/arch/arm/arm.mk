################################################################################
# Embtoolkit
# Copyright(C) 2009-2012 Abdoulaye Walsimou GAYE.
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
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         June 2009
################################################################################

LINUX_ARCH		:= arm
GNU_TARGET_ARCH		:= arm
EMBTK_MCU_FLAG		:= $(subst ",,$(strip $(CONFIG_EMBTK_ARM_MCU_STRING)))

ifeq ($(CONFIG_EMBTK_CLIB_EGLIBC),y)
# EGLIBC C library
ifeq ($(CONFIG_EMBTK_ARCH_ARM_BIG_ENDIAN),y)
GNU_TARGET		:= armeb-linux
STRICT_GNU_TARGET	:= armeb-unknown-linux-gnueabi
else
GNU_TARGET		:= armel-linux
STRICT_GNU_TARGET	:= armel-unknown-linux-gnueabi
endif

else
# uClibc C library
ifeq ($(CONFIG_EMBTK_ARCH_ARM_BIG_ENDIAN),y)
GNU_TARGET		:= armeb-linux
STRICT_GNU_TARGET	:= armeb-unknown-linux-uclibceabi
else
GNU_TARGET		:= armel-linux
STRICT_GNU_TARGET	:= armel-unknown-linux-uclibceabi
endif

endif

# GCC configure options
GCC_WITH_CPU := --with-cpu=$(subst ",,$(strip $(CONFIG_EMBTK_ARM_MCU_STRING)))

# GCC extra configure options for arm
GCC3_CONFIGURE_EXTRA_OPTIONS += $(strip $(if $(CONFIG_EMBTK_GCC_LANGUAGE_JAVA),	\
					--enable-sjlj-exceptions))

# Hard or soft floating point for GCC?
GCC_WITH_FLOAT-$(CONFIG_EMBTK_SOFTFLOAT)		:= soft
GCC_WITH_FLOAT-$(CONFIG_EMBTK_HARDFLOAT)		:= softfp
GCC_WITH_FLOAT	:= --with-float=$(GCC_WITH_FLOAT-y)

GCC_WITH_FPU-$(CONFIG_EMBTK_ARCH_ARM_FPU_VFP)		:= vfp
GCC_WITH_FPU-$(CONFIG_EMBTK_ARCH_ARM_FPU_VFPV3)		:= vfpv3
GCC_WITH_FPU-$(CONFIG_EMBTK_ARCH_ARM_FPU_VFPV3_D16)	:= vfpv3-d16
GCC_WITH_FPU-$(CONFIG_EMBTK_ARCH_ARM_FPU_VFPV3_FP16)	:= vfpv3-fp16
GCC_WITH_FPU-$(CONFIG_EMBTK_ARCH_ARM_FPU_VFPV3_D16FP16)	:= vfpv3-d16-fp16
GCC_WITH_FPU-$(CONFIG_EMBTK_ARCH_ARM_FPU_VFPV3_XD)	:= vfpv3xd
GCC_WITH_FPU-$(CONFIG_EMBTK_ARCH_ARM_FPU_VFPV3_XDFP16)	:= vfpv3xd-fp16
GCC_WITH_FPU-$(CONFIG_EMBTK_ARCH_ARM_FPU_VFPV4)		:= vfpv4
GCC_WITH_FPU-$(CONFIG_EMBTK_ARCH_ARM_FPU_VFPV4_D16)	:= vfpv3-d16
GCC_WITH_FPU-$(CONFIG_EMBTK_ARCH_ARM_FPU_FPV4_SPD16)	:= fpv4-sp-d16
GCC_WITH_FPU-$(CONFIG_EMBTK_ARCH_ARM_FPU_NEON)		:= neon
GCC_WITH_FPU-$(CONFIG_EMBTK_ARCH_ARM_FPU_NEON_FP16)	:= neon-fp16
GCC_WITH_FPU-$(CONFIG_EMBTK_ARCH_ARM_FPU_NEON_VFPV4)	:= neon-vfpv4
GCC_WITH_FPU	:= $(if $(GCC_WITH_FPU-y),--with-fpu=$(GCC_WITH_FPU-y))

# Hard or soft floating point?
EMBTK_TARGET_FLOAT_CFLAGS := $(strip $(if $(CONFIG_EMBTK_SOFTFLOAT),		\
					-mfloat-abi=soft,-mfloat-abi=softfp))

# Some other flags for TARGET_CFLAGS
EMBTK_TARGET_MCPU	:= -mcpu=$(EMBTK_MCU_FLAG)
EMBTK_TARGET_MARCH	:=
