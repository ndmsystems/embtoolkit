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
# \file         lrdf.mk
# \brief        lrdf.mk of Embtoolkit
# \author       Ricardo Crudo <ricardo.crudo@gmail.com>
# \date         Jun 2014
################################################################################

LRDF_NAME		:= lrdf
LRDF_VERSION		:= $(call embtk_get_pkgversion,lrdf)
LRDF_SITE		:= http://sourceforge.net/projects/lrdf/files/liblrdf/$(LRDF_VERSION)
LRDF_PACKAGE		:= liblrdf-$(LRDF_VERSION).tar.gz
LRDF_SRC_DIR		:= $(embtk_pkgb)/liblrdf-$(LRDF_VERSION)
LRDF_BUILD_DIR		:= $(embtk_pkgb)/liblrdf-$(LRDF_VERSION)

LRDF_INCLUDES		:= lrdf*
LRDF_LIBS		:= liblrdf*
LRDF_PKGCONFIGS		:= lrdf.pc
LRDF_SHARES		:= ladspa/rdf/ladspa.rdfs

LRDF_DEPS		:= ladspa_install raptor_install

define embtk_beforeinstall_lrdf
	$(call __embtk_fixgconfigsfor_pkg,lrdf)
endef
