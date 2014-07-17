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
# \file         kyua-testers.mk
# \brief	kyua-testers.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         July 2014
################################################################################

KYUA-TESTERS_NAME	:= kyua-testers
KYUA-TESTERS_VERSION	:= $(call embtk_get_pkgversion,kyua-testers)
KYUA-TESTERS_SITE	:= https://github.com/jmmv/kyua/releases/download/kyua-testers-$(KYUA-TESTERS_VERSION)
KYUA-TESTERS_PACKAGE	:= kyua-testers-$(KYUA-TESTERS_VERSION).tar.gz
KYUA-TESTERS_SRC_DIR	:= $(embtk_pkgb)/kyua-testers-$(KYUA-TESTERS_VERSION)
KYUA-TESTERS_BUILD_DIR	:= $(embtk_pkgb)/kyua-testers-$(KYUA-TESTERS_VERSION)-build

KYUA-TESTERS_LIBEXECS		:= kyua-atf-tester kyua-plain-tester
KYUA-TESTERS_LIBEXECS		+= kyua-tap-tester
KYUA-TESTERS_PKGCONFIGS		:= kyua-testers.pc
KYUA-TESTERS_SHARES		:= doc/kyua-testers
KYUA-TESTERS_SHARES		+= man/man*/kyua-*

KYUA-TESTERS_CONFIGURE_ENV	:= kyua_cv_getopt_plus=no
KYUA-TESTERS_CONFIGURE_ENV	+= kyua_cv_attribute_noreturn=yes
KYUA-TESTERS_CONFIGURE_ENV	+= kyua_cv_lchmod_works=no
KYUA-TESTERS_CONFIGURE_ENV	+= kyua_cv_getopt_gnu=no
KYUA-TESTERS_CONFIGURE_ENV	+= kyua_cv_getopt_optind_reset_value=1
KYUA-TESTERS_CONFIGURE_ENV	+= kyua_cv_signals_lastno=_NSIG
KYUA-TESTERS_CONFIGURE_ENV	+= kyua_cv_getcwd_null_0_works=yes

KYUA-TESTERS_CONFIGURE_OPTS	:= --with-atf=no --with-doxygen=no

KYUA-TESTERS_DEPS		:= atf_install
