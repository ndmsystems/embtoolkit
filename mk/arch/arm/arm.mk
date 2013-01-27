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

__embtk_arm_endian	:= $(if $(CONFIG_EMBTK_TARGET_ARCH_LITTLE_ENDIAN),el,eb)
__embtk_arm_abi-$(CONFIG_EMBTK_CLIB_EGLIBC) := gnueabi
__embtk_arm_abi		:= $(or $(__embtk_arm_abi-y),$(embtk_clib)eabi)

LINUX_ARCH		:= arm
GNU_TARGET_ARCH		:= arm
EMBTK_MCU_FLAG		:= $(call __embtk_mk_uquote,$(CONFIG_EMBTK_ARM_MCU_STRING))
GNU_TARGET		:= arm$(__embtk_arm_endian)-$(embtk_os)
STRICT_GNU_TARGET	:= arm$(__embtk_arm_endian)-unknown-$(embtk_os)-$(__embtk_arm_abi)

#
# GCC/LLVM configure options
#
GCC_WITH_CPU		:= --with-cpu=$(EMBTK_MCU_FLAG)
LLVM_WITH_DEFAULT_CPU	:= --with-default-cpu=$(EMBTK_MCU_FLAG)

# GCC extra configure options for arm
GCC3_CONFIGURE_EXTRA_OPTIONS += $(strip $(if $(CONFIG_EMBTK_GCC_LANGUAGE_JAVA),	\
					--enable-sjlj-exceptions))

# Hard or soft floating point for GCC/LLVM?
GCC_WITH_FLOAT-$(CONFIG_EMBTK_SOFTFLOAT)		:= soft
GCC_WITH_FLOAT-$(CONFIG_EMBTK_HARDFLOAT)		:= softfp
GCC_WITH_FLOAT	:= --with-float=$(GCC_WITH_FLOAT-y)
LLVM_WITH_FLOAT	:= --with-default-float=$(GCC_WITH_FLOAT-y)

GCC_WITH_FPU-$(CONFIG_EMBTK_ARCH_ARM_FPU_VFP)		:= vfp
GCC_WITH_FPU-$(CONFIG_EMBTK_ARCH_ARM_FPU_VFPV3)		:= vfpv3
GCC_WITH_FPU-$(CONFIG_EMBTK_ARCH_ARM_FPU_VFPV3_D16)	:= vfpv3-d16
GCC_WITH_FPU-$(CONFIG_EMBTK_ARCH_ARM_FPU_VFPV3_FP16)	:= vfpv3-fp16
GCC_WITH_FPU-$(CONFIG_EMBTK_ARCH_ARM_FPU_VFPV3_D16FP16)	:= vfpv3-d16-fp16
GCC_WITH_FPU-$(CONFIG_EMBTK_ARCH_ARM_FPU_VFPV3_XD)	:= vfpv3xd
GCC_WITH_FPU-$(CONFIG_EMBTK_ARCH_ARM_FPU_VFPV3_XDFP16)	:= vfpv3xd-fp16
GCC_WITH_FPU-$(CONFIG_EMBTK_ARCH_ARM_FPU_VFPV4)		:= vfpv4
GCC_WITH_FPU-$(CONFIG_EMBTK_ARCH_ARM_FPU_VFPV4_D16)	:= vfpv4-d16
GCC_WITH_FPU-$(CONFIG_EMBTK_ARCH_ARM_FPU_FPV4_SPD16)	:= fpv4-sp-d16
GCC_WITH_FPU-$(CONFIG_EMBTK_ARCH_ARM_FPU_NEON)		:= neon
GCC_WITH_FPU-$(CONFIG_EMBTK_ARCH_ARM_FPU_NEON_FP16)	:= neon-fp16
GCC_WITH_FPU-$(CONFIG_EMBTK_ARCH_ARM_FPU_NEON_VFPV4)	:= neon-vfpv4
GCC_WITH_FPU	:= $(if $(GCC_WITH_FPU-y),--with-fpu=$(GCC_WITH_FPU-y))
LLVM_WITH_FPU	:= $(if $(GCC_WITH_FPU-y),--with-default-fpu=$(GCC_WITH_FPU-y))

# Hard or soft floating point?
EMBTK_TARGET_FLOAT_CFLAGS := $(strip $(if $(CONFIG_EMBTK_SOFTFLOAT),		\
					-mfloat-abi=soft,-mfloat-abi=softfp))

# Some other flags for TARGET_CFLAGS
EMBTK_TARGET_MCPU	:= -mcpu=$(EMBTK_MCU_FLAG)
EMBTK_TARGET_MARCH	:=

# Some cross compiler variables
__xtools_env_float	:= $(if $(CONFIG_EMBTK_SOFTFLOAT),sf,hf)
__xtools_archos		:= $(GNU_TARGET)
__xtools_env		:= $(EMBTK_MCU_FLAG)-$(__xtools_env_float)
