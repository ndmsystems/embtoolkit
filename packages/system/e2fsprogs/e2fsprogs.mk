################################################################################
# Embtoolkit
# Copyright(C) 2011 Abdoulaye Walsimou GAYE.
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

E2FSPROGS_NAME		:= e2fsprogs
E2FSPROGS_VERSION	:= $(call embtk_get_pkgversion,e2fsprogs)
E2FSPROGS_SITE		:= http://sourceforge.net/projects/e2fsprogs/files/e2fsprogs/$(E2FSPROGS_VERSION)
E2FSPROGS_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
E2FSPROGS_PACKAGE	:= e2fsprogs-$(E2FSPROGS_VERSION).tar.gz
E2FSPROGS_SRC_DIR	:= $(PACKAGES_BUILD)/e2fsprogs-$(E2FSPROGS_VERSION)
E2FSPROGS_BUILD_DIR	:= $(PACKAGES_BUILD)/e2fsprogs-$(E2FSPROGS_VERSION)

E2FSPROGS_BINS		:=
E2FSPROGS_SBINS		:=
E2FSPROGS_INCLUDES	:= uuid
E2FSPROGS_LIBS		:= libuuid.*
E2FSPROGS_LIBEXECS	:=
E2FSPROGS_PKGCONFIGS	:= uuid.pc

E2FSPROGS_CONFIGURE_ENV :=
E2FSPROGS_MAKE_OPTS := LDCONFIG=true
E2FSPROGS_MAKE_DIRS := lib/uuid
E2FSPROGS_CONFIGURE_OPTS := --disable-compression --disable-htree	\
		--enable-elf-shlibs --disable-bsd-shlibs		\
		--disable-profile --disable-checker --disable-jbd-debug	\
		--disable-blkid-debug --disable-testio-debug		\
		--enable-libuuid --enable-libblkid --disable-debugfs	\
		--disable-imager --disable-resizer --disable-fsck	\
		--disable-e2initrd-helper --disable-tls --disable-nls	\
		--disable-rpath --with-included-gettext

#
# E2FSPROGS for host development machine
#
E2FSPROGS_HOST_NAME		:= $(E2FSPROGS_NAME)
E2FSPROGS_HOST_VERSION		:= $(E2FSPROGS_VERSION)
E2FSPROGS_HOST_SITE		:= $(E2FSPROGS_SITE)
E2FSPROGS_HOST_SITE_MIRROR3	:= $(E2FSPROGS_SITE_MIRROR3)
E2FSPROGS_HOST_PACKAGE		:= $(E2FSPROGS_PACKAGE)
E2FSPROGS_HOST_SRC_DIR		:= $(embtk_toolsb)/e2fsprogs-$(E2FSPROGS_VERSION)
E2FSPROGS_HOST_BUILD_DIR	:= $(embtk_toolsb)/e2fsprogs-$(E2FSPROGS_VERSION)

E2FSPROGS_HOST_MAKE_OPTS	:= LDCONFIG=true
E2FSPROGS_HOST_MAKE_DIRS	:= $(E2FSPROGS_MAKE_DIRS)
E2FSPROGS_HOST_CONFIGURE_OPTS	:= $(E2FSPROGS_CONFIGURE_OPTS)

