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
# \file     lilv.mk
# \brief    lilv.mk of Embtoolkit.
# \author   Ricardo Crudo <ricardo.crudo@gmail.com>
# \date     May 2014
################################################################################

LILV_NAME	:= lilv
LILV_VERSION	:= $(call embtk_get_pkgversion,lilv)
LILV_SITE	:= http://download.drobilla.net
LILV_PACKAGE	:= lilv-$(LILV_VERSION).tar.bz2
LILV_SRC_DIR	:= $(embtk_pkgb)/lilv-$(LILV_VERSION)
LILV_BUILD_DIR  := $(embtk_pkgb)/lilv-$(LILV_VERSION)

LILV_DEPS	:= lv2_install serd_install sord_install sratom_install

LILV_BINS	:= lv2* lilv-bench
LILV_INCLUDES	:= lilv-0
LILV_LIBS	:= liblilv*
LILV_PKGCONFIGS	:= lilv-0.pc

LILV_CONFIGURE_OPTS := --default-lv2-path=~/.lv2

# FIXME: uses python2 to execute the waf due a bug with waflib and python 3.4.0
define embtk_beforeinstall_lilv
	cp $(LILV_SRC_DIR)/waf $(LILV_SRC_DIR)/waf.bak
	sed -e 's;env[[:space:]]python;env python2;'				\
		< $(LILV_SRC_DIR)/waf > $(LILV_SRC_DIR)/waf.new
	mv $(LILV_SRC_DIR)/waf.new $(LILV_SRC_DIR)/waf
	chmod +x $(LILV_SRC_DIR)/waf
endef
