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
UCLIBC_GIT_SITE		:= git://git.busybox.net/uClibc
UCLIBC_PACKAGE		:= uClibc-$(UCLIBC_VERSION).tar.bz2
UCLIBC_SRC_DIR		:= $(embtk_toolsb)/uClibc-$(UCLIBC_VERSION)
UCLIBC_BUILD_DIR	:= $(call __embtk_pkg_srcdir,uClibc)

UCLIBC_DOTCONFIG	:= $(UCLIBC_BUILD_DIR)/.config

EMBTK_UCLIBC_CFLAGS	:= $(TARGET_CFLAGS) $(EMBTK_TARGET_MCPU)
EMBTK_UCLIBC_CFLAGS	+= $(EMBTK_TARGET_ABI) $(EMBTK_TARGET_FLOAT_CFLAGS)
EMBTK_UCLIBC_CFLAGS	+= $(EMBTK_TARGET_MARCH) -pipe

uclibc_install:
	$(Q)test -e $(UCLIBC_BUILD_DIR)/.installed ||				\
				$(MAKE) $(UCLIBC_BUILD_DIR)/.installed

uclibc_headers_install:
	$(Q)test -e $(UCLIBC_BUILD_DIR)/.headers_installed ||			\
				$(MAKE) $(UCLIBC_BUILD_DIR)/.headers_installed

$(UCLIBC_BUILD_DIR)/.installed:
	$(call embtk_pinfo,"Build and install uClibc-$(UCLIBC_VERSION) ...")
	$(Q)$(MAKE) -C $(UCLIBC_BUILD_DIR) PREFIX=$(embtk_sysroot)/			\
		CROSS_COMPILER_PREFIX="$(embtk_tools)/bin/$(STRICT_GNU_TARGET)-"	\
		SHARED_LIB_LOADER_PREFIX="/$(LIBDIR)/"				\
		MULTILIB_DIR="/$(LIBDIR)/"					\
		RUNTIME_PREFIX="/" DEVEL_PREFIX="/usr/"				\
		KERNEL_HEADERS="$(embtk_sysroot)/usr/include/"			\
		UCLIBC_EXTRA_CFLAGS="$(EMBTK_UCLIBC_CFLAGS)" install
	$(Q)touch $@

$(UCLIBC_BUILD_DIR)/.headers_installed:
	$(call embtk_pinfo,"Install uClibc-$(UCLIBC_VERSION) headers ...")
	$(call embtk_download_pkg,uClibc)
	$(call embtk_decompress_pkg,uClibc)
	$(Q)$(MAKE) -C $(UCLIBC_BUILD_DIR) distclean
	$(Q)$(embtk_configure_uclibc)
	$(Q)$(MAKE) -C $(UCLIBC_BUILD_DIR) silentoldconfig
	$(Q)$(MAKE) -C $(UCLIBC_BUILD_DIR) PREFIX=$(embtk_sysroot)/			\
		CROSS_COMPILER_PREFIX="$(embtk_tools)/bin/$(STRICT_GNU_TARGET)-"	\
		SHARED_LIB_LOADER_PREFIX="/$(LIBDIR)/"				\
		MULTILIB_DIR="/$(LIBDIR)/"					\
		RUNTIME_PREFIX="/" DEVEL_PREFIX="/usr/"				\
		KERNEL_HEADERS="$(embtk_sysroot)/usr/include/"			\
		UCLIBC_EXTRA_CFLAGS="$(EMBTK_UCLIBC_CFLAGS)" install_headers
	$(Q)$(MAKE) -C $(UCLIBC_BUILD_DIR) PREFIX=$(embtk_sysroot)/			\
		CROSS_COMPILER_PREFIX="$(embtk_tools)/bin/$(STRICT_GNU_TARGET)-"	\
		SHARED_LIB_LOADER_PREFIX="/$(LIBDIR)/"				\
		MULTILIB_DIR="/$(LIBDIR)/"					\
		RUNTIME_PREFIX="/" DEVEL_PREFIX="/usr/"				\
		KERNEL_HEADERS="$(embtk_sysroot)/usr/include/"			\
		UCLIBC_EXTRA_CFLAGS="$(EMBTK_UCLIBC_CFLAGS)" install_startfiles
	$(Q)$(TARGETCC) -nostdlib -nostartfiles -shared -x c /dev/null		\
					-o $(embtk_sysroot)/usr/$(LIBDIR)/libc.so
	$(Q)touch $@

download_uclibc_headers:
	$(call embtk_download_pkg,uClibc)

define embtk_uclibc_clean
	if [ -d $(UCLIBC_BUILD_DIR) ]; then					\
		$(MAKE) -C $(UCLIBC_BUILD_DIR) distclean;			\
		rm -rf $(UCLIBC_BUILD_DIR)/.installed;				\
		rm -rf $(UCLIBC_BUILD_DIR)/.headers_installed;			\
	fi
endef

uclibc_clean uclibc_headers_clean:
	$(Q)$(embtk_uclibc_clean)
#
# uClibc configuration macros and target
#
__embtk_get_uclibc_config=grep "CONFIG_KEMBTK_UCLIBC_" $(EMBTK_DOTCONFIG)
__embtk_set_uclibc_config=sed -e 's/CONFIG_KEMBTK_UCLIBC_*//g' > $(UCLIBC_DOTCONFIG)
define embtk_configure_uclibc
	$(call embtk_pinfo,"Configure uClibc")
	$(__embtk_get_uclibc_config) | $(__embtk_set_uclibc_config)
endef
