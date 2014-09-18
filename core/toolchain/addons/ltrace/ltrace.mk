################################################################################
# Embtoolkit
# Copyright(C) 2009-2014 Abdoulaye Walsimou GAYE.
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
# \file         ltrace.mk
# \brief	ltrace.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         July 2014
################################################################################

LTRACE_NAME		:= ltrace
LTRACE_VERSION		:= $(call embtk_get_pkgversion,ltrace)
LTRACE_SITE		:= $(embtk_ftp/packages-mirror)
LTRACE_GIT_SITE		:= git://git.debian.org/git/collab-maint/ltrace.git
LTRACE_PACKAGE		:= ltrace-$(LTRACE_VERSION).tar.bz2
LTRACE_SRC_DIR		:= $(embtk_pkgb)/ltrace-$(LTRACE_VERSION)
LTRACE_BUILD_DIR	:= $(embtk_pkgb)/ltrace-$(LTRACE_VERSION)-build

LTRACE_BINS		:= ltrace
LTRACE_SHARES		:= doc/ltrace ltrace man/man*/ltrace*

LTRACE_CONFIGURE_OPTS	:= --disable-werror --with-elfutils=no

LTRACE_DEPS		:= libelf_install

define embtk_postinstall_ltrace
	rm -rf $(embtk_rootfs)/usr/share/ltrace
	install -d $(embtk_rootfs)/usr/share/ltrace
	cp -R $(embtk_sysroot)/usr/share/ltrace/* $(embtk_rootfs)/usr/share/ltrace
endef
