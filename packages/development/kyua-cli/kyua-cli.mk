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
# \file         kyua-cli.mk
# \brief	kyua-cli.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         July 2014
################################################################################

KYUA-CLI_NAME		:= kyua-cli
KYUA-CLI_VERSION	:= $(call embtk_get_pkgversion,kyua-cli)
KYUA-CLI_SITE		:= https://github.com/jmmv/kyua/releases/download/kyua-cli-$(KYUA-CLI_VERSION)
KYUA-CLI_PACKAGE	:= kyua-cli-$(KYUA-CLI_VERSION).tar.gz
KYUA-CLI_SRC_DIR	:= $(embtk_pkgb)/kyua-cli-$(KYUA-CLI_VERSION)
KYUA-CLI_BUILD_DIR	:= $(embtk_pkgb)/kyua-cli-$(KYUA-CLI_VERSION)-build

KYUA-CLI_BINS		:= kyua
KYUA-CLI_SHARES		:= doc/kyua-cli kyua-cli

KYUA-CLI_CONFIGURE_ENV	:= kyua_cv_attribute_noreturn=yes
KYUA-CLI_CONFIGURE_ENV	+= kyua_cv_getopt_optind_reset_value=1
KYUA-CLI_CONFIGURE_ENV	+= kyua_cv_signals_lastno=_NSIG
KYUA-CLI_CONFIGURE_ENV	+= kyua_cv_getcwd_works=yes
KYUA-CLI_CONFIGURE_ENV	+= kyua_cv_getcwd_null_0_works=yes

KYUA-CLI_CONFIGURE_OPTS	:= --with-atf=no --with-doxygen=no

KYUA-CLI_DEPS		:= lutok_install kyua-testers_install
