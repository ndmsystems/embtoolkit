################################################################################
# Embtoolkit
# Copyright(C) 2009-2014 Abdoulaye Walsimou GAYE.
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
# \file         openblas.mk
# \brief        openblas.mk of Embtoolkit.
# \author       Ricardo Crudo <ricardo.crudo@gmail.com>
# \date         May 2014
################################################################################

OPENBLAS_NAME		:= openblas
OPENBLAS_GIT_SITE	:= git://github.com/xianyi/OpenBLAS
OPENBLAS_SRC_DIR	:= $(call __embtk_pkg_srcdir,openblas)
OPENBLAS_BUILD_DIR	:= $(OPENBLAS_SRC_DIR)

OPENBLAS_LIBS		:= libopenblas*
OPENBLAS_INCLUDES	:= cblas.h f77blas.h lapacke_config.h lapacke.h
OPENBLAS_INCLUDES	+= lapacke_mangling.h lapacke_utils.h openblas_config.h

OPENBLAS_MAKE_OPTS	:= PREFIX=/usr AR=$(TARGETAR) RANLIB=$(TARGETRANLIB)
OPENBLAS_MAKE_OPTS	+= LD=$(TARGETLD) NM=$(TARGETNM)
OPENBLAS_MAKE_ENV	:= CC=$(TARGETGCC_CACHED) FC=$(TARGETFC)
OPENBLAS_MAKE_ENV	+= HOSTCC=$(HOSTCC_CACHED)

pembtk_openblas_target	:= GENERIC

ifeq (yy,$(CONFIG_EMBTK_ARCH_ARM_FAMILY_ARM11)$(CONFIG_EMBTK_HARDFLOAT))
pembtk_openblas_target	:= ARMV6
pembtk_openblas_armfpu	:= $(GCC_WITH_FPU-y)
endif
ifeq (yy,$(CONFIG_EMBTK_ARCH_ARM_FAMILY_CORTEX)$(CONFIG_EMBTK_HARDFLOAT))
pembtk_openblas_target	:= ARMV7
pembtk_openblas_armfpu	:= $(GCC_WITH_FPU-y)
endif
OPENBLAS_MAKE_ENV	+= $(if $(CONFIG_EMBTK_64BITS_FS),BINARY=64)
OPENBLAS_MAKE_ENV	+= TARGET=$(pembtk_openblas_target)


define embtk_beforeinstall_openblas
	$(if $(pembtk_openblas_armfpu),
	cp $(OPENBLAS_SRC_DIR)/Makefile.arm $(OPENBLAS_SRC_DIR)/Makefile.arm.bak
	sed -e 's/-mfpu=[[:alnum:]]*/-mfpu=$(pembtk_openblas_armfpu)/g'		\
		< $(OPENBLAS_SRC_DIR)/Makefile.arm				\
		> $(OPENBLAS_SRC_DIR)/Makefile.arm.new
	cp $(OPENBLAS_SRC_DIR)/Makefile.arm.new $(OPENBLAS_SRC_DIR)/Makefile.arm)
endef

define embtk_install_openblas
	$(embtk_beforeinstall_openblas)
        $(call embtk_makeinstall_pkg,openblas)
endef
