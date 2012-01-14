################################################################################
# Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
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
# \file         toolchain.mk
# \brief	toolchain.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

TARGETCC		:= $(TOOLS)/bin/$(STRICT_GNU_TARGET)-gcc
TARGETCXX		:= $(TOOLS)/bin/$(STRICT_GNU_TARGET)-g++
TARGETAR		:= $(TOOLS)/bin/$(STRICT_GNU_TARGET)-ar
TARGETRANLIB		:= $(TOOLS)/bin/$(STRICT_GNU_TARGET)-ranlib
TARGETLD		:= $(TOOLS)/bin/$(STRICT_GNU_TARGET)-ld
TARGETNM		:= $(TOOLS)/bin/$(STRICT_GNU_TARGET)-nm
TARGETSTRIP		:= $(TOOLS)/bin/$(STRICT_GNU_TARGET)-strip
TARGETOBJDUMP		:= $(TOOLS)/bin/$(STRICT_GNU_TARGET)-objdump
TARGETOBJCOPY		:= $(TOOLS)/bin/$(STRICT_GNU_TARGET)-objcopy
__TARGET_CFLAGS		:= $(subst ",,$(strip $(CONFIG_EMBTK_TARGET_COMPILER_CFLAGS)))
__TARGET_CFLAGS		+= $(if $(CONFIG_EMBTK_TARGET_SIZE_OPTIMIZED),-Os)
__TARGET_CFLAGS		+= $(if $(CONFIG_EMBTK_TARGET_SPEED_OPTIMIZED),-O3)
__TARGET_CFLAGS		+= $(if $(CONFIG_EMBTK_TARGET_WITH_DEBUG_DATA),-g)
TARGET_CFLAGS		:= $(strip $(__TARGET_CFLAGS))
CROSS_COMPILE		:= $(TOOLS)/bin/$(STRICT_GNU_TARGET)-

export TARGETCC TARGETCXX TARGETAR TARGETRANLIB TARGETLD TARGETNM
export TARGETSTRIP TARGETOBJDUMP TARGETOBJCOPY TARGET_CFLAGS CROSS_COMPILE

ac_cv_func_malloc_0_nonnull=yes
export ac_cv_func_malloc_0_nonnull
ac_cv_func_realloc_0_nonnull=yes
export ac_cv_func_realloc_0_nonnull

PATH			:= $(HOSTTOOLS)/usr/bin:$(HOSTTOOLS)/usr/sbin:$(PATH)
export PATH

LIBDIR			:= $(if $(CONFIG_EMBTK_64BITS_FS_COMPAT32),lib32,lib)
export LIBDIR

#ccache on host
include $(EMBTK_ROOT)/mk/ccache.mk

#GMP on host
include $(EMBTK_ROOT)/mk/gmp.mk

#MPFR
include $(EMBTK_ROOT)/mk/mpfr.mk

#MPC
include $(EMBTK_ROOT)/mk/mpc.mk

#binutils
include $(EMBTK_ROOT)/mk/binutils.mk

#GCC
include $(EMBTK_ROOT)/mk/gcc.mk

#linux kernel headers
include $(EMBTK_ROOT)/mk/linux.mk

#Autotools
include $(EMBTK_ROOT)/mk/libtool.mk
include $(EMBTK_ROOT)/mk/autoconf.mk
include $(EMBTK_ROOT)/mk/automake.mk
include $(EMBTK_ROOT)/mk/m4.mk
AUTOTOOLS_INSTALL	:= m4_install libtool_install autoconf_install
AUTOTOOLS_INSTALL	+= automake_install

#cmake
include $(EMBTK_ROOT)/mk/cmake.mk
EMBTK_CMAKE_INSTALL	:= $(if $(CONFIG_EMBTK_HOST_HAVE_CMAKE),cmake_install)

TOOLCHAIN_NAME		:= toolchain
TOOLCHAIN_PACKAGE	:= toolchain-$(GNU_TARGET)-$(EMBTK_MCU_FLAG).tar.bz2
TOOLCHAIN_DIR		:= $(EMBTK_GENERATED)/toolchain-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)
TOOLCHAIN_BUILD_DIR	:= $(TOOLCHAIN_DIR)

TOOLCHAIN_CLIB		:= $(if $(CONFIG_EMBTK_CLIB_EGLIBC),eglibc,uclibc)
TOOLCHAIN_PRE_DEPS	:= mkinitialpath ccache_install $(AUTOTOOLS_INSTALL)
TOOLCHAIN_PRE_DEPS	+= $(EMBTK_CMAKE_INSTALL)

TOOLCHAIN_DEPS		:= linux_headers_install gmp_host_install
TOOLCHAIN_DEPS		+= mpfr_host_install mpc_host_install binutils_install
TOOLCHAIN_DEPS		+= gcc1_install $(TOOLCHAIN_CLIB)_headers_install
TOOLCHAIN_DEPS		+= gcc2_install $(TOOLCHAIN_CLIB)_install gcc3_install

include $(EMBTK_ROOT)/mk/$(TOOLCHAIN_CLIB).mk

define __embtk_toolchain_symlinktools
	cd $(TOOLS)/bin;							\
	tools=$$(ls $(STRICT_GNU_TARGET)-*);					\
	toolsnames=$$(echo $$tools | sed 's/$(STRICT_GNU_TARGET)-*//g');	\
	for tool in $$toolsnames; do						\
		ln -sf $(STRICT_GNU_TARGET)-$$tool $(GNU_TARGET)-$$tool;	\
	done
endef

define __embtk_toolchain_compress
	tar -cjf $(TOOLCHAIN_PACKAGE)						\
		$(notdir $(SYSROOT)) $(notdir $(TOOLS)) &&			\
	mv $(TOOLCHAIN_PACKAGE) $(TOOLCHAIN_DIR)/$(TOOLCHAIN_PACKAGE)
endef

define __embtk_toolchain_decompress
	$(call embtk_pinfo,"Decompressing $(GNU_TARGET)/$(EMBTK_MCU_FLAG) toolchain - please wait...")
	cd $(EMBTK_ROOT) && tar xjf $(TOOLCHAIN_DIR)/$(TOOLCHAIN_PACKAGE)
	$(MAKE) $(TOOLCHAIN_PRE_DEPS)
	mkdir -p $(GCC3_BUILD_DIR)
	touch $(GCC3_BUILD_DIR)/.installed
	touch $(GCC3_BUILD_DIR)/.gcc3_post_install
	$(MAKE) __embtk_gcc3_printmetakconfigs > 				\
					$(call __embtk_pkg_dotpkgkconfig_f,gcc3)
endef

define __embtk_toolchain_build
	$(call embtk_pinfo,"Building new $(GNU_TARGET)/$(EMBTK_MCU_FLAG) toolchain - please wait...")
	$(foreach dep,$(patsubst %_install,%,$(TOOLCHAIN_DEPS)),		\
				rm -rf $(call __embtk_pkg_builddir,$(dep));)
	$(foreach pkg,$(__embtk_rootfs_packages),$(MAKE) $(pkg)_clean;)
	rm -rf $(SYSROOT)
	$(__embtk_mk_initsysrootdirs)
	$(MAKE) $(TOOLCHAIN_PRE_DEPS) $(TOOLCHAIN_DEPS)
	$(__embtk_toolchain_symlinktools)
	$(__embtk_toolchain_compress)
	touch $(TOOLCHAIN_DIR)/.installed
	$(call embtk_pinfo,"New $(GNU_TARGET)/$(EMBTK_MCU_FLAG) toolchain successfully built!")
endef

buildtoolchain:
	$(Q)$(if $(call __embtk_pkg_installed-y,toolchain),			\
		$(__embtk_toolchain_decompress),$(__embtk_toolchain_build))

# Download target for offline build
packages_fetch:: $(patsubst %_install,download_%,$(TOOLCHAINBUILD))
