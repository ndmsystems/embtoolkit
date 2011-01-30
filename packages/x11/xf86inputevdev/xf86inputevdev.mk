################################################################################
# Embtoolkit
# Copyright(C) 2010-2011 Abdoulaye Walsimou GAYE. All rights reserved.
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

XF86INPUTEVDEV_NAME := xf86-input-evdev
XF86INPUTEVDEV_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_XF86INPUTEVDEV_VERSION_STRING)))
XF86INPUTEVDEV_SITE := http://xorg.freedesktop.org/archive/individual/driver
XF86INPUTEVDEV_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
XF86INPUTEVDEV_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/xf86-input-evdev/$(XF86INPUTEVDEV_VERSION)
XF86INPUTEVDEV_PACKAGE := xf86-input-evdev-$(XF86INPUTEVDEV_VERSION).tar.bz2
XF86INPUTEVDEV_SRC_DIR := $(PACKAGES_BUILD)/xf86-input-evdev-$(XF86INPUTEVDEV_VERSION)
XF86INPUTEVDEV_BUILD_DIR := $(PACKAGES_BUILD)/xf86-input-evdev-$(XF86INPUTEVDEV_VERSION)

XF86INPUTEVDEV_BINS =
XF86INPUTEVDEV_SBINS =
XF86INPUTEVDEV_INCLUDES = xorg/evdev-properties.h
XF86INPUTEVDEV_LIBS = xorg/modules/input/evdev_drv.*
XF86INPUTEVDEV_PKGCONFIGS = xorg-evdev.pc

XF86INPUTEVDEV_DEPS = xserver_install

xf86inputevdev_install:
	@test -e $(XF86INPUTEVDEV_BUILD_DIR)/.installed || \
	$(MAKE) $(XF86INPUTEVDEV_BUILD_DIR)/.installed
	$(Q)$(MAKE) $(XF86INPUTEVDEV_BUILD_DIR)/.special

$(XF86INPUTEVDEV_BUILD_DIR)/.installed: $(XF86INPUTEVDEV_DEPS) \
	download_xf86inputevdev $(XF86INPUTEVDEV_BUILD_DIR)/.decompressed \
	$(XF86INPUTEVDEV_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	xf86inputevdev-$(XF86INPUTEVDEV_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(XF86INPUTEVDEV_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(XF86INPUTEVDEV_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_xf86inputevdev:
	$(call EMBTK_DOWNLOAD_PKG,XF86INPUTEVDEV)

$(XF86INPUTEVDEV_BUILD_DIR)/.decompressed:
	$(call EMBTK_DECOMPRESS_PKG,XF86INPUTEVDEV)

$(XF86INPUTEVDEV_BUILD_DIR)/.configured:
	$(call EMBTK_CONFIGURE_PKG,XF86INPUTEVDEV)

xf86inputevdev_clean:
	$(call EMBTK_CLEANUP_PKG,XF86INPUTEVDEV)

.PHONY: $(XF86INPUTEVDEV_BUILD_DIR)/.special

$(XF86INPUTEVDEV_BUILD_DIR)/.special:
	$(Q)-cp -R $(SYSROOT)/usr/$(LIBDIR)/xorg $(ROOTFS)/usr/$(LIBDIR)/
	@touch $@
