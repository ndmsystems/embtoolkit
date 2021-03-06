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
# \file         gperf.mk
# \brief	gperf.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         June 2011
################################################################################

GPERF_NAME		:= gperf
GPERF_VERSION		:= $(call embtk_get_pkgversion,gperf)
GPERF_SITE		:= http://ftp.gnu.org/gnu/gperf
GPERF_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
GPERF_PACKAGE		:= gperf-$(GPERF_VERSION).tar.gz
GPERF_SRC_DIR		:= $(embtk_pkgb)/gperf-$(GPERF_VERSION)
GPERF_BUILD_DIR		:= $(embtk_pkgb)/gperf-$(GPERF_VERSION)

#
# gperf for target
#
GPERF_BINS		:=
GPERF_SBINS		:=
GPERF_INCLUDES		:=
GPERF_LIBS		:=
GPERF_LIBEXECS		:=
GPERF_PKGCONFIGS	:=

GPERF_CONFIGURE_ENV	:=
GPERF_CONFIGURE_OPTS	:=

GPERF_DEPS :=
