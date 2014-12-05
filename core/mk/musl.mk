################################################################################
# Embtoolkit
# Copyright(C) 2012-2014 Abdoulaye Walsimou GAYE.
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
# \file         musl.mk
# \brief	musl.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         October 2012
################################################################################

MUSL_NAME		:= musl
MUSL_VERSION		:= $(call embtk_get_pkgversion,musl)
MUSL_SITE		:= http://www.musl-libc.org/releases
MUSL_GIT_SITE		:= https://github.com/ndmsystems/musl
MUSL_PACKAGE		:= musl-$(MUSL_VERSION).tar.gz
MUSL_SRC_DIR		:= $(embtk_toolsb)/musl-$(MUSL_VERSION)
MUSL_BUILD_DIR		:= $(call __embtk_pkg_srcdir,musl)

__embtk_musl_v	 = "$(MUSL_VERSION) -"
__embtk_musl_v	+= "Cross Compiler $(embtk_targetcc_name-v) [$(embtk_host_uname)]"

__embtk_musl_cflags := $(TARGET_CFLAGS)
__embtk_musl_cflags += $(if $(embtk_toolchain_use_llvm-y),-Wno-unknown-warning-option)

define embtk_beforeinstall_musl
	$(MAKE) -C $(MUSL_BUILD_DIR) distclean
	cd $(MUSL_BUILD_DIR);							\
		CC=$(TARGETCC_CACHED)						\
		CROSS_COMPILE="$(CROSS_COMPILE)"				\
		CFLAGS="$(__embtk_musl_cflags)"					\
		$(CONFIG_SHELL) $(MUSL_BUILD_DIR)/configure			\
		--target=$(LINUX_ARCH) --host=$(LINUX_ARCH)			\
		--disable-gcc-wrapper --enable-warnings				\
		--prefix=/ --syslibdir=/$(LIBDIR) --libdir=/$(LIBDIR) 		\
		--includedir=/usr/include
		echo "$(__embtk_musl_v)" > $(MUSL_BUILD_DIR)/VERSION
	$(call __embtk_setconfigured_pkg,musl)
endef

define __embtk_install_musl
	$(Q)$(MAKE) -C $(MUSL_BUILD_DIR)					\
		DESTDIR=$(embtk_sysroot) install-libs install-headers
	$(Q)cd $(embtk_sysroot)/$(LIBDIR);					\
		ln -sf libc.so $(embtk_musl_dlinker).so.1
endef

define embtk_install_musl
	$(__embtk_install_musl)
endef

define embtk_cleanup_musl
	if [ -d $(MUSL_BUILD_DIR) ]; then					\
		$(MAKE) -C $(MUSL_BUILD_DIR) distclean;				\
		$(call __embtk_unsetconfigured_pkg,musl);			\
		$(call __embtk_unsetinstalled_pkg,musl);			\
		$(call __embtk_unsetkconfigured_pkg,musl);			\
	fi
endef
