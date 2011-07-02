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
# \file         fakeroot.mk
# \brief	fakeroot.mk of Embtoolkit. fakeroot helps building root
# \brief	filesystem, without the need to be root.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         June 2009
################################################################################

FAKEROOT_NAME		:= fakeroot
FAKEROOT_VERSION	:= $(call embtk_get_pkgversion,FAKEROOT)
FAKEROOT_SITE		:= http://ftp.debian.org/debian/pool/main/f/fakeroot
FAKEROOT_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
FAKEROOT_PATCH_SITE	:= ftp://ftp.embtoolkit.org/embtoolkit.org/fakeroot/$(FAKEROOT_VERSION)
FAKEROOT_PACKAGE	:= fakeroot_$(FAKEROOT_VERSION).tar.gz
FAKEROOT_SRC_DIR	:= $(TOOLS_BUILD)/fakeroot-$(FAKEROOT_VERSION)
FAKEROOT_BUILD_DIR	:= $(TOOLS_BUILD)/fakeroot-build

# fakeroot binaries and env
FAKEROOT_BIN		:= $(HOSTTOOLS)/usr/bin/fakeroot
FAKEROOT_ENV_FILE	:= $(EMBTK_ROOT)/.fakeroot.001
export FAKEROOT_BIN FAKEROOT_ENV_FILE

fakeroot_install:
	$(call embtk_install_hostpkg,FAKEROOT)

download_fakeroot:
	$(call embtk_download_pkg,FAKEROOT)
