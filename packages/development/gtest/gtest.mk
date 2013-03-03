################################################################################
# Embtoolkit
# Copyright(C) 2013 Abdoulaye Walsimou GAYE.
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
# \file         gtest.mk
# \brief	gtest.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2013
################################################################################

GTEST_NAME		:= gtest
GTEST_VERSION		:= $(call embtk_get_pkgversion,gtest)
GTEST_SITE		:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
GTEST_PACKAGE		:= gtest-$(GTEST_VERSION).tar.bz2
GTEST_SRC_DIR		:= $(embtk_pkgb)/gtest-$(GTEST_VERSION)
GTEST_BUILD_DIR		:= $(embtk_pkgb)/gtest-$(GTEST_VERSION)
GTEST_EMBTK_DIR		:= $(EMBTK_ROOT)/packages/development/gtest

__embtk_gtest_cflags	:= $(TARGET_CFLAGS)

GTEST_MAKE_OPTS	:= CC="$(TARGETCC)" CXX="$(TARGETCXX)"
GTEST_MAKE_OPTS	+= CFLAGS="$(__embtk_gtest_cflags)" LIBDIR="$(LIBDIR)"
GTEST_MAKE_OPTS	+= AR="$(TARGETAR)" RANLIB="$(TARGETRANLIB)"
GTEST_MAKE_OPTS	+= SYSROOT="$(embtk_sysroot)"

define embtk_install_gtest
	$(call embtk_makeinstall_pkg,gtest)
endef

define embtk_beforeinstall_gtest
	[ -e $(call __embtk_pkg_srcdir,gtest)/Makefile ] ||			\
		ln -sf $(GTEST_EMBTK_DIR)/Makefile				\
				$(call __embtk_pkg_srcdir,gtest)/Makefile
endef

define embtk_cleanup_gtest
	if [ -e $(call __embtk_pkg_srcdir,gtest)/Makefile ]; then		\
		$(MAKE) -C $(call __embtk_pkg_srcdir,gtest) clean;		\
	fi
	rm -rf $(call __embtk_pkg_srcdir,gtest)/Makefile
endef
