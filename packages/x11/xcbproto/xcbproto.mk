################################################################################
# Embtoolkit
# Copyright(C) 2010-2011 Abdoulaye Walsimou GAYE.
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
# \file         xcbproto.mk
# \brief	xcbproto.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

XCBPROTO_NAME		:= xcb-proto
XCBPROTO_VERSION	:= $(call embtk_get_pkgversion,xcbproto)
XCBPROTO_SITE		:= http://xcb.freedesktop.org/dist
XCBPROTO_PACKAGE	:= xcb-proto-$(XCBPROTO_VERSION).tar.gz
XCBPROTO_SRC_DIR	:= $(PACKAGES_BUILD)/xcb-proto-$(XCBPROTO_VERSION)
XCBPROTO_BUILD_DIR	:= $(PACKAGES_BUILD)/xcb-proto-$(XCBPROTO_VERSION)

XCBPROTO_BINS =
XCBPROTO_SBINS =
XCBPROTO_INCLUDES =
XCBPROTO_LIBS = python2.6/dist-packages/xcbgen
XCBPROTO_PKGCONFIGS = xcb-proto.pc

