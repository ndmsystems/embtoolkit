################################################################################
# Embtoolkit
# Copyright(C) 2009-2011 Abdoulaye Walsimou GAYE.
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
# \file         uclibc.mk
# \brief	uclibc.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         August 2009
################################################################################

UCLIBC_NAME		:= uClibc
UCLIBC_VERSION		:= $(call embtk_get_pkgversion,uClibc)
UCLIBC_SITE		:= http://www.uclibc.org/downloads
UCLIBC_GIT_SITE		:= http://git.busybox.net/uClibc
UCLIBC_GIT_BRANCH	:= $(subst ",,$(strip $(CONFIG_EMBTK_UCLIBC_GIT_BRANCH)))
UCLIBC_GIT_REVISION	:= $(subst ",,$(strip $(CONFIG_EMBTK_UCLIBC_GIT_REVISION)))
UCLIBC_PACKAGE		:= uClibc-$(UCLIBC_VERSION).tar.bz2
UCLIBC_SRC_DIR		:= $(TOOLS_BUILD)/uClibc-$(UCLIBC_VERSION)
UCLIBC_BUILD_DIR	:= $(TOOLS_BUILD)/uClibc-$(UCLIBC_VERSION)

UCLIBC_DOTCONFIG	:= $(UCLIBC_BUILD_DIR)/.config

EMBTK_UCLIBC_CFLAGS	:= $(TARGET_CFLAGS) $(EMBTK_TARGET_MCPU)
EMBTK_UCLIBC_CFLAGS	+= $(EMBTK_TARGET_ABI) $(EMBTK_TARGET_FLOAT_CFLAGS)
EMBTK_UCLIBC_CFLAGS	+= $(EMBTK_TARGET_MARCH) -pipe

uclibc_install: $(UCLIBC_BUILD_DIR)/.installed
	$(call embtk_pinfo,"Successfully installed uClibc")

uclibc_headers_install: $(UCLIBC_BUILD_DIR)/.headers_installed
	$(call embtk_pinfo,"Successfully installed uClibc headers")

$(UCLIBC_BUILD_DIR)/.installed:
	$(call embtk_pinfo,"Build and install uClibc-$(UCLIBC_VERSION) ...")
	$(Q)$(MAKE) -C $(UCLIBC_BUILD_DIR) PREFIX=$(SYSROOT)/			\
		CROSS_COMPILER_PREFIX="$(TOOLS)/bin/$(STRICT_GNU_TARGET)-"	\
		SHARED_LIB_LOADER_PREFIX="/$(LIBDIR)/"				\
		MULTILIB_DIR="/$(LIBDIR)/"					\
		RUNTIME_PREFIX="/" DEVEL_PREFIX="/usr/"				\
		KERNEL_HEADERS="$(SYSROOT)/usr/include/"			\
		UCLIBC_EXTRA_CFLAGS="$(EMBTK_UCLIBC_CFLAGS)" install
	$(Q)touch $@

$(UCLIBC_BUILD_DIR)/.headers_installed: download_uclibc \
	$(UCLIBC_BUILD_DIR)/.decompressed $(UCLIBC_BUILD_DIR)/.configured
	$(call embtk_pinfo,"Install uClibc-$(UCLIBC_VERSION) headers ...")
	$(Q)$(MAKE) -C $(UCLIBC_BUILD_DIR) silentoldconfig
	$(Q)$(MAKE) -C $(UCLIBC_BUILD_DIR) PREFIX=$(SYSROOT)/			\
		CROSS_COMPILER_PREFIX="$(TOOLS)/bin/$(STRICT_GNU_TARGET)-"	\
		SHARED_LIB_LOADER_PREFIX="/$(LIBDIR)/"				\
		MULTILIB_DIR="/$(LIBDIR)/"					\
		RUNTIME_PREFIX="/" DEVEL_PREFIX="/usr/"				\
		KERNEL_HEADERS="$(SYSROOT)/usr/include/"			\
		UCLIBC_EXTRA_CFLAGS="$(EMBTK_UCLIBC_CFLAGS)" install_headers
	$(Q)$(MAKE) -C $(UCLIBC_BUILD_DIR) PREFIX=$(SYSROOT)/			\
		CROSS_COMPILER_PREFIX="$(TOOLS)/bin/$(STRICT_GNU_TARGET)-"	\
		SHARED_LIB_LOADER_PREFIX="/$(LIBDIR)/"				\
		MULTILIB_DIR="/$(LIBDIR)/"					\
		RUNTIME_PREFIX="/" DEVEL_PREFIX="/usr/"				\
		KERNEL_HEADERS="$(SYSROOT)/usr/include/"			\
		UCLIBC_EXTRA_CFLAGS="$(EMBTK_UCLIBC_CFLAGS)" install_startfiles
	$(Q)$(TOOLS)/bin/$(STRICT_GNU_TARGET)-gcc -nostdlib -nostartfiles 	\
	-shared -x c /dev/null -o $(SYSROOT)/usr/$(LIBDIR)/libc.so
	$(Q)touch $@

download_uclibc download_uclibc_headers:
ifeq ($(CONFIG_EMBTK_UCLIBC_VERSION_GIT),y)
	$(call embtk_pinfo,"downloading uClibc using GIT")
	@test -e $(EMBTK_ROOT)/src/uClibc-git || \
	git clone $(UCLIBC_GIT_SITE) $(EMBTK_ROOT)/src/uClibc-git
ifneq ($(UCLIBC_GIT_BRANCH),master)
	@-cd $(EMBTK_ROOT)/src/uClibc-git; \
	git checkout master; \
	git pull; \
	git branch -D $(UCLIBC_GIT_BRANCH); \
	git checkout -b $(UCLIBC_GIT_BRANCH) origin/$(UCLIBC_GIT_BRANCH)
endif
	@cd $(EMBTK_ROOT)/src/uClibc-git; \
	git pull; git archive \
	--prefix=uClibc-$(UCLIBC_VERSION)/ $(UCLIBC_GIT_REVISION) | \
	bzip2 -9 > $(DOWNLOAD_DIR)/$(UCLIBC_PACKAGE)
else
	$(call embtk_download_pkg,uClibc)
endif

$(UCLIBC_BUILD_DIR)/.decompressed:
	$(call embtk_decompress_pkg,uClibc)

#
# uClibc configuration macros and target
#
__embtk_get_uclibc_config=grep "CONFIG_KEMBTK_UCLIBC_" $(EMBTK_DOTCONFIG)
__embtk_set_uclibc_config=sed -e 's/CONFIG_KEMBTK_UCLIBC_*//g' > $(UCLIBC_DOTCONFIG)
define embtk_configure_uclibc
	$(shell  $(__embtk_get_uclibc_config) | $(__embtk_set_uclibc_config))
endef
$(UCLIBC_BUILD_DIR)/.configured:
	$(call embtk_pinfo,"Configure uClibc-$(UCLIBC_VERSION) ...")
	$(Q)$(call embtk_configure_uclibc)
