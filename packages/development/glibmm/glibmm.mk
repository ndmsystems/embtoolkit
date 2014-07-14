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
# \file         glibmm.mk
# \brief	glibmm.mk of Embtoolkit
# \author       Ricardo Crudo <ricardo.crudo@gmail.com>
# \date         Jun 2014
################################################################################

GLIBMM_NAME		:= glibmm
GLIBMM_MAJOR_VERSION	:= $(call embtk_get_pkgversion,glibmm_major)
GLIBMM_VERSION		:= $(call embtk_get_pkgversion,glibmm)
GLIBMM_SITE		:= http://ftp.gnome.org/pub/gnome/sources/glibmm/$(GLIBMM_MAJOR_VERSION)
GLIBMM_PACKAGE		:= glibmm-$(GLIBMM_VERSION).tar.bz2
GLIBMM_SRC_DIR		:= $(embtk_pkgb)/glibmm-$(GLIBMM_VERSION)
GLIBMM_BUILD_DIR	:= $(embtk_pkgb)/glibmm-$(GLIBMM_VERSION)

GLIBMM_INCLUDES		:= glibmm-* giomm*
GLIBMM_LIBS		:= glibmm-* libglibmm* libgiomm*
GLIBMM_PKGCONFIGS       := glibmm*.pc giomm*.pc
GLIBMM_SHARE		:= glibmm* doc/glibmm* devhelp/books/glibmm* aclocal/glibmm*

GLIBMM_DEPS		:= glib_install libsigcpp_install
