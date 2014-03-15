################################################################################
# Embtoolkit
# Copyright(C) 2012-2013 Abdoulaye Walsimou GAYE <awg@embtoolkit.org>.
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
# \file         compiler-rt.mk
# \brief	compiler-rt.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         October 2012
################################################################################

COMPILER-RT_NAME	:= compiler-rt
COMPILER-RT_VERSION	:= $(call embtk_get_pkgversion,compiler-rt)
COMPILER-RT_SITE	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
#COMPILER-RT_GIT_SITE	:= http://llvm.org/git/compiler-rt.git
COMPILER-RT_GIT_SITE	:= git://www.embtoolkit.org/compiler-rt.git
COMPILER-RT_PACKAGE	:= compiler-rt-$(COMPILER-RT_VERSION).tar.bz2
COMPILER-RT_SRC_DIR	:= $(embtk_toolsb)/compiler-rt-$(COMPILER-RT_VERSION)
COMPILER-RT_BUILD_DIR	:= $(call __embtk_pkg_srcdir,compiler-rt)

__embtk_compiler-rt_cflags	:= $(TARGET_CFLAGS)
#
# FIXME: remove this when c++ exceptions handling fully supported in ARM
#
ifeq ($(TARGETCXX),$(TARGETGCXX))
__embtk_compiler-rt_cflags	:= $(filter-out $(__clang_cflags),$(__embtk_compiler-rt_cflags))
endif

ifeq ($(CONFIG_EMBTK_CLANG_VERSION_3_3),y)
__embtk_compiler-rt_cflags += -DASAN_INTERFACE_VERSION=3
endif

ifeq ($(CONFIG_EMBTK_CLIB_MUSL),y)
__embtk_compiler-rt_cflags += -D_FILE_OFFSET_BITS=64 -D__MUSL__
endif

COMPILER-RT_MAKE_OPTS	:= CC="$(TARGETCC)" CFLAGS="$(__embtk_compiler-rt_cflags)"
COMPILER-RT_MAKE_OPTS	+= CXX="$(TARGETCXX)" LIBDIR="$(LIBDIR)"
COMPILER-RT_MAKE_OPTS	+= AR=$(TARGETAR) RANLIB=$(TARGETRANLIB)
COMPILER-RT_MAKE_OPTS	+= SYSROOT="$(embtk_sysroot)"

define embtk_install_compiler-rt
	$(call embtk_makeinstall_pkg,compiler-rt)
endef

define embtk_beforeinstall_compiler-rt
	ln -sf $(EMBTK_ROOT)/mk/llvm/compiler-rt/Makefile			\
					$(COMPILER-RT_BUILD_DIR)/Makefile
endef

__embtk_libasan			:= libclang_rt.asan-$(__embtk_clang_arch).a
__embtk_libubsan		:= libclang_rt.ubsan-$(__embtk_clang_arch).a
define embtk_postinstallonce_compiler-rt
	echo "GROUP(libasan.a libsanitizer_common.a)"				\
				> $(__embtk_clang_libdir)/$(__embtk_libasan)
	echo "GROUP(libubsan.a libsanitizer_common.a)"				\
				> $(__embtk_clang_libdir)/$(__embtk_libubsan)
	cp -R $(call __embtk_pkg_srcdir,compiler-rt)/include/*			\
				$(__embtk_clang_incdir)/
endef

define embtk_cleanup_compiler-rt
	if [ -e $(COMPILER-RT_BUILD_DIR)/Makefile ]; then			\
		$(MAKE) -C $(COMPILER-RT_BUILD_DIR) clean;			\
	fi
	rm -rf $(COMPILER-RT_BUILD_DIR)/Makefile
endef
