################################################################################
# Abdoulaye Walsimou GAYE, <awg@embtoolkit.org>
# Copyright(C) 2010-2011 Abdoulaye Walsimou GAYE.
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
# \file         recordproto.mk
# \brief	recordproto.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE, <awg@embtoolkit.org>
# \date         June 2010
################################################################################

RECORDPROTO_NAME	:= recordproto
RECORDPROTO_VERSION	:= $(call embtk_get_pkgversion,recordproto)
RECORDPROTO_SITE	:= http://ftp.x.org/pub/individual/proto
RECORDPROTO_PACKAGE	:= recordproto-$(RECORDPROTO_VERSION).tar.bz2
RECORDPROTO_SRC_DIR	:= $(embtk_pkgb)/recordproto-$(RECORDPROTO_VERSION)
RECORDPROTO_BUILD_DIR	:= $(embtk_pkgb)/recordproto-$(RECORDPROTO_VERSION)

RECORDPROTO_BINS	=
RECORDPROTO_SBINS	=
RECORDPROTO_INCLUDES	= X11/extensions/recordconst.h				\
			X11/extensions/recordproto.h X11/extensions/recordstr.h
RECORDPROTO_LIBS	=
RECORDPROTO_PKGCONFIGS	= recordproto.pc

