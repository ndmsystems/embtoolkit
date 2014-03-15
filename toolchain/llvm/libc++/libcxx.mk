################################################################################
# Embtoolkit
# Copyright(C) 2012-2014 Abdoulaye Walsimou GAYE <awg@embtoolkit.org>.
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
# \file         libcxx.mk
# \brief	libcxx.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2012
################################################################################

LIBCXX_NAME		:= libcxx
LIBCXX_VERSION		:= $(call embtk_get_pkgversion,libcxx)
LIBCXX_SITE		:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror/$(LIBCXX_VERSION)
#LIBCXX_GIT_SITE	:= http://llvm.org/git/libcxx.git
LIBCXX_GIT_SITE		:= git://www.embtoolkit.org/libcxx.git
LIBCXX_PACKAGE		:= libcxx-$(LIBCXX_VERSION).tar.bz2
LIBCXX_SRC_DIR		:= $(embtk_toolsb)/libcxx-$(LIBCXX_VERSION)
LIBCXX_BUILD_DIR	:= $(call __embtk_pkg_srcdir,libcxx)

LIBCXX_KEEP_SRC_DIR	:= y

LIBCXX_DEPS		:= libcxxrt_install

__embtk_libcxx_cflags	:= $(TARGET_CFLAGS)
__embtk_libcxx_cflags	+= -I$(embtk_sysroot)/usr/include/c++/v1

LIBCXX_MAKE_OPTS	:= CC="$(TARGETCC)" CFLAGS="$(__embtk_libcxx_cflags)"
LIBCXX_MAKE_OPTS	+= CXX="$(TARGETCXX)" LIBDIR=$(LIBDIR)
LIBCXX_MAKE_OPTS	+= AR=$(TARGETAR) RANLIB=$(TARGETRANLIB)
LIBCXX_MAKE_OPTS	+= SYSROOT="$(embtk_sysroot)"

define embtk_install_libcxx
	$(call embtk_makeinstall_pkg,libcxx)
endef

define embtk_beforeinstall_libcxx
	ln -sf $(EMBTK_ROOT)/mk/libc++/libc++/Makefile				\
					$(LIBCXX_BUILD_DIR)/Makefile
endef

__embtk_staticlibcxx := $(embtk_sysroot)/usr/$(LIBDIR)/libc++.a
define __embtk_postinstall_staticlibcxx
	(echo "GROUP(libc++_nonshared.a libcxxrt.a libpthread.a librt.a libdl.a)" \
					> $(__embtk_staticlibcxx))
endef

define embtk_postinstallonce_libcxx
	$(__embtk_postinstall_staticlibcxx)
endef

define embtk_cleanup_libcxx
	if [ -e $(LIBCXXRT_BUILD_DIR)/Makefile ]; then				\
		$(MAKE) -C $(LIBCXXRT_BUILD_DIR) clean;				\
	fi
	rm -rf $(LIBCXXRT_BUILD_DIR)/Makefile
endef
