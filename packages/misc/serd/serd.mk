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
# \file		serd.mk
# \brief	serd.mk of Embtoolkit.
# \author	Ricardo Crudo <ricardo.crudo@gmail.com>
# \date		May 2014
################################################################################

SERD_NAME	:= serd
SERD_VERSION	:= $(call embtk_get_pkgversion,serd)
SERD_SITE	:= http://download.drobilla.net
SERD_PACKAGE	:= serd-$(SERD_VERSION).tar.bz2
SERD_SRC_DIR	:= $(embtk_pkgb)/serd-$(SERD_VERSION)
SERD_BUILD_DIR	:= $(embtk_pkgb)/serd-$(SERD_VERSION)

SERD_BINS	:= serdi
SERD_INCLUDES	:= serd-0
SERD_LIBS	:= libserd*
SERD_PKGCONFIGS := serd-0.pc
SERD_SHARES	:= man/*/serdi*

# FIXME: uses python2 to execute the waf due a bug with waflib and python 3.4.0
define embtk_beforeinstall_serd
	cp $(SERD_SRC_DIR)/waf $(SERD_SRC_DIR)/waf.bak
	sed -e 's;env[[:space:]]python$$;env python2;'				\
		< $(SERD_SRC_DIR)/waf > $(SERD_SRC_DIR)/waf.new
	mv $(SERD_SRC_DIR)/waf.new $(SERD_SRC_DIR)/waf
	chmod +x $(SERD_SRC_DIR)/waf
endef
