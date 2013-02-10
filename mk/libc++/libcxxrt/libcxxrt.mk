################################################################################
# Embtoolkit
# Copyright(C) 2012 Abdoulaye Walsimou GAYE <awg@embtoolkit.org>.
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
# \file         libcxxrt.mk
# \brief	libcxxrt.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2012
################################################################################

LIBCXXRT_NAME		:= libcxxrt
LIBCXXRT_VERSION	:= $(call embtk_get_pkgversion,libcxxrt)
LIBCXXRT_SITE		:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror/$(LIBCXXRT_VERSION)
#LIBCXXRT_GIT_SITE	:= git://github.com/pathscale/libcxxrt.git
LIBCXXRT_GIT_SITE	:= git://www.embtoolkit.org/libcxxrt.git
LIBCXXRT_PACKAGE	:= libcxxrt-$(LIBCXXRT_VERSION).tar.bz2
LIBCXXRT_SRC_DIR	:= $(embtk_toolsb)/libcxxrt-$(LIBCXXRT_VERSION)
LIBCXXRT_BUILD_DIR	:= $(call __embtk_pkg_srcdir,libcxxrt)

__embtk_libcxxrt_cflags	:= $(TARGET_CFLAGS)

LIBCXXRT_MAKE_OPTS	:= CC="$(TARGETCC)" CFLAGS="$(__embtk_libcxxrt_cflags)"
LIBCXXRT_MAKE_OPTS	+= CXX="$(TARGETCXX)" LIBDIR=$(LIBDIR)
LIBCXXRT_MAKE_OPTS	+= AR=$(TARGETAR) RANLIB=$(TARGETRANLIB)
LIBCXXRT_MAKE_OPTS	+= SYSROOT="$(embtk_sysroot)"

define embtk_install_libcxxrt
	$(call embtk_makeinstall_pkg,libcxxrt)
endef

define embtk_beforeinstall_libcxxrt
	ln -sf $(EMBTK_ROOT)/mk/libc++/libcxxrt/Makefile			\
					$(LIBCXXRT_BUILD_DIR)/Makefile
endef

define embtk_cleanup_libcxxrt
	if [ -e $(LIBCXXRT_BUILD_DIR)/Makefile ]; then				\
		$(MAKE) -C $(LIBCXXRT_BUILD_DIR) clean;				\
	fi
	rm -rf $(LIBCXXRT_BUILD_DIR)/Makefile
endef
