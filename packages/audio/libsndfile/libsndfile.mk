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
# \file         libsndfile.mk
# \brief        libsndfile.mk of Embtoolkit.
# \author       Ricardo Crudo <ricardo.crudo@gmail.com>
# \date         May 2014
################################################################################

LIBSNDFILE_NAME		:= libsndfile
LIBSNDFILE_VERSION	:= $(call embtk_get_pkgversion,libsndfile)
LIBSNDFILE_SITE		:= http://www.mega-nerd.com/libsndfile/files
LIBSNDFILE_PACKAGE	:= libsndfile-$(LIBSNDFILE_VERSION).tar.gz
LIBSNDFILE_SRC_DIR	:= $(embtk_pkgb)/libsndfile-$(LIBSNDFILE_VERSION)
LIBSNDFILE_BUILD_DIR	:= $(embtk_pkgb)/libsndfile-$(LIBSNDFILE_VERSION)

LIBSNDFILE_BINS		:= sndfile-cmp sndfile-concat sndfile-convert
LIBSNDFILE_BINS		+= sndfile-deinterleave sndfile-info sndfile-interleave
LIBSNDFILE_BINS		+= sndfile-metadata-get sndfile-metadata-set
LIBSNDFILE_BINS		+= sndfile-play sndfile-regtest sndfile-salvage
LIBSNDFILE_INCLUDES	:= sndfile.h sndfile.hh
LIBSNDFILE_LIBS		:= libsndfile.*
LIBSNDFILE_PKGCONFIGS	:= sndfile.pc

LIBSNDFILE_CONFIGURE_OPTS := --program-transform-name='s;$(STRICT_GNU_TARGET)-;;'
