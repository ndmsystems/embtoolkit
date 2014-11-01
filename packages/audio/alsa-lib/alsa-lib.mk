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
# \file         alsa-lib.mk
# \brief        alsa-lib.mk of Embtoolkit.
# \author       Ricardo Crudo <ricardo.crudo@gmail.com>
# \date         Nov 2014
################################################################################

ALSA-LIB_NAME		:= alsa-lib
ALSA-LIB_VERSION	:= $(call embtk_get_pkgversion,alsa-lib)
ALSA-LIB_SITE		:= ftp://ftp.alsa-project.org/pub/lib
ALSA-LIB_PACKAGE	:= alsa-lib-$(ALSA-LIB_VERSION).tar.bz2
ALSA-LIB_SRC_DIR	:= $(embtk_pkgb)/alsa-lib-$(ALSA-LIB_VERSION)
ALSA-LIB_BUILD_DIR	:= $(embtk_pkgb)/alsa-lib-$(ALSA-LIB_VERSION)

ALSA-LIB_BINS		:= aserver
ALSA-LIB_INCLUDES	:= alsa sys/asoundlib.h
ALSA-LIB_LIBS		:= alsa-lib libasound*
ALSA-LIB_PKGCONFIGS	:= alsa.pc
ALSA-LIB_SHARES		:= alsa aclocal/alsa.m4

ALSA-LIB_CONFIGURE_OPTS	:= --disable-python
