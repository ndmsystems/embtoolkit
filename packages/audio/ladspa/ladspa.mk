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
# \file         ladspa.mk
# \brief        ladspa.mk of Embtoolkit.
# \author       Ricardo Crudo <ricardo.crudo@gmail.com>
# \date         Jul 2014
################################################################################

LADSPA_NAME		:= ladspa
LADSPA_VERSION		:= $(call embtk_get_pkgversion,ladspa)
LADSPA_SITE		:= http://www.ladspa.org/download
LADSPA_PACKAGE		:= ladspa_sdk_$(LADSPA_VERSION).tgz
LADSPA_SRC_DIR		:= $(embtk_pkgb)/ladspa_sdk
LADSPA_BUILD_DIR	:= $(embtk_pkgb)/ladspa_sdk

LADSPA_INCLUDES	:= ladspa.h

define embtk_install_ladspa
	cp $(LADSPA_BUILD_DIR)/src/ladspa.h $(embtk_sysroot)/usr/include
endef
