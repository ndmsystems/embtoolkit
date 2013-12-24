################################################################################
# Embtoolkit
# Copyright(C) 2009-2013 Abdoulaye Walsimou GAYE.
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
# \file         mips.mk
# \brief	mips.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

LINUX_ARCH		:= mips

__embtk_mips_endian	:= $(if $(CONFIG_EMBTK_TARGET_ARCH_LITTLE_ENDIAN),el)
__embtk_mips_abi-$(CONFIG_EMBTK_CLIB_EGLIBC)	:= gnu
__embtk_mips_abi-$(CONFIG_EMBTK_CLIB_GLIBC)	:= gnu
__embtk_mips_abi	:= $(or $(__embtk_mips_abi-y),$(embtk_clib))
__embtk_mips_64bit	:= $(if $(CONFIG_EMBTK_TARGET_ARCH_64BITS),64)

ifeq ($(CONFIG_EMBTK_ARCH_MIPS_MIPS1),y)
GNU_TARGET		:= mips$(__embtk_mips_endian)-$(embtk_os)
STRICT_GNU_TARGET	:= mips$(__embtk_mips_endian)-unknown-$(embtk_os)-$(__embtk_mips_abi)
GNU_TARGET_ARCH		:= mips1
endif

ifeq ($(CONFIG_EMBTK_ARCH_MIPS_MIPS2),y)
GNU_TARGET		:= mips$(__embtk_mips_endian)-$(embtk_os)
STRICT_GNU_TARGET	:= mips$(__embtk_mips_endian)-unknown-$(embtk_os)-$(__embtk_mips_abi)
GNU_TARGET_ARCH		:= mips2
endif

ifeq ($(CONFIG_EMBTK_ARCH_MIPS_MIPS3),y)
GNU_TARGET		:= mips64$(__embtk_mips_endian)-$(embtk_os)
STRICT_GNU_TARGET	:= mips64$(__embtk_mips_endian)-unknown-$(embtk_os)-$(__embtk_mips_abi)
GNU_TARGET_ARCH		:= mips3
endif

ifeq ($(CONFIG_EMBTK_ARCH_MIPS_MIPS4),y)
GNU_TARGET		:= mips64$(__embtk_mips_endian)-$(embtk_os)
STRICT_GNU_TARGET	:= mips64$(__embtk_mips_endian)-unknown-$(embtk_os)-$(__embtk_mips_abi)
GNU_TARGET_ARCH		:= mips4
endif

ifeq ($(CONFIG_EMBTK_ARCH_MIPS_MIPS32),y)
GNU_TARGET		:= mips$(__embtk_mips_endian)-$(embtk_os)
STRICT_GNU_TARGET	:= mipsisa32$(__embtk_mips_endian)-unknown-$(embtk_os)-$(__embtk_mips_abi)
GNU_TARGET_ARCH		:= mips32
endif

ifeq ($(CONFIG_EMBTK_ARCH_MIPS_MIPS32R2),y)
GNU_TARGET		:= mips$(__embtk_mips_endian)-$(embtk_os)
STRICT_GNU_TARGET	:= mipsisa32r2$(__embtk_mips_endian)-unknown-$(embtk_os)-$(__embtk_mips_abi)
GNU_TARGET_ARCH		:= mips32r2
endif

ifeq ($(CONFIG_EMBTK_ARCH_MIPS_MIPS64),y)
GNU_TARGET		:= mips64$(__embtk_mips_endian)-$(embtk_os)
STRICT_GNU_TARGET	:= mipsisa64$(__embtk_mips_endian)-unknown-$(embtk_os)-$(__embtk_mips_abi)
GNU_TARGET_ARCH		:= mips64
endif

ifeq ($(CONFIG_EMBTK_ARCH_MIPS_MIPS64R2),y)
GNU_TARGET		:= mips64$(__embtk_mips_endian)-$(embtk_os)
STRICT_GNU_TARGET	:= mipsisa64r2$(__embtk_mips_endian)-unknown-$(embtk_os)-$(__embtk_mips_abi)
GNU_TARGET_ARCH		:= mips64r2
endif

ifeq ($(CONFIG_EMBTK_ARCH_MIPS_OCTEON),y)
GNU_TARGET		:= mips64octeon$(__embtk_mips_endian)-$(embtk_os)
STRICT_GNU_TARGET	:= mips64octeon$(__embtk_mips_endian)-unknown-$(embtk_os)-$(__embtk_mips_abi)
GNU_TARGET_ARCH		:= octeon
endif

EMBTK_MCU_FLAG		:= $(GNU_TARGET_ARCH)

#
# GCC configure options
#
GCC_WITH_ARCH			:= --with-arch=$(GNU_TARGET_ARCH)

# Hard or soft floating point for GCC?
ifeq ($(CONFIG_EMBTK_HARDFLOAT),y)
GCC_WITH_FLOAT			:= --with-float=hard
LLVM_WITH_FLOAT			:= --with-default-float=hard
EMBTK_TARGET_FLOAT_CFLAGS	:= -mhard-float
__xtools_env_float		:= hf
else
GCC_WITH_FLOAT			:= --with-float=soft
LLVM_WITH_FLOAT			:= --with-default-float=soft
EMBTK_TARGET_FLOAT_CFLAGS	:= -msoft-float
__xtools_env_float		:= sf
endif

# ABI part
ifeq ($(CONFIG_EMBTK_ARCH_MIPS_ABI_O32),y)
GCC_WITH_ABI			:= --with-abi=32
LLVM_WITH_ABI			:= --with-default-abi=o32
EMBTK_TARGET_ABI		:= -mabi=32
__xtools_env_abi		:= o32

else ifeq ($(CONFIG_EMBTK_ARCH_MIPS_ABI_N32),y)
GCC_WITH_ABI			:= --with-abi=n32
LLVM_WITH_ABI			:= --with-default-abi=n32
EMBTK_TARGET_ABI		:= -mabi=n32
__xtools_env_abi		:= n32

#else ifeq ($(CONFIG_EMBTK_ARCH_MIPS_ABI_EABI),y)
#GCC_WITH_ABI			:= --with-abi=eabi
#EMBTK_TARGET_ABI		:= -mabi=eabi

#else ifeq ($(CONFIG_EMBTK_ARCH_MIPS_ABI_O64),y)
#GCC_WITH_ABI			:= --with-abi=o64
#EMBTK_TARGET_ABI		:= -mabi=o64

else
GCC_WITH_ABI			:= --with-abi=64
LLVM_WITH_ABI			:= --with-default-abi=n64
EMBTK_TARGET_ABI		:= -mabi=64
__xtools_env_abi		:= n64
endif

# Some other flags for TARGET_CFLAGS
EMBTK_TARGET_MCPU		:=
EMBTK_TARGET_MARCH		:= -march=$(EMBTK_MCU_FLAG)

# Some cross compiler variables
__xtools_archos			:= mips$(__embtk_mips_64bit)$(__embtk_mips_endian)-$(embtk_os)
__xtools_env			:= $(GNU_TARGET_ARCH)$(__xtools_env_float)-$(__xtools_env_abi)
