################################################################################
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
# \file         openrc.mk
# \brief	openrc.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2013
################################################################################

OPENRC_NAME		:= openrc
OPENRC_VERSION		:= $(call embtk_get_pkgversion,openrc)
OPENRC_SITE		:= $(embtk_ftp/packages-mirror)
OPENRC_PACKAGE		:= openrc-$(OPENRC_VERSION).tar.bz2
OPENRC_SRC_DIR		:= $(embtk_pkgb)/openrc-$(OPENRC_VERSION)
OPENRC_BUILD_DIR	:= $(embtk_pkgb)/openrc-$(OPENRC_VERSION)

OPENRC_ETC		:= conf.d init.d.misc init.d local.d rc.conf runlevels sysctl.d
OPENRC_LIBEXECS		:= rc

ifeq ($(embtk_os),linux)
OPENRC_MAKE_OPTS	:= OS=Linux
endif

OPENRC_MAKE_ENV		:= LIBNAME=$(LIBDIR) MKSTATICLIBS=no MKPKGCONFIG=no
OPENRC_MAKE_ENV		+= AR=$(TARGETAR) RANLIB=$(TARGETRANLIB)
OPENRC_MAKE_ENV		+= CC=$(TARGETCC_CACHED) CFLAGS="$(TARGET_CFLAGS)"
OPENRC_MAKE_ENV		+= LIBEXECDIR=/usr/libexec/rc
OPENRC_MAKE_ENV		+= BRANDING="EmbToolkit v$(EMBTK_VERSION)"
OPENRC_MAKE_ENV		+= MKCONFD=no
OPENRC_MAKE_ENV		+= MKETC=no
OPENRC_MAKE_ENV		+= MKINITD=no
OPENRC_MAKE_ENV		+= MKLOCALD=no
OPENRC_MAKE_ENV		+= MKMAN=no
OPENRC_MAKE_ENV		+= MKSCRIPTS=no
OPENRC_MAKE_ENV		+= MKSYSCTLD=no
OPENRC_MAKE_ENV		+= MKRUNLEVELS=no

define embtk_install_openrc
	$(call embtk_makeinstall_pkg,openrc)
endef

define embtk_cleanup_openrc
	rm -rf $(embtk_sysroot)/$(LIBDIR)/libeinfo.so*
	rm -rf $(embtk_sysroot)/$(LIBDIR)/librc.so*
	rm -rf $(embtk_sysroot)/bin/rc-status
	rm -rf $(embtk_sysroot)/sbin/rc
	rm -rf $(embtk_sysroot)/sbin/rc-service
	rm -rf $(embtk_sysroot)/sbin/rc-update
	rm -rf $(embtk_sysroot)/sbin/runscript
	rm -rf $(embtk_sysroot)/sbin/service
	rm -rf $(embtk_sysroot)/sbin/start-stop-daemon
	rm -rf $(embtk_sysroot)/sbin/openrc
	rm -rf $(embtk_sysroot)/sbin/openrc-run
endef
