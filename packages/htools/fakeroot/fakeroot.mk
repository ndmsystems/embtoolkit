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
# \file         fakeroot.mk
# \brief	fakeroot.mk of Embtoolkit. fakeroot helps building root
# \brief	filesystem, without the need to be root.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         June 2009
################################################################################

FAKEROOT_HOST_NAME	:= fakeroot
FAKEROOT_HOST_VERSION	:= $(call embtk_get_pkgversion,fakeroot_host)
FAKEROOT_HOST_SITE	:= http://ftp.debian.org/debian/pool/main/f/fakeroot
FAKEROOT_HOST_PACKAGE	:= fakeroot_$(FAKEROOT_HOST_VERSION).orig.tar.bz2
FAKEROOT_HOST_SRC_DIR	:= $(embtk_toolsb)/fakeroot-$(FAKEROOT_HOST_VERSION)
FAKEROOT_HOST_BUILD_DIR	:= $(embtk_toolsb)/fakeroot-build
