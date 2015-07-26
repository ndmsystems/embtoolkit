################################################################################
# Embtoolkit
# Copyright(C) 2012-2014 Abdoulaye Walsimou GAYE.
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
# \file         net.mk
# \brief	net.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2012
################################################################################

embtk_pkgincdir := packages/net

# fcgi
$(call embtk_include_pkg,fcgi)

# Iptables
$(call embtk_include_pkg,iptables)

# LIBNL
$(call embtk_include_pkg,libnl)

# libpcap
$(call embtk_include_pkg,libpcap)

# librsync
$(call embtk_include_pkg,librsync)

# libtirpc
$(call embtk_include_pkg,libtirpc)

# tcpdump
$(call embtk_include_pkg,tcpdump)

# radvd
$(call embtk_include_pkg,radvd)

# dnsmasq
$(call embtk_include_pkg,dnsmasq)

# odhcp6c
$(call embtk_include_pkg,odhcp6c)
