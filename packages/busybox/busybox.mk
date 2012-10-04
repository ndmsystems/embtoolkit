################################################################################
# Embtoolkit
# Copyright(C) 2009-1010 Abdoulaye Walsimou GAYE.
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
# \file         busybox.mk
# \brief	busybox.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

BB_NAME		:= busybox
BB_VERSION	:= $(call embtk_get_pkgversion,bb)
BB_SITE		:= http://www.busybox.net/downloads
BB_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
BB_PACKAGE	:= busybox-$(BB_VERSION).tar.bz2
BB_SRC_DIR	:= $(embtk_pkgb)/busybox-$(BB_VERSION)
BB_BUILD_DIR	:= $(embtk_pkgb)/busybox-$(BB_VERSION)

BB_NODESTDIR	:= y
BB_MAKE_ENV	= CFLAGS="$(TARGET_CFLAGS) -pipe -fno-strict-aliasing"
BB_MAKE_OPTS	= CROSS_COMPILE="$(CCACHE_BIN) $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-"
BB_MAKE_OPTS	+= CONFIG_PREFIX=$(embtk_rootfs)

bb_install:
	$(call embtk_makeinstall_pkg,bb)

define embtk_beforeinstall_bb
	$(embtk_configure_bb)
	$(Q)$(MAKE) -C $(BB_BUILD_DIR)						\
	CROSS_COMPILE="$(CCACHE_BIN) $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-"	\
	CONFIG_PREFIX=$(embtk_rootfs) oldconfig
endef

define embtk_postinstall_bb
	$(Q)CFLAGS="$(TARGET_CFLAGS) -pipe -fno-strict-aliasing"		\
	$(MAKE) -C $(BB_BUILD_DIR)						\
	CROSS_COMPILE="$(CCACHE_BIN) $(embtk_tools)/bin/$(STRICT_GNU_TARGET)-"	\
	CONFIG_PREFIX=$(embtk_rootfs) install
endef

define embtk_configure_bb
	$(call embtk_pinfo,"Configuring busybox...")
	$(Q)grep "CONFIG_KEMBTK_BUSYB_" $(EMBTK_ROOT)/.config |			\
		sed -e 's/CONFIG_KEMBTK_BUSYB_*/CONFIG_/g'			\
						> $(BB_BUILD_DIR)/.config
	$(Q)sed -i 's/_1_13_X_1_14_X//g' $(BB_BUILD_DIR)/.config
endef
