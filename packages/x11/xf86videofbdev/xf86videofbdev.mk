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
# \file         xf86videofbdev.mk
# \brief	xf86videofbdev.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         July 2010
################################################################################

XF86VIDEOFBDEV_NAME		:= xf86-video-fbdev
XF86VIDEOFBDEV_VERSION		:= $(call embtk_get_pkgversion,xf86videofbdev)
XF86VIDEOFBDEV_SITE		:= http://xorg.freedesktop.org/archive/individual/driver
XF86VIDEOFBDEV_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
XF86VIDEOFBDEV_PACKAGE		:= xf86-video-fbdev-$(XF86VIDEOFBDEV_VERSION).tar.bz2
XF86VIDEOFBDEV_SRC_DIR		:= $(embtk_pkgb)/xf86-video-fbdev-$(XF86VIDEOFBDEV_VERSION)
XF86VIDEOFBDEV_BUILD_DIR	:= $(embtk_pkgb)/xf86-video-fbdev-$(XF86VIDEOFBDEV_VERSION)

XF86VIDEOFBDEV_BINS		=
XF86VIDEOFBDEV_SBINS		=
XF86VIDEOFBDEV_INCLUDES		=
XF86VIDEOFBDEV_LIBS		= xorg/modules/drivers/fbdev_drv.*
XF86VIDEOFBDEV_PKGCONFIGS	=

XF86VIDEOFBDEV_DEPS = xserver_install

define embtk_postinstall_xf86videofbdev
	$(Q)-cp -R $(embtk_sysroot)/usr/$(LIBDIR)/xorg $(embtk_rootfs)/usr/$(LIBDIR)/
endef
