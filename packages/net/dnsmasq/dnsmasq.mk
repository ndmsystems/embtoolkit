################################################################################
# Embtoolkit
# Copyright(C) 2012 Averell KINOUANI.
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
# \file         dnsmasq.mk
# \brief	dnsmasq.mk of Embtoolkit
# \author       Averell KINOUANI <averell.kinouani@embtoolkit.org>
# \date         February 2015
################################################################################

DNSMASQ_NAME		:= dnsmasq
DNSMASQ_VERSION		:= $(call embtk_get_pkgversion,dnsmasq)
DNSMASQ_SITE		:= http://www.thekelleys.org.uk/dnsmasq/
DNSMASQ_PACKAGE		:= dnsmasq-$(DNSMASQ_VERSION).tar.xz
DNSMASQ_SRC_DIR		:= $(embtk_pkgb)/dnsmasq-$(DNSMASQ_VERSION)
DNSMASQ_BUILD_DIR	:= $(embtk_pkgb)/dnsmasq-$(DNSMASQ_VERSION)


__embtk_dnsmasq_cflags	:= $(TARGET_CFLAGS)

DNSMASQ_MAKE_ENV	:= LDFLAGS="-L$(embtk_sysroot)/lib -L$(embtk_sysroot)/usr/lib"
DNSMASQ_MAKE_ENV	+= CPPFLAGS="-I. -I./include -I$(embtk_sysroot)/usr/include"
DNSMASQ_MAKE_ENV	+= CFLAGS="$(__embtk_dnsmasq_cflags)"
DNSMASQ_MAKE_ENV	+= BUILDDIR=$(DNSMASQ_BUILD_DIR)
DNSMASQ_MAKE_ENV	+= PATH=$(PATH):$(embtk_tools)/bin

DNSMASQ_MAKE_OPTS      	:= CC=$(TARGETCC_CACHED)
DNSMASQ_MAKE_OPTS	+= PREFIX=/usr

define embtk_install_dnsmasq
	$(call embtk_makeinstall_pkg, dnsmasq)
endef

DNSMASQ_SBINS		:= dnsmasq

