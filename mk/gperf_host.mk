################################################################################
# Embtoolkit
# Copyright(C) 2011-2012 Abdoulaye Walsimou GAYE.
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
# \file         gperf_host.mk
# \brief	gperf_host.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         June 2011
################################################################################

GPERF_HOST_NAME		:= gperf
GPERF_HOST_VERSION	:= $(call embtk_get_pkgversion,gperf_host)
GPERF_HOST_SITE		:= http://ftp.gnu.org/gnu/gperf
GPERF_HOST_PACKAGE	:= gperf-$(GPERF_HOST_VERSION).tar.gz
GPERF_HOST_SRC_DIR	:= $(TOOLS_BUILD)/gperf-$(GPERF_HOST_VERSION)
GPERF_HOST_BUILD_DIR	:= $(TOOLS_BUILD)/gperf-$(GPERF_HOST_VERSION)

gperf_host_clean:
	$(embtk_pinfo,"Clean up gperf for host...")
