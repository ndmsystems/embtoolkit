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
# \file         libsamplerate.mk
# \brief        libsamplerate.mk of Embtoolkit.
# \author       Ricardo Crudo <ricardo.crudo@gmail.com>
# \date         May 2014
################################################################################

LIBSAMPLERATE_NAME	:= libsamplerate
LIBSAMPLERATE_VERSION	:= $(call embtk_get_pkgversion,libsamplerate)
LIBSAMPLERATE_SITE	:= http://www.mega-nerd.com/SRC
LIBSAMPLERATE_PACKAGE	:= libsamplerate-$(LIBSAMPLERATE_VERSION).tar.gz
LIBSAMPLERATE_SRC_DIR	:= $(embtk_pkgb)/libsamplerate-$(LIBSAMPLERATE_VERSION)
LIBSAMPLERATE_BUILD_DIR	:= $(embtk_pkgb)/libsamplerate-$(LIBSAMPLERATE_VERSION)

LIBSAMPLERATE_BINS		:= sndfile-resample
LIBSAMPLERATE_INCLUDES		:= samplerate.h
LIBSAMPLERATE_LIBS		:= libsamplerate.*
LIBSAMPLERATE_PKGCONFIGS	:= samplerate.pc
LIBSAMPLERATE_SHARE		:= doc/libsamplerate0-dev

LIBSAMPLERATE_CONFIGURE_OPTS := --program-transform-name='s;$(STRICT_GNU_TARGET)-;;'

LIBSAMPLERATE_DEPS	:= $(if $(CONFIG_EMBTK_HAVE_FFTW),fftw_install)
LIBSAMPLERATE_DEPS	+= $(if $(CONFIG_EMBTK_HAVE_LIBSNDFILE),libsndfile_install)
