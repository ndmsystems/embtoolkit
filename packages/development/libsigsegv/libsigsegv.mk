################################################################################
# Embtoolkit
# Copyright(C) 2011 Abdoulaye Walsimou GAYE.
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
# \file         libsigsegv.mk
# \brief	libsigsegv.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2011
################################################################################

LIBSIGSEGV_NAME		:= libsigsegv
LIBSIGSEGV_VERSION	:= $(call EMBTK_GET_PKG_VERSION,LIBSIGSEGV)
LIBSIGSEGV_SITE		:= ftp://ftp.gnu.org/pub/gnu/libsigsegv
LIBSIGSEGV_SITE_MIRROR3	:= http://ftp.gnu.org/gnu/libsigsegv
LIBSIGSEGV_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
LIBSIGSEGV_PATCH_SITE	:= ftp://ftp.embtoolkit.org/embtoolkit.org/libsigsegv/$(LIBSIGSEGV_VERSION)
LIBSIGSEGV_PACKAGE	:= libsigsegv-$(LIBSIGSEGV_VERSION).tar.gz
LIBSIGSEGV_SRC_DIR	:= $(PACKAGES_BUILD)/libsigsegv-$(LIBSIGSEGV_VERSION)
LIBSIGSEGV_BUILD_DIR	:= $(PACKAGES_BUILD)/libsigsegv-$(LIBSIGSEGV_VERSION)

LIBSIGSEGV_BINS =
LIBSIGSEGV_SBINS =
LIBSIGSEGV_INCLUDES = sigsegv.h
LIBSIGSEGV_LIBS = libsigsegv.*
LIBSIGSEGV_LIBEXECS =
LIBSIGSEGV_PKGCONFIGS =

LIBSIGSEGV_CONFIGURE_ENV :=
LIBSIGSEGV_CONFIGURE_OPTS :=

LIBSIGSEGV_DEPS :=

libsigsegv_install:
	$(call EMBTK_INSTALL_PKG,LIBSIGSEGV)

download_libsigsegv:
	$(call EMBTK_DOWNLOAD_PKG,LIBSIGSEGV)

libsigsegv_clean:
	$(call EMBTK_CLEANUP_PKG,LIBSIGSEGV)
