################################################################################
# Copyright(C) 2014 Abdoulaye Walsimou GAYE <awg@embtoolkit.org>.
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
# \file         core/toolchain/vars.mk
# \brief	toolchain variables
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2014
################################################################################

TARGETFC		:= $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-gfortran
TARGETGCC		:= $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-gcc
TARGETGCXX		:= $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-g++
TARGETCLANG		:= $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-clang
TARGETCLANGXX		:= $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-clang++

#
# Default compilers to use for packages.
#
__TARGETCC-y					:= $(TARGETGCC)
__TARGETCXX-y					:= $(TARGETGCXX)

__TARGETCC-$(embtk_toolchain_use_llvm-y)	:= $(TARGETCLANG)
__TARGETCXX-$(embtk_toolchain_use_llvm-y)	:= $(TARGETCLANGXX)

#
# FIXME: remove this when clang++ will support exceptions in c++ for arm,
# as exceptions seem to work for mips.
#
ifeq ($(CONFIG_EMBTK_ARCH_MIPS),y)
__TARGETCXX-$(CONFIG_EMBTK_LLVM_ONLY_TOOLCHAIN)		:= $(TARGETCLANGXX)
__TARGETCXX-$(CONFIG_EMBTK_LLVM_DEFAULT_TOOLCHAIN)	:= $(TARGETCLANGXX)
else
__TARGETCXX-$(CONFIG_EMBTK_LLVM_ONLY_TOOLCHAIN)		:= $(TARGETGCXX)
__TARGETCXX-$(CONFIG_EMBTK_LLVM_DEFAULT_TOOLCHAIN)	:= $(TARGETGCXX)
endif

TARGETCC		:= $(__TARGETCC-y)
TARGETCXX		:= $(__TARGETCXX-y)

#
# Clang static analyzer tools
#
ifeq ($(CONFIG_EMBTK_GCC_ONLY_TOOLCHAIN),)
TARGETSCANBUILD		:= $(embtk_tools)/bin/clang-scan-build/scan-build
TARGETSCANBUILD		+= --use-analyzer=$(TARGETCLANG)
TARGETSCANBUILD		+= --use-cc=$(TARGETCC)
TARGETSCANBUILD		+= --use-c++=$(TARGETCXX)
TARGETSCANVIEW		:= $(embtk_tools)/bin/clang-scan-view/scan-view
endif

#
# Some binutils components.
#
TARGETAS		:= $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-as
TARGETAR		:= $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-ar
TARGETRANLIB		:= $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-ranlib
TARGETLD		:= $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-ld
TARGETNM		:= $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-nm
TARGETSTRIP		:= $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-strip
TARGETOBJDUMP		:= $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-objdump
TARGETOBJCOPY		:= $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-objcopy
TARGETREADELF		:= $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-readelf

#
# TARGET cflags
#
__kconfig-cflags	:= $(strip $(CONFIG_EMBTK_TARGET_COMPILER_CFLAGS))
__TARGET_CFLAGS		:= $(subst ",,$(__kconfig-cflags))
__TARGET_CFLAGS		+= $(if $(CONFIG_EMBTK_TARGET_NONE_OPTIMIZED),-O0)
__TARGET_CFLAGS		+= $(if $(CONFIG_EMBTK_TARGET_SIZE_OPTIMIZED),-Os)
__TARGET_CFLAGS		+= $(if $(CONFIG_EMBTK_TARGET_SPEED_OPTIMIZED),-O2)
__TARGET_CFLAGS		+= $(if $(CONFIG_EMBTK_TARGET_WITH_DEBUG_DATA),-g)

# cflags for clang
__clang_cflags		:= -Qunused-arguments -fcolor-diagnostics
__TARGET_CFLAGS		+= $(if $(CONFIG_EMBTK_LLVM_ONLY_TOOLCHAIN),$(__clang_cflags))
__TARGET_CFLAGS		+= $(if $(CONFIG_EMBTK_LLVM_DEFAULT_TOOLCHAIN),$(__clang_cflags))

TARGET_CFLAGS		:= $(strip $(__TARGET_CFLAGS))
TARGET_CXXFLAGS		:= $(filter-out $(__clang_cflags),$(TARGET_CFLAGS))
CROSS_COMPILE		:= $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-

export TARGETCC TARGETCXX TARGETAR TARGETRANLIB TARGETLD TARGETNM
export TARGETSTRIP TARGETOBJDUMP TARGETOBJCOPY TARGET_CFLAGS CROSS_COMPILE

ac_cv_func_malloc_0_nonnull=yes
export ac_cv_func_malloc_0_nonnull
ac_cv_func_realloc_0_nonnull=yes
export ac_cv_func_realloc_0_nonnull

PATH			:= $(embtk_htools)/usr/bin:$(embtk_htools)/usr/sbin:$(PATH)
export PATH

LIBDIR			:= $(if $(CONFIG_EMBTK_64BITS_FS_COMPAT32),lib32,lib)
export LIBDIR
