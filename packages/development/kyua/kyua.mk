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
# \file         kyua.mk
# \brief	kyua.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         July 2014
################################################################################

KYUA_NAME	:= kyua
KYUA_VERSION	:= $(call embtk_get_pkgversion,kyua)
KYUA_SITE	:= https://github.com/jmmv/kyua/releases/download/kyua-$(KYUA_VERSION)
KYUA_PACKAGE	:= kyua-$(KYUA_VERSION).tar.gz
KYUA_SRC_DIR	:= $(embtk_pkgb)/kyua-$(KYUA_VERSION)
KYUA_BUILD_DIR	:= $(embtk_pkgb)/kyua-$(KYUA_VERSION)-build

KYUA_BINS		:= kyua
KYUA_SHARES		:= doc/kyua kyua man/man*/kyua*
KYUA_LIBEXECS		:= kyua-atf-tester kyua-plain-tester kyua-tap-tester

KYUA_CONFIGURE_ENV	:= kyua_cv_attribute_noreturn=yes
KYUA_CONFIGURE_ENV	+= kyua_cv_getopt_plus=no
KYUA_CONFIGURE_ENV	+= kyua_cv_getopt_optind_reset_value=1
KYUA_CONFIGURE_ENV	+= kyua_cv_getopt_gnu=yes
KYUA_CONFIGURE_ENV	+= kyua_cv_lchmod_works=no
KYUA_CONFIGURE_ENV	+= kyua_cv_signals_lastno=_NSIG
KYUA_CONFIGURE_ENV	+= kyua_cv_getcwd_works=yes
KYUA_CONFIGURE_ENV	+= kyua_cv_getcwd_null_0_works=yes

KYUA_CONFIGURE_OPTS	:= --with-atf=no --with-doxygen=no

KYUA_DEPS		:= atf_install lutok_install sqlite_install

pembtk_kyua_shared	:= misc store
define embtk_postinstall_kyua
	rm -rf $(embtk_rootfs)/usr/share/kyua
	install -d $(embtk_rootfs)/usr/share/kyua
	for s in $(pembtk_kyua_shared); do					\
		cp -R $(embtk_sysroot)/usr/share/kyua/$$s			\
			$(embtk_rootfs)/usr/share/kyua/$$s;			\
	done
endef
