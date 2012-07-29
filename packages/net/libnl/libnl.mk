################################################################################
# Embtoolkit
# Copyright(C) 2012 Abdoulaye Walsimou GAYE.
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
# \file         libnl.mk
# \brief	libnl.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         June 2012
################################################################################

LIBNL_NAME		:= libnl
LIBNL_VERSION		:= $(call embtk_get_pkgversion,libnl)
LIBNL_SITE		:= http://www.infradead.org/~tgr/libnl/files
LIBNL_PACKAGE		:= libnl-$(LIBNL_VERSION).tar.gz
LIBNL_SRC_DIR		:= $(PACKAGES_BUILD)/libnl-$(LIBNL_VERSION)
LIBNL_BUILD_DIR		:= $(PACKAGES_BUILD)/libnl-$(LIBNL_VERSION)

LIBNL_SBINS		:= genl-ctrl-list nl-class-add nl-class-delete
LIBNL_SBINS		+= nl-classid-lookup  nl-class-list  nl-cls-add
LIBNL_SBINS		+= nl-cls-delete  nl-cls-list  nl-link-list
LIBNL_SBINS		+= nl-pktloc-lookup  nl-qdisc-add  nl-qdisc-delete
LIBNL_SBINS		:= nl-qdisc-list
LIBNL_INCLUDES		:= libnl3
LIBNL_LIBS		:= libnl*
LIBNL_PKGCONFIGS	:= libnl*
LIBNL_ETC		:= libnl
__LIBNL_SHARES		:= genl-ctrl-list.8 nl-classid-lookup.8
__LIBNL_SHARES		+= nl-pktloc-lookup.8 nl-qdisc-add.8 nl-qdisc-delete.8
__LIBNL_SHARES		+= nl-qdisc-list.8
LIBNL_SHARES		:= $(addprefix man/man8/,$(__LIBNL_SHARES))

define embtk_postinstall_libnl
	test -e $(LIBNL_BUILD_DIR)/.installed ||				\
		$(call __embtk_fix_libtool_files,$(LIBDIR)/libln)
endef
