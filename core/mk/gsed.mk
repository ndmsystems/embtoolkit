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
# \file         gsed.mk
# \brief	gsed.mk of Embtoolkit.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2013
################################################################################

GSED_NAME	:= gsed
GSED_VERSION	:= $(call embtk_get_pkgversion,gsed)
GSED_SITE	:= http://ftp.gnu.org/gnu/sed
GSED_PACKAGE	:= sed-$(GSED_VERSION).tar.bz2
GSED_SRC_DIR	:= $(embtk_toolsb)/sed-$(GSED_VERSION)
GSED_BUILD_DIR	:= $(embtk_toolsb)/sed-$(GSED_VERSION)

define embtk_install_gsed
	$(call __embtk_install_hostpkg,gsed)
endef
