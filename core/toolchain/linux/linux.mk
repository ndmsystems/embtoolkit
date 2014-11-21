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
# \brief	linux image and module build/install
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

#
# linux install macros
#

ifeq ($(embtk_buildhost_os),macos)
LINUX_DEPS := libelf_host_install
endif

pembtk_linux_dotconfig_f	:= $(call embtk_uquote,$(CONFIG_EMBTK_LINUX_DOTCONFIG))
pembtk_linux_extsrc-y		:= $(CONFIG_EMBTK_LINUX_BUILD_USE_EXTSRC)
pembtk_linux_srcdir		:= $(call embtk_uquote,$(or $(CONFIG_EMBTK_LINUX_BUILD_EXTSRC),$(LINUX_SRC_DIR)))
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

ifeq ($(embtk_buildhost_os),macos)
define embtk_beforeinstall_linux
	cp $(EMBTK_ROOT)/scripts/unifdef.c					\
		$(LINUX_SRC_DIR)/scripts/unifdef.c
endef
endif

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
	for b in $$(ls $(pembtk_linux_bootdir)/dts/*.dtb 2>/dev/null);		\
	do									\
		cp $$b $(pembtk_linux_generated/boot/dts);			\
	done
endef

define embtk_cleanup_linux
	[ -d $(LINUX_BUILD_DIR) ] && $(call __embtk_unsetinstalled_pkg,linux) ||:
	rm -rf $(pembtk_linux_generated)
endef

#
# linux modules part
#
LINUX_MODULES_NAME	:= linux
LINUX_MODULES_VERSION	:= $(LINUX_VERSION)
LINUX_MODULES_SITE	:= $(LINUX_SITE)
LINUX_MODULES_PACKAGE	:= $(LINUX_PACKAGE)
LINUX_MODULES_SRC_DIR	:= $(LINUX_SRC_DIR)
LINUX_MODULES_BUILD_DIR	:= $(LINUX_BUILD_DIR)
LINUX_MODULES_KCONFIGS_NAME := LINUX
LINUX_MODULES_KEEP_SRC_DIR  := $(LINUX_KEEP_SRC_DIR)

LINUX_MODULES_DEPS := $(LINUX_DEPS)

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

define embtk_cleanup_linux_modules
	[ -d $(LINUX_BUILD_DIR) ] && $(call __embtk_unsetinstalled_pkg,linux_modules) ||:
endef
