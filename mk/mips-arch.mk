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
# \file         mips_arch.mk
# \brief	mips_arch.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         May 2009
################################################################################

ifeq ($(CONFIG_EMBTK_ARCH_MIPS),y)
LINUX_ARCH := mips

ifeq ($(CONFIG_EMBTK_ARCH_MIPS_MIPS1_LITTLE),y)
GNU_TARGET := mipsel-linux
STRICT_GNU_TARGET := mipsel-unknown-linux-gnu
GNU_TARGET_ARCH := mips1
endif
ifeq ($(CONFIG_EMBTK_ARCH_MIPS_MIPS1_BIG),y)
GNU_TARGET := mips-linux
STRICT_GNU_TARGET := mips-unknown-linux-gnu
GNU_TARGET_ARCH := mips1
endif

ifeq ($(CONFIG_EMBTK_ARCH_MIPS_MIPS2_LITTLE),y)
GNU_TARGET := mipsel-linux
STRICT_GNU_TARGET := mipsel-unknown-linux-gnu
GNU_TARGET_ARCH := mips2
endif
ifeq ($(CONFIG_EMBTK_ARCH_MIPS_MIPS2_BIG),y)
GNU_TARGET := mips-linux
STRICT_GNU_TARGET := mips-unknown-linux-gnu
GNU_TARGET_ARCH := mips2
endif

ifeq ($(CONFIG_EMBTK_ARCH_MIPS_MIPS3_LITTLE),y)
GNU_TARGET := mips64el-linux
STRICT_GNU_TARGET := mips64el-unknown-linux-gnu
GNU_TARGET_ARCH := mips3
endif
ifeq ($(CONFIG_EMBTK_ARCH_MIPS_MIPS3_BIG),y)
GNU_TARGET := mips64-linux
STRICT_GNU_TARGET := mips64-unknown-linux-gnu
GNU_TARGET_ARCH := mips3
endif

ifeq ($(CONFIG_EMBTK_ARCH_MIPS_MIPS4_LITTLE),y)
GNU_TARGET := mips64el-linux
STRICT_GNU_TARGET := mips64el-unknown-linux-gnu
GNU_TARGET_ARCH := mips4
endif
ifeq ($(CONFIG_EMBTK_ARCH_MIPS_MIPS4_BIG),y)
GNU_TARGET := mips64-linux
STRICT_GNU_TARGET := mips64-unknown-linux-gnu
GNU_TARGET_ARCH := mips4
endif

ifeq ($(CONFIG_EMBTK_ARCH_MIPS_MIPS32_LITTLE),y)
GNU_TARGET := mipsel-linux
STRICT_GNU_TARGET := mipsisa32el-unknown-linux-gnu
GNU_TARGET_ARCH := mips32
endif
ifeq ($(CONFIG_EMBTK_ARCH_MIPS_MIPS32_BIG),y)
GNU_TARGET := mips-linux
STRICT_GNU_TARGET := mipsisa32-unknown-linux-gnu
GNU_TARGET_ARCH := mips32
endif

ifeq ($(CONFIG_EMBTK_ARCH_MIPS_MIPS32R2_LITTLE),y)
GNU_TARGET := mipsel-linux
STRICT_GNU_TARGET := mipsisa32r2el-unknown-linux-gnu
GNU_TARGET_ARCH := mips32r2
endif
ifeq ($(CONFIG_EMBTK_ARCH_MIPS_MIPS32R2_BIG),y)
GNU_TARGET := mips-linux
STRICT_GNU_TARGET := mipsisa32r2-unknown-linux-gnu
GNU_TARGET_ARCH := mips32r2
endif

ifeq ($(CONFIG_EMBTK_ARCH_MIPS_MIPS64_LITTLE),y)
GNU_TARGET := mips64el-linux
STRICT_GNU_TARGET := mipsisa64el-unknown-linux-gnu
GNU_TARGET_ARCH := mips64
endif
ifeq ($(CONFIG_EMBTK_ARCH_MIPS_MIPS64_BIG),y)
GNU_TARGET := mips64-linux
STRICT_GNU_TARGET := mipsisa64-unknown-linux-gnu
GNU_TARGET_ARCH := mips64
endif

ifeq ($(CONFIG_EMBTK_ARCH_MIPS_MIPS64R2_LITTLE),y)
GNU_TARGET := mips64el-linux
STRICT_GNU_TARGET := mipsisa64r2el-unknown-linux-gnu
GNU_TARGET_ARCH := mips64r2
endif
ifeq ($(CONFIG_EMBTK_ARCH_MIPS_MIPS64R2_BIG),y)
GNU_TARGET := mips64-linux
STRICT_GNU_TARGET := mipsisa64r2-unknown-linux-gnu
GNU_TARGET_ARCH := mips64r2
endif

EMBTK_MCU_FLAG := $(GNU_TARGET_ARCH)

#GCC configure options
GCC_WITH_ARCH := --with-arch=$(GNU_TARGET_ARCH)
export GCC_WITH_ARCH

ifeq ($(CONFIG_EMBTK_ARCH_MIPS_ABI_O32),y)
GCC_WITH_ABI := --with-abi=32
EMBTK_TARGET_ABI := -mabi=32
export GCC_WITH_ABI EMBTK_TARGET_ABI

else ifeq ($(CONFIG_EMBTK_ARCH_MIPS_ABI_N32),y)
GCC_WITH_ABI := --with-abi=n32
EMBTK_TARGET_ABI := -mabi=n32
export GCC_WITH_ABI EMBTK_TARGET_ABI

#else ifeq ($(CONFIG_EMBTK_ARCH_MIPS_ABI_EABI),y)
#GCC_WITH_ABI := --with-abi=eabi
#EMBTK_TARGET_ABI := -mabi=eabi
#export GCC_WITH_ABI EMBTK_TARGET_ABI

#else ifeq ($(CONFIG_EMBTK_ARCH_MIPS_ABI_O64),y)
#GCC_WITH_ABI := --with-abi=o64
#EMBTK_TARGET_ABI := -mabi=o64
#export GCC_WITH_ABI EMBTK_TARGET_ABI

else
GCC_WITH_ABI := --with-abi=64
EMBTK_TARGET_ABI := -mabi=64
export GCC_WITH_ABI EMBTK_TARGET_ABI
endif

endif

