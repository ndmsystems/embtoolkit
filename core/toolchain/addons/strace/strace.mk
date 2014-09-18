################################################################################
# Embtoolkit
# Copyright(C) 2009-2013 Abdoulaye Walsimou GAYE.
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
# \file         strace.mk
# \brief	strace.mk of Embtoolkit.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         August 2009
################################################################################

STRACE_NAME		:= strace
STRACE_VERSION		:= $(call embtk_get_pkgversion,strace)
STRACE_SITE		:= http://downloads.sourceforge.net/project/strace/strace/$(STRACE_VERSION)
STRACE_GIT_SITE		:= git://git.code.sf.net/p/strace/code
STRACE_PACKAGE		:= strace-$(STRACE_VERSION).tar.bz2
STRACE_SRC_DIR		:= $(embtk_pkgb)/strace-$(STRACE_VERSION)
STRACE_BUILD_DIR	:= $(embtk_pkgb)/strace-build

STRACE_BINS		:= strace strace-graph strace-log-merge
