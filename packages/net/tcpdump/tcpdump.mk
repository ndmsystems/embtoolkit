################################################################################
# Embtoolkit
# Copyright(C) 2012-2015 Abdoulaye Walsimou GAYE.
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
# \file         tcpdump.mk
# \brief	tcpdump.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2012
################################################################################

TCPDUMP_NAME      := tcpdump
TCPDUMP_VERSION   := $(call embtk_pkg_version,tcpdump)
TCPDUMP_SITE      := http://www.tcpdump.org/release
TCPDUMP_PACKAGE   := tcpdump-$(TCPDUMP_VERSION).tar.gz
TCPDUMP_SRC_DIR   := $(embtk_pkgb)/tcpdump-$(TCPDUMP_VERSION)
TCPDUMP_BUILD_DIR := $(embtk_pkgb)/tcpdump-$(TCPDUMP_VERSION)-build

TCPDUMP_SBINS := tcpdump*

TCPDUMP_CONFIGURE_ENV := ac_cv_linux_vers=2
TCPDUMP_CONFIGURE_ENV += td_cv_buggygetaddrinfo=no

TCPDUMP_CONFIGURE_OPTS := --without-smi --without-crypto --disable-ipv6

TCPDUMP_DEPS := libpcap_install
