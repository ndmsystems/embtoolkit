################################################################################
# Embtoolkit
# Copyright(C) 2012 Abdoulaye Walsimou GAYE.
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
# \file         rings.mk
# \brief	rings.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         April 2012
################################################################################

RINGS_NAME	:= rings
RINGS_VERSION	:= $(call embtk_get_pkgversion,rings)
RINGS_SITE	:= https://github.com/downloads/keplerproject/rings
RINGS_PACKAGE	:= rings-$(RINGS_VERSION).tar.gz
RINGS_SRC_DIR	:= $(PACKAGES_BUILD)/rings-$(RINGS_VERSION)
RINGS_BUILD_DIR	:= $(PACKAGES_BUILD)/rings-$(RINGS_VERSION)

RINGS_LIBS		=

RINGS_DEPS		= lua_install

RINGS_MAKE_OPTS		= PREFIX=$(embtk_sysroot)/usr/ LIBDIR=$(LIBDIR)
RINGS_MAKE_OPTS		+= CC=$(TARGETCC_CACHED)
RINGS_MAKE_OPTS		+= LDFLAGS="-L$(embtk_sysroot)/$(LIBDIR) -L$(embtk_sysroot)/usr/$(LIBDIR)"
RINGS_MAKE_OPTS		+= CFLAGS="$(TARGET_CFLAGS) -I$(embtk_sysroot)/usr/include"

rings_install:
	$(call embtk_makeinstall_pkg,rings)

define embtk_postinstall_rings
	$(Q)mkdir -p $(ROOTFS)
	$(Q)mkdir -p $(ROOTFS)/usr
	$(Q)mkdir -p $(ROOTFS)/usr/$(LIBDIR)
	$(Q)mkdir -p $(ROOTFS)/usr/share
	$(Q)cp -R $(embtk_sysroot)/usr/$(LIBDIR)/lua $(ROOTFS)/usr/$(LIBDIR)/
	$(Q)cp -R $(embtk_sysroot)/usr/share/lua $(ROOTFS)/usr/share/
endef
