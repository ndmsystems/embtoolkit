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
# \file         llvm.mk
# \brief	llvm.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         October 2012
################################################################################

LLVM_NAME		:= llvm
LLVM_VERSION		:= $(call embtk_get_pkgversion,llvm)
LLVM_SITE		:= http://llvm.org/releases/$(LLVM_VERSION)
#LLVM_GIT_SITE		:= http://llvm.org/git/llvm.git
LLVM_GIT_SITE		:= git://www.embtoolkit.org/llvm.git
LLVM_PACKAGE		:= llvm-$(LLVM_VERSION).src.tar.gz
LLVM_SRC_DIR		:= $(embtk_toolsb)/llvm-$(LLVM_VERSION).src
LLVM_BUILD_DIR		:= $(embtk_toolsb)/llvm-build

LLVM_DEPS		:= binutils_install clang_install

LLVM_WITH_HASHSTYLE	:= $(if $(CONFIG_EMBTK_CLIB_UCLIBC),--with-default-hash-style=sysv)

__embtk_binutils_inc	:= $(call __embtk_pkg_srcdir,binutils)/include
LLVM_CONFIGURE_OPTS	:= --target=$(STRICT_GNU_TARGET)
LLVM_CONFIGURE_OPTS	+= --enable-targets=$(LINUX_ARCH)
LLVM_CONFIGURE_OPTS	+= --with-default-cpu=$(EMBTK_MCU_FLAG)
LLVM_CONFIGURE_OPTS	+= $(LLVM_WITH_FLOAT) $(LLVM_WITH_FPU)
LLVM_CONFIGURE_OPTS	+= $(LLVM_WITH_HASHSTYLE)
LLVM_CONFIGURE_OPTS	+= --with-default-sysroot=$(embtk_sysroot)
LLVM_CONFIGURE_OPTS	+= --enable-optimized
LLVM_CONFIGURE_OPTS	+= --with-bug-report-url=$(EMBTK_BUGURL)
LLVM_CONFIGURE_OPTS	+= --with-binutils-include=$(__embtk_binutils_inc)

LLVM_PREFIX		:= $(embtk_tools)

define embtk_install_llvm
	$(call __embtk_install_hostpkg,llvm)
endef

define embtk_beforeinstall_llvm
	[ -e $(call __embtk_pkg_srcdir,llvm)/tools/clang ] ||			\
		ln -sf $(call __embtk_pkg_srcdir,clang)				\
				$(call __embtk_pkg_srcdir,llvm)/tools/clang
endef

define embtk_postinstall_llvm
	mkdir -p $(embtk_tools)/lib/bfd-plugins
	cd $(embtk_tools)/lib/bfd-plugins;					\
		ln -sf ../libLTO.so libLTO.so;					\
		ln -sf ../LLVMgold.so LLVMgold.so
endef

define embtk_cleanup_llvm
	$(Q)rm -rf $(LLVM_BUILD_DIR)
endef
