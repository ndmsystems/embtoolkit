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
# \file         bzip2.mk
# \brief        bzip2.mk of Embtoolkit.
# \author       Ricardo Crudo <ricardo.crudo@gmail.com>
# \date         May 2014
################################################################################

BZIP2_NAME	:= bzip2
BZIP2_VERSION	:= $(call embtk_get_pkgversion,bzip2)
BZIP2_SITE	:= http://www.bzip.org/$(BZIP2_VERSION)
BZIP2_PACKAGE	:= bzip2-$(BZIP2_VERSION).tar.gz
BZIP2_SRC_DIR	:= $(embtk_pkgb)/bzip2-$(BZIP2_VERSION)
BZIP2_BUILD_DIR	:= $(embtk_pkgb)/bzip2-$(BZIP2_VERSION)

BZIP2_BINS	:= bzip2 bunzip2 bzcat bzip2recover bz*grep bzmore bzless bzdiff
BZIP2_INCLUDES	:= bzlib.h
BZIP2_LIBS	:= libbz*

BZIP2_MAKE_ENV	:= CC=$(TARGETCC_CACHED) AR=$(TARGETAR) RANLIB=$(TARGETRANLIB)
BZIP2_MAKE_ENV	+= CFLAGS="$(TARGET_CFLAGS)" PREFIX="$(embtk_sysroot)/usr"
BZIP2_MAKE_ENV	+= LIBDIR=$(LIBDIR)

define embtk_install_bzip2
	$(call embtk_makeinstall_pkg,bzip2)
endef

