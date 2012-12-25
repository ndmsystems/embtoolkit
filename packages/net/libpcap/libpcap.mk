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
# \file         libpcap.mk
# \brief	libpcap.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2012
################################################################################

LIBPCAP_NAME		:= libpcap
LIBPCAP_VERSION		:= $(call embtk_get_pkgversion,libpcap)
LIBPCAP_SITE		:= http://www.tcpdump.org/release
LIBPCAP_PACKAGE		:= libpcap-$(LIBPCAP_VERSION).tar.gz
LIBPCAP_SRC_DIR		:= $(embtk_pkgb)/libpcap-$(LIBPCAP_VERSION)
LIBPCAP_BUILD_DIR	:= $(embtk_pkgb)/libpcap-$(LIBPCAP_VERSION)

LIBPCAP_BINS		:= pcap-config
LIBPCAP_INCLUDES	:= pcap*
LIBPCAP_LIBS		:= libpcap*

LIBPCAP_CONFIGURE_OPTS	:= --with-pcap=linux
