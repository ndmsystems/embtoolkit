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
# \file         raptor.mk
# \brief        raptor.mk of Embtoolkit
# \author       Ricardo Crudo <ricardo.crudo@gmail.com>
# \date         Jun 2014
################################################################################

RAPTOR_NAME		:= raptor
RAPTOR_VERSION		:= $(call embtk_get_pkgversion,raptor)
RAPTOR_SITE		:= http://download.librdf.org/source
RAPTOR_PACKAGE		:= raptor-$(RAPTOR_VERSION).tar.gz
RAPTOR_SRC_DIR		:= $(embtk_pkgb)/raptor-$(RAPTOR_VERSION)
RAPTOR_BUILD_DIR	:= $(embtk_pkgb)/raptor-$(RAPTOR_VERSION)

RAPTOR_BINS		:= rapper raptor-config
RAPTOR_INCLUDES		:= raptor.h
RAPTOR_LIBS		:= libraptor*
RAPTOR_PKGCONFIGS	:= raptor.pc
RAPTOR_SHARES		:= man/man1/rapper.1
RAPTOR_SHARES		+= man/man1/raptor-config.1
RAPTOR_SHARES		+= man/man3/libraptor.3 gtk-doc/html/raptor

RAPTOR_DEPS		:= libxml2_install
RAPTOR_CONFIGURE_OPTS	:= --with-xml2-config=$(embtk_sysroot)/usr/bin/xml2-config

#
# FIXME: should be fixed upstream - curl/types.h was removed from curl
#
define embtk_beforeinstall_raptor
	for f in $$(grep -Rl '<curl/types.h>' $(RAPTOR_SRC_DIR)); do \
		sed -e '/<curl\/types\.h>/d' < $$f > $$f.tmp; \
		mv $$f.tmp $$f; \
	done
endef
