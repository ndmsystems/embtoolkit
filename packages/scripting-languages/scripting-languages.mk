################################################################################
# GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# Copyright(C) 2010 GAYE Abdoulaye Walsimou. All rights reserved.
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
# \file         scripting-languages.mk
# \brief	scripting-languages.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         February 2010
################################################################################

#microperl
include $(EMBTK_ROOT)/packages/scripting-languages/perl/perl.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_MICROPERL) += microperl_install

