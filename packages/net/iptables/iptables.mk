################################################################################
# Embtoolkit
# Copyright(C) 2012 Averell KINOUANI <a.kinouani@voila.fr>
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
# \file         iptables.mk
# \brief	iptables.mk of Embtoolkit
# \author       Averell KINOUANI <a.kinouani@voila.fr>
# \date         May 2012
################################################################################

IPTABLES_NAME		:= iptables
IPTABLES_VERSION	:= $(call embtk_get_pkgversion,iptables)
IPTABLES_SITE		:= ftp://ftp.netfilter.org/pub/iptables
IPTABLES_PACKAGE	:= iptables-$(IPTABLES_VERSION).tar.bz2
IPTABLES_SRC_DIR	:= $(embtk_pkgb)/iptables-$(IPTABLES_VERSION)
IPTABLES_BUILD_DIR	:= $(embtk_pkgb)/iptables-$(IPTABLES_VERSION)

IPTABLES_SBINS		:= iptables ip6tables ip6tables-restore ip6tables-save
IPTABLES_SBINS		+= iptables-restore iptables-save
IPTABLES_INCLUDES	:= ipt_kernel_headers.h libip6tc.h libiptc.h
IPTABLES_INCLUDES	+= libxtc.h xtables.h xtcshared.h
IPTABLES_LIBS		:= libip4tc.so.0 libip4tc.so.0 libxtables.so.7

ifeq ($(CONFIG_EMBTK_IPTABLES_HAVE_LIBIPQ),y)
IPTABLES_CONFIGURE_OPTS	:= --enable-libipq
endif
