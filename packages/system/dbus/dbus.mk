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
# \file         dbus.mk
# \brief	dbus.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         July 2010
################################################################################

DBUS_NAME := dbus
DBUS_VERSION := $(call EMBTK_GET_PKG_VERSION,DBUS)
DBUS_SITE := http://dbus.freedesktop.org/releases/dbus
DBUS_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
DBUS_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/dbus/$(DBUS_VERSION)
DBUS_PACKAGE := dbus-$(DBUS_VERSION).tar.gz
DBUS_SRC_DIR := $(PACKAGES_BUILD)/dbus-$(DBUS_VERSION)
DBUS_BUILD_DIR := $(PACKAGES_BUILD)/dbus-$(DBUS_VERSION)

DBUS_BINS = dbus-cleanup-sockets dbus-daemon dbus-launch dbus-monitor \
		dbus-send dbus-uuidgen
DBUS_SBINS =
DBUS_INCLUDES = dbus-*
DBUS_LIBS = dbus-* libdbus*
DBUS_PKGCONFIGS = dbus*.pc

DBUS_DEPS = expat_install \
	$(if $(CONFIG_EMBTK_HAVE_LIBX11),libx11_install,)

DBUS_CONFIGURE_OPTS := --enable-abstract-sockets \
	$(if $(CONFIG_EMBTK_HAVE_LIBX11),--with-x,--without-x)

dbus_install:
	$(call EMBTK_INSTALL_PKG,DBUS)
	$(Q)$(MAKE) $(DBUS_BUILD_DIR)/.special

download_dbus:
	$(call EMBTK_DOWNLOAD_PKG,DBUS)

dbus_clean:
	$(call EMBTK_CLEANUP_PKG,DBUS)

.PHONY: $(DBUS_BUILD_DIR)/.special dbus_clean

$(DBUS_BUILD_DIR)/.special:
	$(Q)-mkdir -p $(ROOTFS)/usr/libexec
	$(Q)-cp -R $(SYSROOT)/usr/libexec/dbus* $(ROOTFS)/usr/libexec/
