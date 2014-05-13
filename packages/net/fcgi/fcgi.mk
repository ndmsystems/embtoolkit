################################################################################
# Embtoolkit
# Copyright(C) 2013 Abdoulaye Walsimou GAYE.
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
# \file         fcgi.mk
# \brief	fcgi.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         October 2013
################################################################################

FCGI_NAME	:= fcgi
FCGI_VERSION	:= $(call embtk_get_pkgversion,fcgi)
FCGI_SITE	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
FCGI_PACKAGE	:= fcgi-$(FCGI_VERSION).tar.bz2
FCGI_SRC_DIR	:= $(embtk_pkgb)/fcgi-$(FCGI_VERSION)
FCGI_BUILD_DIR	:= $(embtk_pkgb)/fcgi-$(FCGI_VERSION)

FCGI_INCLUDES	:= fastcgi.h fcgiapp.h fcgi_config.h fcgimisc.h fcgio.h
FCGI_INCLUDES	+= fcgios.h fcgi_stdio.h
FCGI_LIBS	:= libfcgi.*

FCGI_CFLAGS	:= -fno-strict-aliasing
FCGI_CXXFLAGS	:= $(FCGI_CFLAGS)
