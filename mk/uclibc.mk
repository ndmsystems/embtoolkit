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

UCLIBC_HEADERS_NAME		:= uClibc_headers
UCLIBC_HEADERS_VERSION		:= $(UCLIBC_VERSION)
UCLIBC_HEADERS_SITE		:= $(UCLIBC_SITE)
UCLIBC_HEADERS_GIT_SITE		:= $(UCLIBC_GIT_SITE)
UCLIBC_HEADERS_PACKAGE		:= $(UCLIBC_PACKAGE)
UCLIBC_HEADERS_SRC_DIR		:= $(UCLIBC_SRC_DIR)
UCLIBC_HEADERS_BUILD_DIR	:= $(UCLIBC_BUILD_DIR)
UCLIBC_HEADERS_KCONFIGS_NAME	:= UCLIBC

UCLIBC_DOTCONFIG	:= $(UCLIBC_BUILD_DIR)/.config
EMBTK_UCLIBC_CFLAGS	:= $(filter-out $(__clang_cflags),$(TARGET_CFLAGS))
EMBTK_UCLIBC_CFLAGS	+= $(EMBTK_TARGET_MCPU)
EMBTK_UCLIBC_CFLAGS	+= $(EMBTK_TARGET_ABI) $(EMBTK_TARGET_FLOAT_CFLAGS)
EMBTK_UCLIBC_CFLAGS	+= $(EMBTK_TARGET_MARCH) -pipe

#
# uClibc libraries make options.
#
UCLIBC_MAKE_OPTS	:= PREFIX="$(embtk_sysroot)/"
UCLIBC_MAKE_OPTS	+= CROSS_COMPILER_PREFIX="$(CROSS_COMPILE)"
UCLIBC_MAKE_OPTS	+= SHARED_LIB_LOADER_PREFIX="/$(LIBDIR)/"
UCLIBC_MAKE_OPTS	+= RUNTIME_PREFIX="/" DEVEL_PREFIX="/usr/"
UCLIBC_MAKE_OPTS	+= KERNEL_HEADERS="$(embtk_sysroot)/usr/include/"
UCLIBC_MAKE_OPTS	+= UCLIBC_EXTRA_CFLAGS="$(EMBTK_UCLIBC_CFLAGS)"

#
# uClibc libraries install
#
define embtk_install_uclibc
	$(call embtk_makeinstall_pkg,uclibc)
endef

#
# Uclibc headers install
#
define __embtk_install_uclibc_headers
	$(call embtk_pinfo,"Install uClibc-$(UCLIBC_VERSION) headers ...")
	$(call embtk_download_pkg,uClibc)
	$(call embtk_decompress_pkg,uClibc)
	$(MAKE) -C $(UCLIBC_BUILD_DIR) distclean
	$(embtk_configure_uclibc)
	$(MAKE) -C $(UCLIBC_BUILD_DIR) silentoldconfig
	$(MAKE) -C $(UCLIBC_BUILD_DIR) $(UCLIBC_MAKE_OPTS) install_headers
	$(MAKE) -C $(UCLIBC_BUILD_DIR) $(UCLIBC_MAKE_OPTS) install_startfiles
	$(MAKE) -C $(UCLIBC_BUILD_DIR) $(UCLIBC_MAKE_OPTS) install_startfiles
	$(TARGETGCC) -nostdlib -nostartfiles -shared -x c /dev/null		\
				-o $(embtk_sysroot)/usr/$(LIBDIR)/libc.so
	touch $(call __embtk_pkg_dotinstalled_f,uclibc_headers)
endef

define embtk_install_uclibc_headers
	[ -e $(call __embtk_pkg_dotinstalled_f,uclibc_headers) ] ||		\
		$(__embtk_install_uclibc_headers)
endef

#
# Clean up macros
#
define __embtk_cleanup_uclibc
	($(MAKE) -C $(UCLIBC_BUILD_DIR) distclean &&				\
	rm -rf $(call __embtk_pkg_dotinstalled_f,uclibc) &&			\
	rm -rf $(call __embtk_pkg_dotinstalled_f,uclibc_headers))
endef
define embtk_cleanup_uclibc
	if [ -d $(UCLIBC_BUILD_DIR) ]						\
		&& [ -e $(UCLIBC_BUILD_DIR)/Makefile ]; then			\
		$(__embtk_cleanup_uclibc)					\
	fi
endef

define embtk_cleanup_uclibc_headers
	$(embtk_cleanup_uclibc)
endef

#
# uClibc configuration macros and target
#
__embtk_get_uclibc_config=grep "CONFIG_KEMBTK_UCLIBC_" $(EMBTK_DOTCONFIG)
__embtk_set_uclibc_config=sed -e 's/CONFIG_KEMBTK_UCLIBC_*//g' > $(UCLIBC_DOTCONFIG)
define embtk_configure_uclibc
	$(call embtk_pinfo,"Configure uClibc")
	$(__embtk_get_uclibc_config) | $(__embtk_set_uclibc_config)
endef

#
# downloads
#
download_uclibc download_uclibc_headers:
	$(call embtk_download_pkg,uclibc)
