################################################################################
# Embtoolkit
# Copyright(C) 2012-2013 Abdoulaye Walsimou GAYE.
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
MUSL_GIT_SITE		:= git://git.musl-libc.org/musl
MUSL_PACKAGE		:= musl-$(MUSL_VERSION).tar.gz
MUSL_SRC_DIR		:= $(embtk_toolsb)/musl-$(MUSL_VERSION)
MUSL_BUILD_DIR		:= $(call __embtk_pkg_srcdir,musl)

define embtk_beforeinstall_musl
	cd $(MUSL_SRC_DIR);							\
		CC=$(TARGETCC)							\
		CROSS_COMPILE="$(CROSS_COMPILE)"				\
		CFLAGS="$(TARGET_CFLAGS)"					\
		$(CONFIG_SHELL) $(MUSL_SRC_DIR)/configure			\
		--target=$(LINUX_ARCH) --host=$(LINUX_ARCH)			\
		--disable-gcc-wrapper --prefix=/				\
		--syslibdir=/$(LIBDIR) --libdir=/$(LIBDIR) 			\
		--includedir=/usr/include
	touch $(call __embtk_pkg_dotconfigured_f,musl)
endef

define __embtk_install_musl
	$(call embtk_pinfo,"Build and install musl-$(MUSL_VERSION) ...")
	$(call embtk_download_pkg,musl)
	$(call embtk_decompress_pkg,musl)
	$(Q)$(MAKE) -C $(MUSL_BUILD_DIR) distclean
	$(embtk_beforeinstall_musl)
	$(Q)$(MAKE) -C $(MUSL_BUILD_DIR)					\
		DESTDIR=$(embtk_sysroot) install-libs install-headers
	cd $(embtk_sysroot)/$(LIBDIR); ln -sf libc.so ld-musl-$(LINUX_ARCH).so.1
	touch $(call __embtk_pkg_dotinstalled_f,musl)
	$(call __embtk_pkg_gen_dotkconfig_f,musl)
endef

define embtk_install_musl
	$(if $(call __embtk_pkg_installed-y,musl),true,$(__embtk_install_musl))
endef

define embtk_cleanup_musl
	if [ -d $(MUSL_BUILD_DIR) ]; then					\
		$(MAKE) -C $(MUSL_BUILD_DIR) distclean;				\
		rm -rf $(call __embtk_pkg_dotconfigured_f,musl);		\
		rm -rf $(call __embtk_pkg_dotinstalled_f,musl);			\
		rm -rf $(call __embtk_pkg_dotkconfig_f,musl);			\
	fi
endef
