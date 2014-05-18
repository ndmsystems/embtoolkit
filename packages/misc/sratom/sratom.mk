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
# \file     sratom.mk
# \brief    sratom.mk of Embtoolkit.
# \author   Ricardo Crudo <ricardo.crudo@gmail.com>
# \date     May 2014
################################################################################

SRATOM_NAME		:= sratom
SRATOM_VERSION		:= $(call embtk_get_pkgversion,sratom)
SRATOM_SITE		:= http://download.drobilla.net
SRATOM_PACKAGE		:= sratom-$(SRATOM_VERSION).tar.bz2
SRATOM_SRC_DIR		:= $(embtk_pkgb)/sratom-$(SRATOM_VERSION)
SRATOM_BUILD_DIR	:= $(embtk_pkgb)/sratom-$(SRATOM_VERSION)

SRATOM_DEPS		:= lv2_install serd_install sord_install
SRATOM_INCLUDES		:= sratom-0
SRATOM_LIBS		:= libsratom*
SRATOM_PKGCONFIGS	:= sratom-0.pc

# FIXME: uses python2 to execute the waf due a bug with waflib and python 3.4.0
define embtk_beforeinstall_sratom
	cp $(SRATOM_SRC_DIR)/waf $(SRATOM_SRC_DIR)/waf.bak
	sed -e 's;env[[:space:]]python$$;env python2;'				\
		< $(SRATOM_SRC_DIR)/waf > $(SRATOM_SRC_DIR)/waf.new
	mv $(SRATOM_SRC_DIR)/waf.new $(SRATOM_SRC_DIR)/waf
	chmod +x $(SRATOM_SRC_DIR)/waf
endef
