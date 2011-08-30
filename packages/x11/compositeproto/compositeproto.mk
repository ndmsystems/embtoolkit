################################################################################
# Embtoolkit
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
# \file         compositeproto.mk
# \brief	compositeproto.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@wembtoolkit.org>
# \date         March 2010
################################################################################

COMPOSITEPROTO_NAME		:= compositeproto
COMPOSITEPROTO_VERSION		:= $(call embtk_get_pkgversion,compositeproto)
COMPOSITEPROTO_SITE		:= http://ftp.x.org/pub/individual/proto
COMPOSITEPROTO_PACKAGE		:= compositeproto-$(COMPOSITEPROTO_VERSION).tar.bz2
COMPOSITEPROTO_SRC_DIR		:= $(PACKAGES_BUILD)/compositeproto-$(COMPOSITEPROTO_VERSION)
COMPOSITEPROTO_BUILD_DIR	:= $(PACKAGES_BUILD)/compositeproto-$(COMPOSITEPROTO_VERSION)

COMPOSITEPROTO_BINS		=
COMPOSITEPROTO_SBINS		=
COMPOSITEPROTO_INCLUDES		= X11/extensions/compositeproto.h \
				X11/extensions/composite.h
COMPOSITEPROTO_LIBS 		=
COMPOSITEPROTO_PKGCONFIGS	= compositeproto.pc
