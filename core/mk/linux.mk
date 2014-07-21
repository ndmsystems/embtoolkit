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

#
# linux kernel part
#
LINUX_NAME		:= linux
LINUX_MAJORV		:= $(call embtk_get_pkgversion,linux_major)
LINUX_LONGTERMV		:= $(call embtk_get_pkgversion,linux_longterm)
LINUX_VERSION		:= $(call embtk_get_pkgversion,linux)
LINUX_SITE		:= $(call __LINUX_SITE)
LINUX_PACKAGE		:= linux-$(LINUX_VERSION).tar.xz
LINUX_SRC_DIR		:= $(embtk_toolsb)/linux-$(LINUX_VERSION)
LINUX_BUILD_DIR		:= $(embtk_toolsb)/linux-$(LINUX_VERSION)
LINUX_KEEP_SRC_DIR	:= $(CONFIG_EMBTK_BUILD_LINUX_KERNEL)

#
# linux headers part
#
LINUX_HEADERS_NAME	:= linux
LINUX_HEADERS_VERSION	:= $(LINUX_VERSION)
LINUX_HEADERS_SITE	:= $(LINUX_SITE)
LINUX_HEADERS_PACKAGE	:= $(LINUX_PACKAGE)
LINUX_HEADERS_SRC_DIR	:= $(LINUX_SRC_DIR)
LINUX_HEADERS_BUILD_DIR	:= $(LINUX_BUILD_DIR)
LINUX_HEADERS_KCONFIGS_NAME	:= LINUX
LINUX_HEADERS_KEEP_SRC_DIR	:= $(CONFIG_EMBTK_BUILD_LINUX_KERNEL)

#
# linux modules part
#
LINUX_MODULES_NAME	:= linux
LINUX_MODULES_VERSION	:= $(LINUX_VERSION)
LINUX_MODULES_SITE	:= $(LINUX_SITE)
LINUX_MODULES_PACKAGE	:= $(LINUX_PACKAGE)
LINUX_MODULES_SRC_DIR	:= $(LINUX_SRC_DIR)
LINUX_MODULES_BUILD_DIR	:= $(LINUX_BUILD_DIR)
LINUX_MODULES_KCONFIGS_NAME	:= LINUX
LINUX_MODULES_KEEP_SRC_DIR	:= $(CONFIG_EMBTK_BUILD_LINUX_KERNEL)

#
# common options
#
LINUX_MAKE_OPTS	:= quiet=quiet_
LINUX_MAKE_OPTS	+= ARCH=$(LINUX_ARCH)
LINUX_MAKE_OPTS	+= CROSS_COMPILE=$(CROSS_COMPILE_CACHED)
LINUX_MAKE_OPTS	+= HOSTCC="$(HOSTCC)" HOSTCXX="$(HOSTCXX)"

#
# linux headers install
#
define embtk_install_linux_headers
	$(MAKE) -C $(LINUX_BUILD_DIR) $(LINUX_MAKE_OPTS)			\
		INSTALL_HDR_PATH=$(embtk_sysroot)/usr headers_install
endef

#
# linux install macros
#

pembtk_linux_dotconfig_f	:= $(call __embtk_mk_uquote,$(CONFIG_EMBTK_LINUX_DOTCONFIG))
pembtk_linux_extsrc-y		:= $(CONFIG_EMBTK_LINUX_BUILD_USE_EXTSRC)
pembtk_linux_srcdir		:= $(call __embtk_mk_uquote,$(or $(CONFIG_EMBTK_LINUX_BUILD_EXTSRC),$(LINUX_SRC_DIR)))
pembtk_linux_modules-y		:= $(shell grep MODULES=y "$(pembtk_linux_dotconfig_f)" 2>/dev/null)

define pembtk_linux_check_dotconfig
	if [ "x" = "x$(pembtk_linux_dotconfig_f)" ]; then			\
		$(call embtk_perror,"No kernel config file specified");		\
		exit 1;								\
	fi
	if [ ! -e $(pembtk_linux_dotconfig_f) ]; then				\
		$(call embtk_perror,"Kernel config file $(pembtk_linux_dotconfig_f) not found");\
		exit 1;								\
	fi
endef

define pembtk_linux_check_extsrc
	if [ "x" = "x$(pembtk_linux_srcdir)" ]; then				\
		$(call embtk_perror,"kernel source tree not specified");	\
		exit 1;								\
	fi
	if [ ! -d $(pembtk_linux_srcdir) ]; then				\
		$(call embtk_perror,"kernel source tree $(pembtk_linux_srcdir) not found");\
		exit 1;								\
	fi
endef

pembtk_linux_generated		:= $(embtk_generated)/linux-images-$(GNU_TARGET)-$(EMBTK_MCU_FLAG)
pembtk_linux_generated/boot	:= $(pembtk_linux_generated)/boot
pembtk_linux_generated/boot/dts	:= $(pembtk_linux_generated/boot)/dts
pembtk_linux_bootdir		:= $(pembtk_linux_srcdir)/arch/$(LINUX_ARCH)/boot
pembtk_linux_bootfiles		:= Image zImage xipImage bootpImage uImage
pembtk_linux_bootfiles		+= vmlinux.ecoff vmlinux.bin vmlinux.srec
pembtk_linux_bootfiles		+= uImage.gz

define embtk_install_linux
	$(pembtk_linux_check_dotconfig)
	$(if $(pembtk_linux_extsrc-y),$(pembtk_linux_check_extsrc))
	cp $(CONFIG_EMBTK_LINUX_DOTCONFIG) $(pembtk_linux_srcdir)/.config
	$(MAKE) -C $(pembtk_linux_srcdir) $(LINUX_MAKE_OPTS) silentoldconfig
	$(MAKE) -C $(pembtk_linux_srcdir) $(LINUX_MAKE_OPTS) $(J)
	[ -e $(pembtk_linux_generated/boot) ] ||				\
		install -d $(pembtk_linux_generated/boot)
	[ -e $(pembtk_linux_generated/boot/dts) ] ||				\
		install -d $(pembtk_linux_generated/boot/dts)
	cp $(pembtk_linux_srcdir)/vmlinux $(pembtk_linux_generated)
	cd $(pembtk_linux_bootdir);						\
	for b in $(pembtk_linux_bootfiles); do					\
		if [ -e $$b ]; then cp $$b $(pembtk_linux_generated/boot); fi;	\
	done
	for b in $$(ls $(pembtk_linux_bootdir)/dts/*.dtb 2>/dev/null);	\
	do									\
		cp $$b $(pembtk_linux_generated/boot/dts);			\
	done
endef

#
# linux modules install
#
define embtk_install_linux_modules
	$(if $(pembtk_linux_modules-y),$(pembtk_install_linux_modules))
endef
define pembtk_install_linux_modules
	$(call embtk_pinfo,"Install linux kernel modules...")
	$(embtk_install_linux)
	$(MAKE) -C $(pembtk_linux_srcdir) $(LINUX_MAKE_OPTS)			\
		INSTALL_MOD_PATH=$(embtk_rootfs) modules_install
endef
define embtk_postinstall_linux_modules
	rm -rf $(embtk_rootfs)/lib/modules/*/build
	rm -rf $(embtk_rootfs)/lib/modules/*/source
endef

#
# clean target and macros
#
define embtk_cleanup_linux
	[ -d $(LINUX_BUILD_DIR) ] && $(call __embtk_unsetinstalled_pkg,linux) ||:
	rm -rf $(pembtk_linux_generated)
endef

define embtk_cleanup_linux_headers
	[ -d $(LINUX_BUILD_DIR) ] && $(call __embtk_unsetinstalled_pkg,linux_headers) ||:
endef

define embtk_cleanup_linux_modules
	[ -d $(LINUX_BUILD_DIR) ] && $(call __embtk_unsetinstalled_pkg,linux_modules) ||:
endef
