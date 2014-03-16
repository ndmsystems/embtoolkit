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
# \file         vars.mk
# \brief	fakeroot variables
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         Marsh 2014
################################################################################

# fakeroot binaries and env
FAKEROOT_BIN		:= $(embtk_htools)/usr/bin/fakeroot
FAKEROOT_ENV_FILE	:= $(EMBTK_ROOT)/.fakeroot.001
export FAKEROOT_BIN FAKEROOT_ENV_FILE
