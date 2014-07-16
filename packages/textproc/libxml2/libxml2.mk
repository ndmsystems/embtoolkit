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
# \file         libxml.mk
# \brief	libxml.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

LIBXML2_NAME		:= libxml2
LIBXML2_VERSION		:= $(call embtk_get_pkgversion,libxml2)
LIBXML2_SITE		:= ftp://xmlsoft.org/libxml2
LIBXML2_PACKAGE		:= libxml2-$(LIBXML2_VERSION).tar.gz
LIBXML2_SRC_DIR		:= $(embtk_pkgb)/libxml2-$(LIBXML2_VERSION)
LIBXML2_BUILD_DIR	:= $(embtk_pkgb)/libxml2-$(LIBXML2_VERSION)

LIBXML2_BINS		:= xml2-config xmlcatalog xmllint
LIBXML2_INCLUDES	:= libxml2
LIBXML2_LIBS		:= libxml2* xml2Conf.sh
LIBXML2_PKGCONFIGS	:= libxml*.pc

LIBXML2_CONFIGURE_OPTS	:= --without-python

# FIXME: this should be fixed from upstream libxml2
pembtk_libxml2conf	:= $(embtk_sysroot)/usr/$(LIBDIR)/xml2Conf.sh
pembtk_xml2config	:= $(embtk_sysroot)/usr/bin/xml2-config
define embtk_postinstallonce_libxml2
	sed -e 's;/usr;$(embtk_sysroot)/usr;g'					\
		< $(pembtk_libxml2conf) > $(pembtk_libxml2conf).tmp;		\
	mv $(pembtk_libxml2conf).tmp $(pembtk_libxml2conf)
	chmod +x $(pembtk_libxml2conf)
	sed -e 's;=/usr;=$(embtk_sysroot)/usr;g'				\
		< $(pembtk_xml2config) > $(pembtk_xml2config).tmp;		\
	mv $(pembtk_xml2config).tmp $(pembtk_xml2config)
	chmod +x $(pembtk_xml2config)
endef
