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
# \file         llvm.mk
# \brief	llvm.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         October 2012
################################################################################

LLVM_HOST_NAME		:= llvm
LLVM_HOST_VERSION	:= $(call embtk_pkg_version,llvm_host)
LLVM_HOST_SITE		:= http://llvm.org/releases/$(LLVM_HOST_VERSION)
#LLVM_HOST_GIT_SITE	:= http://llvm.org/git/llvm.git
LLVM_HOST_GIT_SITE	:= git://www.embtoolkit.org/llvm.git
LLVM_HOST_PACKAGE	:= llvm-$(LLVM_HOST_VERSION).src.tar.xz
LLVM_HOST_SRC_DIR	:= $(embtk_toolsb)/llvm-$(LLVM_HOST_VERSION).src
LLVM_HOST_BUILD_DIR	:= $(embtk_toolsb)/llvm-$(LLVM_HOST_VERSION)-build

LLVM_HOST_DEPS			:= clang_host_install

LLVM_HOST_WITH_HASHSTYLE	:= $(if $(CONFIG_EMBTK_CLIB_UCLIBC),--with-default-hash-style=sysv)

__embtk_binutils_inc		:= $(call __embtk_pkg_srcdir,binutils)/include

LLVM_HOST_CONFIGURE_OPTS	:= --target=$(STRICT_GNU_TARGET)
LLVM_HOST_CONFIGURE_OPTS	+= --enable-targets=$(LINUX_ARCH),x86
LLVM_HOST_CONFIGURE_OPTS	+= $(LLVM_HOST_WITH_CPU) $(LLVM_HOST_WITH_ABI)
LLVM_HOST_CONFIGURE_OPTS	+= $(LLVM_HOST_WITH_FLOAT) $(LLVM_HOST_WITH_FPU)
LLVM_HOST_CONFIGURE_OPTS	+= $(LLVM_HOST_WITH_HASHSTYLE)
LLVM_HOST_CONFIGURE_OPTS	+= --with-default-sysroot=$(embtk_sysroot)
LLVM_HOST_CONFIGURE_OPTS	+= --enable-optimized --disable-jit --disable-zlib
LLVM_HOST_CONFIGURE_OPTS	+= --with-bug-report-url=$(EMBTK_BUGURL)
LLVM_HOST_CONFIGURE_OPTS	+= --with-binutils-include=$(__embtk_binutils_inc)

LLVM_HOST_MAKE_OPTS		:= NO_UNITTESTS=1
LLVM_HOST_MAKE_OPTS		+= CLANG_VENDOR="EmbToolkit [v$(EMBTK_VERSION)]"

LLVM_HOST_PREFIX		:= $(embtk_tools)

__embtk_clang_arch	:= $(firstword $(subst -, ,$(STRICT_GNU_TARGET)))
__embtk_clang_rversion	= `ls $(embtk_tools)/lib/clang/`
__embtk_clang_libdir	= $(embtk_tools)/lib/clang/$(__embtk_clang_rversion)/lib/linux
__embtk_clang_incdir	= $(embtk_tools)/lib/clang/$(__embtk_clang_rversion)/include

define embtk_beforeinstall_llvm_host
	[ -e $(call __embtk_pkg_srcdir,llvm_host)/tools/clang ] ||		\
		ln -sf $(call __embtk_pkg_srcdir,clang_host)			\
			$(call __embtk_pkg_srcdir,llvm_host)/tools/clang
	mkdir -p $(embtk_tools)/bin/clang-scan-build
	cp -R $(call __embtk_pkg_srcdir,llvm_host)/tools/clang/tools/scan-build/* \
		$(embtk_tools)/bin/clang-scan-build
	mkdir -p $(embtk_tools)/bin/clang-scan-view
	cp -R $(call __embtk_pkg_srcdir,llvm_host)/tools/clang/tools/scan-view/* \
		$(embtk_tools)/bin/clang-scan-view
endef

define embtk_postinstallonce_llvm_host
	mkdir -p $(embtk_tools)/lib/bfd-plugins
	cd $(embtk_tools)/lib/bfd-plugins;					\
		ln -sf ../libLTO.so libLTO.so;					\
		ln -sf ../LLVMgold.so LLVMgold.so
	mkdir -p $(embtk_tools)/lib/clang/$(__embtk_clang_rversion)/lib
	mkdir -p $(embtk_tools)/lib/clang/$(__embtk_clang_rversion)/lib/linux
endef

define embtk_cleanup_llvm_host
	$(Q)rm -rf $(LLVM_HOST_BUILD_DIR)
endef
