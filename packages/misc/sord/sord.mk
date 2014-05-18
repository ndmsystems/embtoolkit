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
# \file     sord.mk
# \brief    sord.mk of Embtoolkit.
# \author   Ricardo Crudo <ricardo.crudo@gmail.com>
# \date     May 2014
################################################################################

SORD_NAME	:= sord
SORD_VERSION	:= $(call embtk_get_pkgversion,sord)
SORD_SITE	:= http://download.drobilla.net
SORD_PACKAGE	:= sord-$(SORD_VERSION).tar.bz2
SORD_SRC_DIR	:= $(embtk_pkgb)/sord-$(SORD_VERSION)
SORD_BUILD_DIR  := $(embtk_pkgb)/sord-$(SORD_VERSION)

SORD_DEPS	:= serd_install
SORD_BINS	:= sord_validate sordi
SORD_INCLUDES	:= sord-0
SORD_LIBS	:= libsord*
SORD_PKGCONFIGS := sord-0.pc
SORD_SHARES	:= man/*/sord*

# uses python2 to execute the waf due a bug with waflib and python 3.4.0
define embtk_beforeinstall_sord
	cp $(SORD_SRC_DIR)/waf $(SORD_SRC_DIR)/waf.bak
	sed -e 's;env[[:space:]]python$$;env python2;'				\
		< $(SORD_SRC_DIR)/waf > $(SORD_SRC_DIR)/waf.new
	mv $(SORD_SRC_DIR)/waf.new $(SORD_SRC_DIR)/waf
	chmod +x $(SORD_SRC_DIR)/waf
endef
