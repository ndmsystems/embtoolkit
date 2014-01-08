################################################################################
# Embtoolkit
# Copyright(C) 2013 Abdoulaye Walsimou GAYE.
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
# \file         gmake.mk
# \brief	gmake.mk of Embtoolkit.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2013
################################################################################

GMAKE_NAME	:= gmake
GMAKE_VERSION	:= $(call embtk_get_pkgversion,gmake)
GMAKE_SITE	:= http://ftp.gnu.org/gnu/make
GMAKE_PACKAGE	:= make-$(GMAKE_VERSION).tar.bz2
GMAKE_SRC_DIR	:= $(embtk_toolsb)/make-$(GMAKE_VERSION)
GMAKE_BUILD_DIR	:= $(embtk_toolsb)/make-$(GMAKE_VERSION)

define embtk_install_gmake
	$(call __embtk_install_hostpkg,gmake)
endef

define embtk_postinstall_gmake
	if [ ! -e $(embtk_htools)/usr/bin/gmake ]; then				\
		cd $(embtk_htools)/usr/bin; mv make gmake;			\
	fi
endef
