################################################################################
# Embtoolkit
# Copyright(C) 2009-2014 Abdoulaye Walsimou GAYE.
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
# \file         gettext-intl.mk
# \brief	gettext-intl.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2014
################################################################################

GETTEXT-INTL_NAME		:= gettext-intl
GETTEXT-INTL_VERSION		:= $(call embtk_get_pkgversion,gettext-intl)
GETTEXT-INTL_SITE		:= http://ftp.gnu.org/pub/gnu/gettext
GETTEXT-INTL_PACKAGE		:= gettext-$(GETTEXT-INTL_VERSION).tar.gz
GETTEXT-INTL_SRC_DIR		:= $(embtk_pkgb)/gettext-$(GETTEXT-INTL_VERSION)
GETTEXT-INTL_BUILD_DIR		:= $(embtk_pkgb)/gettext-intl-$(GETTEXT-INTL_VERSION)

GETTEXT-INTL_INCLUDES		:= libintl.h
GETTEXT-INTL_LIBS		:= libint.*

GETTEXT-INTL_CONFIGURE_OPTS	:= --disable-relocatable
GETTEXT-INTL_CONFIGURE_OPTS	+= --disable-csharp
GETTEXT-INTL_CONFIGURE_OPTS	+= --disable-openmp
GETTEXT-INTL_CONFIGURE_OPTS	+= --disable-native-java
GETTEXT-INTL_CONFIGURE_OPTS	+= --without-emacs
GETTEXT-INTL_CONFIGURE_OPTS	+= --disable-libasprintf

GETTEXT-INTL_MAKE_DIRS		:= intl
GETTEXT-INTL_CONFIGURE_DIR	:= gettext-runtime
