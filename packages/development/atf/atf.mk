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
# \file         atf.mk
# \brief	atf.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         July 2014
################################################################################

ATF_NAME	:= atf
ATF_VERSION	:= $(call embtk_get_pkgversion,atf)
ATF_SITE	:= https://github.com/jmmv/atf/releases/download/atf-$(ATF_VERSION)
ATF_PACKAGE	:= atf-$(ATF_VERSION).tar.gz
ATF_SRC_DIR	:= $(embtk_pkgb)/atf-$(ATF_VERSION)
ATF_BUILD_DIR	:= $(embtk_pkgb)/atf-$(ATF_VERSION)-build

ATF_BINS	:= atf-sh
ATF_INCLUDES	:= atf-c atf-c++ atf-c.h atf-c++.hpp
ATF_LIBS	:= libatf-*
ATF_LIBEXECS	:= atf-check
ATF_PKGCONFIGS	:= atf-*.pc
ATF_SHARES	:= aclocal/atf-*.m4 atf doc/atf man/man*/atf-*

ATF_CONFIGURE_ENV	:= kyua_cv_getopt_plus=no
ATF_CONFIGURE_ENV	+= kyua_cv_attribute_noreturn=yes
ATF_CONFIGURE_ENV	+= kyua_cv_getcwd_works=yes
ATF_CONFIGURE_OPTS	:= --program-transform-name='s;$(STRICT_GNU_TARGET)-;;'

define embtk_postinstall_atf
	[ -e $(embtk_rootfs)/usr/share/atf ] ||					\
		install -d $(embtk_rootfs)/usr/share/atf
	cp -R $(embtk_sysroot)/usr/share/atf/* $(embtk_rootfs)/usr/share/atf
	$(if $(CONFIG_EMBTK_HAVE_ATF_WITH_SELFTESTS),
	[ -d $(embtk_rootfs)/usr/tests ] || install -d $(embtk_rootfs)/usr/tests
	cp -R $(embtk_sysroot)/usr/tests/atf $(embtk_rootfs)/usr/tests)
endef

define embtk_cleanup_atf
	$(Q)rm -rf $(embtk_sysroot)/usr/tests/atf
endef
