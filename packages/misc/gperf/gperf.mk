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
GPERF_VERSION		:= $(call embtk_get_pkgversion,GPERF)
GPERF_SITE		:= http://ftp.gnu.org/gnu/gperf
GPERF_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
GPERF_PATCH_SITE	:= ftp://ftp.embtoolkit.org/embtoolkit.org/gperf/$(GPERF_VERSION)
GPERF_PACKAGE		:= gperf-$(GPERF_VERSION).tar.gz
GPERF_SRC_DIR		:= $(PACKAGES_BUILD)/gperf-$(GPERF_VERSION)
GPERF_BUILD_DIR		:= $(PACKAGES_BUILD)/gperf-$(GPERF_VERSION)

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

gperf_install:
	$(call embtk_install_pkg,GPERF)

gperf_clean:
	$(call embtk_cleanup_pkg,GPERF)

#
# gperf for for host
#
GPERF_HOST_NAME		:= $(GPERF_NAME)
GPERF_HOST_VERSION	:= $(GPERF_VERSION)
GPERF_HOST_SITE		:= $(GPERF_SITE)
GPERF_HOST_SITE_MIRROR1	:= $(GPERF_SITE_MIRROR1)
GPERF_HOST_SITE_MIRROR2	:= $(GPERF_SITE_MIRROR2)
GPERF_HOST_SITE_MIRROR3	:= $(GPERF_SITE_MIRROR3)
GPERF_HOST_PATCH_SITE	:= $(GPERF_PATCH_SITE)
GPERF_HOST_PACKAGE	:= $(GPERF_PACKAGE)
GPERF_HOST_SRC_DIR	:= $(TOOLS_BUILD)/gperf-$(GPERF_VERSION)
GPERF_HOST_BUILD_DIR	:= $(TOOLS_BUILD)/gperf-$(GPERF_VERSION)

#
# common targets
#
gperf_host_install:
	$(call embtk_install_hostpkg,GPERF_HOST)

download_gperf download_gperf_host:
	$(call embtk_download_pkg,GPERF)
