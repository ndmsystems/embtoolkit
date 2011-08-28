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
# \file         xinput.mk
# \brief	xinput.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         September 2010
################################################################################

XINPUT_NAME		:= xinput
XINPUT_VERSION		:= $(call embtk_get_pkgversion,xinput)
XINPUT_SITE		:= http://xorg.freedesktop.org/archive/individual/app
XINPUT_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
XINPUT_PACKAGE		:= xinput-$(XINPUT_VERSION).tar.bz2
XINPUT_SRC_DIR		:= $(PACKAGES_BUILD)/xinput-$(XINPUT_VERSION)
XINPUT_BUILD_DIR	:= $(PACKAGES_BUILD)/xinput-$(XINPUT_VERSION)

XINPUT_BINS		= xinput
XINPUT_SBINS		=
XINPUT_INCLUDES		=
XINPUT_LIBS		=
XINPUT_PKGCONFIGS	=

XINPUT_DEPS := xproto_install inputproto_install libx11_install \
	libxext_install libxi_install
