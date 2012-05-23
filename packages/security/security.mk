################################################################################
# Embtoolkit
# Copyright(C) 2010-2012 Abdoulaye Walsimou GAYE.
#
# This program is free software; you can distribute it and/or modify it
# under the terms of the GNU General Public License
# (Version 2 or later) published by the Free Software Foundation.
#
# This program is distributed in the hope it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
################################################################################
#
# \file         security.mk
# \brief	security.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         February 2010
################################################################################

# Iptables
include $(EMBTK_ROOT)/packages/security/iptables/iptables.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_IPTABLES) += iptables_install

# OpenSSL
include $(EMBTK_ROOT)/packages/security/openssl/openssl.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_OPENSSL) += openssl_install
