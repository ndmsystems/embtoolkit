################################################################################
# Embtoolkit
# Copyright(C) 2009-2011 Abdoulaye Walsimou GAYE.
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
# \file         gettext.mk
# \brief	gettext.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

GETTEXT_HOST_NAME	:= gettext
GETTEXT_HOST_VERSION	:= $(call embtk_pkg_version,gettext_host)
GETTEXT_HOST_SITE	:= http://ftp.gnu.org/pub/gnu/gettext
GETTEXT_HOST_PACKAGE	:= gettext-$(GETTEXT_HOST_VERSION).tar.gz
GETTEXT_HOST_SRC_DIR	:= $(embtk_toolsb)/gettext-$(GETTEXT_HOST_VERSION)
GETTEXT_HOST_BUILD_DIR	:= $(embtk_toolsb)/gettext-$(GETTEXT_HOST_VERSION)-build

GETTEXT_HOST_CONFIGURE_OPTS := --disable-java
GETTEXT_HOST_CONFIGURE_OPTS += --disable-native-java
GETTEXT_HOST_CONFIGURE_OPTS += --disable-openmp
GETTEXT_HOST_CONFIGURE_OPTS += --with-included-gettext
GETTEXT_HOST_CONFIGURE_OPTS += --with-included-glib
GETTEXT_HOST_CONFIGURE_OPTS += --with-included-libcroco
GETTEXT_HOST_CONFIGURE_OPTS += --with-included-libxml
GETTEXT_HOST_CONFIGURE_OPTS += --enable-static --disable-shared
