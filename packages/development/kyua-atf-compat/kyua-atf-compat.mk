################################################################################
# Embtoolkit
# Copyright(C) 2009-2012 Abdoulaye Walsimou GAYE.
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
# \file         kyua-atf-compat.mk
# \brief	kyua-atf-compat.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         July 2014
################################################################################

KYUA-ATF-COMPAT_NAME		:= kyua-atf-compat
KYUA-ATF-COMPAT_VERSION		:= $(call embtk_get_pkgversion,kyua-atf-compat)
KYUA-ATF-COMPAT_SITE		:= https://github.com/jmmv/kyua/releases/download/kyua-atf-compat-$(KYUA-ATF-COMPAT_VERSION)
KYUA-ATF-COMPAT_PACKAGE		:= kyua-atf-compat-$(KYUA-ATF-COMPAT_VERSION).tar.gz
KYUA-ATF-COMPAT_SRC_DIR		:= $(embtk_pkgb)/kyua-atf-compat-$(KYUA-ATF-COMPAT_VERSION)
KYUA-ATF-COMPAT_BUILD_DIR	:= $(embtk_pkgb)/kyua-atf-compat-$(KYUA-ATF-COMPAT_VERSION)-build

KYUA-ATF-COMPAT_BINS		:= atf2kyua atf-report atf-run
KYUA-ATF-COMPAT_SHARES		:= doc/kyua-atf-compat kyua-atf-compat
KYUA-ATF-COMPAT_SHARES		+= man/man1/atf2kyua.1

KYUA-ATF-COMPAT_DEPS		:= kyua-testers_install
