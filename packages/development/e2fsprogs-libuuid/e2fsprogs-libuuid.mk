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
# \file         e2fsprogs.mk
# \brief	e2fsprogs.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         June 2011
################################################################################

E2FSPROGS-LIBUUID_NAME		:= e2fsprogs-libuuid
E2FSPROGS-LIBUUID_VERSION	:= $(call embtk_pkg_version,e2fsprogs-libuuid)
E2FSPROGS-LIBUUID_SITE		:= http://sourceforge.net/projects/e2fsprogs/files/e2fsprogs/v$(E2FSPROGS-LIBUUID_VERSION)
E2FSPROGS-LIBUUID_PACKAGE	:= e2fsprogs-libs-$(E2FSPROGS-LIBUUID_VERSION).tar.gz
E2FSPROGS-LIBUUID_SRC_DIR	:= $(embtk_pkgb)/e2fsprogs-libs-$(E2FSPROGS-LIBUUID_VERSION)
E2FSPROGS-LIBUUID_BUILD_DIR	:= $(embtk_pkgb)/e2fsprogs-libs-$(E2FSPROGS-LIBUUID_VERSION)-build

E2FSPROGS-LIBUUID_INCLUDES	:= uuid
E2FSPROGS-LIBUUID_LIBS		:= libuuid.*
E2FSPROGS-LIBUUID_PKGCONFIGS	:= uuid.pc
E2FSPROGS-LIBUUID_SHARES	:= man/man*/uuid*

E2FSPROGS-LIBUUID_MAKE_OPTS      := LDCONFIG=true
E2FSPROGS-LIBUUID_MAKE_DIRS      := util lib/uuid

E2FSPROGS-LIBUUID_CONFIGURE_OPTS := --disable-compression
E2FSPROGS-LIBUUID_CONFIGURE_OPTS += --disable-htree
E2FSPROGS-LIBUUID_CONFIGURE_OPTS += --enable-elf-shlibs
E2FSPROGS-LIBUUID_CONFIGURE_OPTS += --disable-bsd-shlibs
E2FSPROGS-LIBUUID_CONFIGURE_OPTS += --disable-profile
E2FSPROGS-LIBUUID_CONFIGURE_OPTS += --disable-checker
E2FSPROGS-LIBUUID_CONFIGURE_OPTS += --disable-jbd-debug
E2FSPROGS-LIBUUID_CONFIGURE_OPTS += --disable-blkid-debug
E2FSPROGS-LIBUUID_CONFIGURE_OPTS += --disable-testio-debug
E2FSPROGS-LIBUUID_CONFIGURE_OPTS += --enable-libuuid
E2FSPROGS-LIBUUID_CONFIGURE_OPTS += --enable-libblkid
E2FSPROGS-LIBUUID_CONFIGURE_OPTS += --disable-debugfs
E2FSPROGS-LIBUUID_CONFIGURE_OPTS += --disable-imager
E2FSPROGS-LIBUUID_CONFIGURE_OPTS += --disable-resizer
E2FSPROGS-LIBUUID_CONFIGURE_OPTS += --disable-fsck
E2FSPROGS-LIBUUID_CONFIGURE_OPTS += --disable-e2initrd-helper
E2FSPROGS-LIBUUID_CONFIGURE_OPTS += --disable-tls
E2FSPROGS-LIBUUID_CONFIGURE_OPTS += --disable-nls
E2FSPROGS-LIBUUID_CONFIGURE_OPTS += --disable-rpath
E2FSPROGS-LIBUUID_CONFIGURE_OPTS += --with-included-gettext
