################################################################################
# Embtoolkit
# Copyright(C) 2009-2011 Abdoulaye Walsimou GAYE.
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
# \file         foo.mk
# \brief	foo.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

FOO_NAME := foo
FOO_VERSION := $(call EMBTK_GET_PKG_VERSION,FOO)
FOO_SITE := http://www.foo.org/download
FOO_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
FOO_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/foo/$(FOO_VERSION)
FOO_PACKAGE := foo-$(FOO_VERSION).tar.gz
FOO_SRC_DIR := $(PACKAGES_BUILD)/foo-$(FOO_VERSION)
FOO_BUILD_DIR := $(PACKAGES_BUILD)/foo-$(FOO_VERSION)

FOO_BINS =
FOO_SBINS =
FOO_INCLUDES =
FOO_LIBS =
FOO_LIBEXECS =
FOO_PKGCONFIGS =

FOO_CONFIGURE_ENV :=
FOO_CONFIGURE_OPTS :=

FOO_DEPS :=

foo_install:
	$(call EMBTK_INSTALL_PKG,FOO)

download_foo:
	$(call EMBTK_DOWNLOAD_PKG,FOO)

foo_clean:
	$(call EMBTK_CLEANUP_PKG,FOO)
