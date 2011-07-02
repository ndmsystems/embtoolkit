################################################################################
# Embtoolkit
# Copyright(C) 2010-2011 Abdoulaye Walsimou GAYE.
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
# \file         expat.mk
# \brief	expat.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         July 2010
################################################################################

EXPAT_NAME := expat
EXPAT_VERSION := $(call embtk_get_pkgversion,EXPAT)
EXPAT_SITE := http://downloads.sourceforge.net/expat
EXPAT_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
EXPAT_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/expat/$(EXPAT_VERSION)
EXPAT_PACKAGE := expat-$(EXPAT_VERSION).tar.gz
EXPAT_SRC_DIR := $(PACKAGES_BUILD)/expat-$(EXPAT_VERSION)
EXPAT_BUILD_DIR := $(PACKAGES_BUILD)/expat-$(EXPAT_VERSION)

EXPAT_BINS = xmlwf
EXPAT_SBINS =
EXPAT_INCLUDES = expat_external.h expat.h
EXPAT_LIBS = libexpat.*
EXPAT_PKGCONFIGS =

EXPAT_DEPS =

expat_install:
	$(call embtk_install_pkg,EXPAT)

download_expat:
	$(call embtk_download_pkg,EXPAT)

expat_clean:
	$(call embtk_cleanup_pkg,EXPAT)
