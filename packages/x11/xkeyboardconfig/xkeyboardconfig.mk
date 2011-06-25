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
# \file         xkeyboardconfig.mk
# \brief	xkeyboardconfig.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

XKEYBOARDCONFIG_NAME		:= xkeyboard-config
XKEYBOARDCONFIG_VERSION		:= $(call EMBTK_GET_PKG_VERSION,XKEYBOARDCONFIG)
XKEYBOARDCONFIG_SITE		:= http://www.x.org/releases/individual/data/xkeyboard-config
XKEYBOARDCONFIG_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
XKEYBOARDCONFIG_PATCH_SITE	:= ftp://ftp.embtoolkit.org/embtoolkit.org/xkeyboard-config/$(XKEYBOARDCONFIG_VERSION)
XKEYBOARDCONFIG_PACKAGE		:= xkeyboard-config-$(XKEYBOARDCONFIG_VERSION).tar.bz2
XKEYBOARDCONFIG_SRC_DIR		:= $(PACKAGES_BUILD)/xkeyboard-config-$(XKEYBOARDCONFIG_VERSION)
XKEYBOARDCONFIG_BUILD_DIR	:= $(PACKAGES_BUILD)/xkeyboard-config-$(XKEYBOARDCONFIG_VERSION)

XKEYBOARDCONFIG_BINS =
XKEYBOARDCONFIG_SBINS =
XKEYBOARDCONFIG_INCLUDES =
XKEYBOARDCONFIG_LIBS =
XKEYBOARDCONFIG_PKGCONFIGS =

XKEYBOARDCONFIG_DEPS = intltool_host_install xkbcomp_install

xkeyboardconfig_install:
	$(call EMBTK_INSTALL_PKG,XKEYBOARDCONFIG)
	$(Q)$(MAKE) $(XKEYBOARDCONFIG_BUILD_DIR)/.special

download_xkeyboardconfig:
	$(call EMBTK_DOWNLOAD_PKG,XKEYBOARDCONFIG)

xkeyboardconfig_clean:
	$(call EMBTK_CLEANUP_PKG,XKEYBOARDCONFIG)

.PHONY: $(XKEYBOARDCONFIG_BUILD_DIR)/.special

$(XKEYBOARDCONFIG_BUILD_DIR)/.special:
	$(Q)-mkdir -p $(ROOTFS)/usr/share
	$(Q)-mkdir -p $(ROOTFS)/usr/share/X11
	$(Q)-cp -R $(SYSROOT)/usr/share/X11/xkb $(ROOTFS)/usr/share/X11/
	@touch $@
