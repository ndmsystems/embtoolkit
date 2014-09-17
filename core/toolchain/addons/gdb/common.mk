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
# \file         common.mk
# \brief	common.mk options for gdb/gdbserver for target
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         September 2014
################################################################################

GDBCOMMON_DEPS := ncurses_install

GDBCOMMON_CONFIGURE_OPTS := --disable-werror
GDBCOMMON_CONFIGURE_OPTS += --disable-sim
GDBCOMMON_CONFIGURE_OPTS += --disable-nls
GDBCOMMON_CONFIGURE_OPTS += --with-zlib=no
GDBCOMMON_CONFIGURE_OPTS += --with-bugurl="$(EMBTK_BUGURL)"
GDBCOMMON_CONFIGURE_OPTS += --with-pkgversion="embtk-$(EMBTK_VERSION)"

GDBCOMMON_INCLUDES := ansidecl.h bfd.h bfdlink.h dis-asm.h symcat.h gdb
GDBCOMMON_LIBS     := lib*-sim.a  libbfd.*  libiberty.* libopcodes.*
GDBCOMMON_BINS     := gdb gdbtui run

