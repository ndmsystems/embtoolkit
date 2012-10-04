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
# \file         xf86inputevdev.mk
# \brief	xf86inputevdev.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         July 2010
################################################################################

XF86INPUTEVDEV_NAME		:= xf86-input-evdev
XF86INPUTEVDEV_VERSION		:= $(call embtk_get_pkgversion,xf86inputevdev)
XF86INPUTEVDEV_SITE		:= http://xorg.freedesktop.org/archive/individual/driver
XF86INPUTEVDEV_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
XF86INPUTEVDEV_PACKAGE		:= xf86-input-evdev-$(XF86INPUTEVDEV_VERSION).tar.bz2
XF86INPUTEVDEV_SRC_DIR		:= $(embtk_pkgb)/xf86-input-evdev-$(XF86INPUTEVDEV_VERSION)
XF86INPUTEVDEV_BUILD_DIR	:= $(embtk_pkgb)/xf86-input-evdev-$(XF86INPUTEVDEV_VERSION)

XF86INPUTEVDEV_BINS		=
XF86INPUTEVDEV_SBINS		=
XF86INPUTEVDEV_INCLUDES		= xorg/evdev-properties.h
XF86INPUTEVDEV_LIBS		= xorg/modules/input/evdev_drv.*
XF86INPUTEVDEV_PKGCONFIGS	= xorg-evdev.pc

XF86INPUTEVDEV_DEPS		= xserver_install

define embtk_postinstall_xf86inputevdev
	$(Q)-cp -R $(embtk_sysroot)/usr/$(LIBDIR)/xorg $(embtk_rootfs)/usr/$(LIBDIR)/
endef
