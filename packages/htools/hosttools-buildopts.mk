################################################################################
# Embtoolkit
# Copyright(C) 2014 Abdoulaye Walsimou GAYE.
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
# \file         hosttools-buildopts.mk
# \brief	packages needed for both toolchain and rootfs packages.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         Marsh 2014
################################################################################

embtk_pkgincdir := packages/htools

# cache
$(call embtk_include_hostpkg,ccache_host)

# fakeroot
include packages/htools/fakeroot/vars.mk
$(call embtk_include_hostpkg,fakeroot_host)

# pkgconf
include packages/htools/pkgconf/vars.mk
$(call embtk_include_hostpkg,pkgconf_host)