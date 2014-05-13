################################################################################
# Embtoolkit
# Copyright(C) 2009-2012 Abdoulaye Walsimou GAYE.
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
# \file         foo.mk
# \brief	foo.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

FOO_NAME		:= foo
FOO_VERSION		:= $(call embtk_get_pkgversion,foo)
FOO_SITE		:= http://www.foo.org/download
FOO_PACKAGE		:= foo-$(FOO_VERSION).tar.gz
FOO_SRC_DIR		:= $(embtk_pkgb)/foo-$(FOO_VERSION)
FOO_BUILD_DIR		:= $(embtk_pkgb)/foo-$(FOO_VERSION)

FOO_BINS		:=
FOO_SBINS		:=
FOO_ETC			:=
FOO_INCLUDES		:=
FOO_LIBS		:=
FOO_LIBEXECS		:=
FOO_PKGCONFIGS		:=
FOO_SHARES		:=
FOO_CFLAGS		:=
FOO_CPPFLAGS		:=
FOO_CXXFLAGS		:=
FOO_SET_RPATH		:= # Only for host packages

FOO_CONFIGURE_ENV	:=
FOO_CONFIGURE_OPTS	:=
FOO_MAKE_ENV		:=
FOO_MAKE_OPTS		:=
FOO_MAKE_DIRS		:=

FOO_DEPS		:=

#
# if not empty, force build system to not remove this package workspace after
# successful build even if it is globally configured to do so.
#
FOO_KEEP_SRC_DIR	:=
