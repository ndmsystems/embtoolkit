#################################################################################
# Embtoolkit
# Copyright(C) 2009-2014 Abdoulaye Walsimou GAYE.
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
# \file         linux.mk
# \brief	linux.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

__LINUX_SITE_BASE	= http://ftp.kernel.org/pub/linux/kernel
__LINUX_SITE_LONGTERM	= $(strip $(if $(LINUX_LONGTERMV),			\
					/longterm/$(LINUX_LONGTERMV)))
__LINUX_SITE		= $(strip $(if $(CONFIG_EMBTK_LINUX_HAVE_MIRROR),	\
	$(patsubst '"',,$(strip $(CONFIG_EMBTK_LINUX_HAVE_MIRROR_SITE))),	\
	$(__LINUX_SITE_BASE)/$(LINUX_MAJORV)$(__LINUX_SITE_LONGTERM)))

LINUX_NAME		:= linux
LINUX_MAJORV		:= $(call embtk_get_pkgversion,linux_major)
LINUX_LONGTERMV		:= $(call embtk_get_pkgversion,linux_longterm)
LINUX_VERSION		:= $(call embtk_get_pkgversion,linux)
LINUX_SITE		:= $(call __LINUX_SITE)
LINUX_PACKAGE		:= linux-$(LINUX_VERSION).tar.bz2
LINUX_SRC_DIR		:= $(embtk_toolsb)/linux-$(LINUX_VERSION)
LINUX_BUILD_DIR		:= $(embtk_toolsb)/linux-$(LINUX_VERSION)
LINUX_KEEP_SRC_DIR	:= y

LINUX_HEADERS_NAME	:= linux_headers
LINUX_HEADERS_VERSION	:= $(LINUX_VERSION)
LINUX_HEADERS_SITE	:= $(LINUX_SITE)
LINUX_HEADERS_PACKAGE	:= $(LINUX_PACKAGE)
LINUX_HEADERS_SRC_DIR	:= $(LINUX_SRC_DIR)
LINUX_HEADERS_BUILD_DIR	:= $(LINUX_BUILD_DIR)
LINUX_HEADERS_KCONFIGS_NAME	:= LINUX
LINUX_HEADERS_KEEP_SRC_DIR	:= y

LINUX_MAKE_OPTS	:= quiet=quiet_
LINUX_MAKE_OPTS	+= ARCH=$(LINUX_ARCH)
LINUX_MAKE_OPTS	+= CROSS_COMPILE=$(CROSS_COMPILE_CACHED)

define __embtk_install_linux_headers
	$(call embtk_pinfo,"Installing linux-$(LINUX_VERSION) headers...")
	$(call embtk_download_pkg,linux)
	$(call embtk_decompress_pkg,linux)
	$(MAKE) -C $(LINUX_BUILD_DIR) $(LINUX_MAKE_OPTS)			\
		INSTALL_HDR_PATH=$(embtk_sysroot)/usr headers_install
	$(call __embtk_setinstalled_pkg,linux_headers)
	$(call __embtk_pkg_gen_dotkconfig_f,linux_headers)
endef
define embtk_install_linux_headers
	$(if $(call __embtk_pkg_installed-y,linux_headers),,
		$(__embtk_install_linux_headers))
endef

#
# linux install macros
#

__embtk_linux_dotconfig_f	:= $(call __embtk_mk_uquote,$(CONFIG_EMBTK_LINUX_DOTCONFIG))
__embtk_linux_srcdir		:= $(call __embtk_mk_uquote,$(or $(CONFIG_EMBTK_LINUX_BUILD_EXTSRC),$(LINUX_SRC_DIR)))
__embtk_linux_support_modules	:= $(shell grep MODULES=y "$(__embtk_linux_dotconfig_f)" 2>/dev/null)

define __embtk_install_linux_check_config
	if [ "x" = "x$(__embtk_linux_dotconfig_f)" ]; then			\
	$(call embtk_perror,"Unable to build linux kernel image: no config file");\
	exit 1;									\
	fi
	if [ ! -e $(__embtk_linux_dotconfig_f) ]; then				\
	$(call embtk_perror,"Unable to build linux kernel image: config file $(__embtk_linux_dotconfig_f) not found");\
	exit 1;									\
	fi
endef

define __embtk_install_linux_check_extsrc
	if [ "x" = "x$(__embtk_linux_srcdir)" ]; then				\
	$(call embtk_perror,"Unable to build linux kernel image: External source tree not specified");\
	exit 1;									\
	fi
	if [ ! -d $(__embtk_linux_srcdir) ]; then				\
	$(call embtk_perror,"Unable to build linux kernel image: External source tree $(__embtk_linux_srcdir) not found");\
	exit 1;									\
	fi
endef

define __embtk_install_linux
	$(call embtk_pinfo,"Generating linux kernel image...")
	$(__embtk_install_linux_check_config)
	$(if $(CONFIG_EMBTK_LINUX_BUILD_USE_EXTSRC),
		$(__embtk_install_linux_check_extsrc))
	$(if $(CONFIG_EMBTK_LINUX_BUILD_TOOLCHAIN_SRC),
		$(call embtk_download_pkg,linux)
		$(call embtk_decompress_pkg,linux))
	$(MAKE) -C $(__embtk_linux_srcdir) $(LINUX_MAKE_OPTS) distclean
	cp $(CONFIG_EMBTK_LINUX_DOTCONFIG) $(__embtk_linux_srcdir)/.config
	$(MAKE) -C $(__embtk_linux_srcdir) $(LINUX_MAKE_OPTS) silentoldconfig
	$(MAKE) -C $(__embtk_linux_srcdir) $(LINUX_MAKE_OPTS) $(J)
	$(call __embtk_setinstalled_pkg,linux)
	$(call __embtk_pkg_gen_dotkconfig_f,linux)
endef

define embtk_install_linux
	$(if $(call __embtk_pkg_installed-y,linux),true,$(__embtk_install_linux))
	$(if $(__embtk_linux_support_modules),$(embtk_postinstall_linux))
endef

define embtk_postinstall_linux
	$(call embtk_pinfo,"Install linux kernel modules...")
	$(MAKE) -C $(__embtk_linux_srcdir) $(LINUX_MAKE_OPTS)			\
		INSTALL_MOD_PATH=$(embtk_rootfs) modules_install
endef

#
# clean target and macros
#
define embtk_cleanup_linux
	[ -d $(LINUX_BUILD_DIR) ] && $(call __embtk_unsetinstalled_pkg,linux) ||:
endef

define embtk_cleanup_linux_headers
	[ -d $(LINUX_BUILD_DIR) ] && $(call __embtk_unsetinstalled_pkg,linux_headers) ||:
endef
