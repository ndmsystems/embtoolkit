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
# \file         fftw.mk
# \brief        fftw.mk of Embtoolkit.
# \author       Ricardo Crudo <ricardo.crudo@gmail.com>
# \date         April 2014
################################################################################

FFTW_NAME	:= fftw
FFTW_VERSION	:= $(call embtk_get_pkgversion,fftw)
FFTW_SITE	:= http://www.fftw.org
FFTW_PACKAGE	:= fftw-$(FFTW_VERSION).tar.gz
FFTW_SRC_DIR	:= $(embtk_pkgb)/fftw-$(FFTW_VERSION)
FFTW_BUILD_DIR	:= $(embtk_pkgb)/fftw-$(FFTW_VERSION)

FFTW_INCLUDES	:= fftw*.h
FFTW_LIBS	:= libfftw*.*
FFTW_PKGCONFIGS	:= fftw*.pc

FFTW_CONFIGURE_OPTS	:= --enable-shared
FFTW_CONFIGURE_OPTS-y	:=
# check whether is ARM architecture
FFTW_CONFIGURE_OPTS-$(CONFIG_EMBTK_ARCH_ARM)                += --with-slow-timer
FFTW_CONFIGURE_OPTS-$(CONFIG_EMBTK_ARCH_ARM_FPU_NEON)       += --enable-single --enable-neon
FFTW_CONFIGURE_OPTS-$(CONFIG_EMBTK_ARCH_ARM_FPU_NEON_FP16)  += --enable-single --enable-neon
FFTW_CONFIGURE_OPTS-$(CONFIG_EMBTK_ARCH_ARM_FPU_NEON_VFPV4) += --enable-single --enable-neon

FFTW_CONFIGURE_OPTS	+= $(FFTW_CONFIGURE_OPTS-y)
