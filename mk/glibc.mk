################################################################################
# Embtoolkit
# Copyright(C) 2013 Abdoulaye Walsimou GAYE.
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
# \file         glibc.mk
# \brief	glibc.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2013
################################################################################

GLIBC_NAME			:= glibc
GLIBC_VERSION			:= $(call embtk_get_pkgversion,glibc)
GLIBC_SITE			:= http://ftp.gnu.org/gnu/glibc
GLIBC_GIT_SITE			:= git://sourceware.org/git/glibc.git
GLIBC_PACKAGE			:= glibc-$(GLIBC_VERSION).tar.xz
GLIBC_SRC_DIR			:= $(embtk_toolsb)/glibc-$(GLIBC_VERSION)
GLIBC_BUILD_DIR 		:= $(embtk_toolsb)/glibc-$(GLIBC_VERSION)-build


__embtk_glibc_cflags	:= $(filter-out $(__clang_cflags),$(TARGET_CFLAGS))
__embtk_glibc_cflags	+= $(EMBTK_TARGET_MCPU)
__embtk_glibc_cflags	+= $(EMBTK_TARGET_ABI) $(EMBTK_TARGET_FLOAT_CFLAGS)
__embtk_glibc_cflags	+= $(EMBTK_TARGET_MARCH)
# glibc does not support -O0 optimization
embtk_glibc_cflags	:= $(subst -O0,-O1,$(__embtk_glibc_cflags))

# Hard or soft floating point in glibc?
embtk_glibc_floattype := $(if $(CONFIG_EMBTK_SOFTFLOAT),--with-fp=no,--with-fp=yes)

ifeq ($(embtk_buildhost_os_type),bsd)
embtk_glibc_buildcflags		:= -I/usr/local/include
embtk_glibc_buildldflags	:= -L/usr/local/lib -lintl
endif

#
# glibc install
#

define embtk_configure_glibc
	cd $(GLIBC_BUILD_DIR);							\
	BUILD_CC="$(hostcc_cached)"						\
	CFLAGS="$(embtk_glibc_cflags)"						\
	CC=$(TARGETGCC_CACHED)							\
	CXX=$(TARGETGCXX_CACHED)						\
	AR=$(TARGETAR)								\
	RANLIB=$(TARGETRANLIB)							\
	READELF=$(TARGETREADELF)						\
	NM=$(TARGETNM)								\
	OBJCOPY=$(TARGETOBJCOPY)						\
	OBJDUMP=$(TARGETDUMP)							\
	$(CONFIG_EMBTK_SHELL) $(GLIBC_SRC_DIR)/configure			\
	--prefix=/usr --with-headers=$(embtk_sysroot)/usr/include		\
	--host=$(STRICT_GNU_TARGET)						\
	--target=$(STRICT_GNU_TARGET)						\
	--build=$(HOST_BUILD)							\
	$(embtk_glibc_floattype) --disable-profile --without-gd --without-cvs	\
	--without-selinux --enable-add-ons --enable-kernel="2.6.27"		\
	--enable-obsolete-rpc --disable-build-nscd --disable-nscd		\
	--with-bugurl=$(EMBTK_BUGURL)						\
	--with-pkgversion="GLIBC from embtoolkit-$(EMBTK_VERSION)"
	touch $(GLIBC_BUILD_DIR)/.glibc.embtk.conifgured
	touch $(call __embtk_pkg_dotconfigured_f,glibc)
endef

define __embtk_install_glibc
	$(call embtk_pinfo,"Installing glibc...")
	$(call embtk_download_pkg,glibc)
	$(call embtk_decompress_pkg,glibc)
	mkdir -p $(GLIBC_BUILD_DIR)
	$(embtk_configure_glibc)
	PATH=$(PATH):$(embtk_tools)/bin/ $(MAKE) -C $(GLIBC_BUILD_DIR) $(J)	\
		BUILD_CFLAGS="$(embtk_glibc_buildcflags)"			\
		BUILD_LDFLAGS="$(embtk_glibc_buildldflags)"
	PATH=$(PATH):$(embtk_tools)/bin/ $(MAKE) -C $(GLIBC_BUILD_DIR)		\
		BUILD_CFLAGS="$(embtk_glibc_buildcflags)"			\
		BUILD_LDFLAGS="$(embtk_glibc_buildldflags)"			\
		install_root=$(embtk_sysroot) install
	touch $(call __embtk_pkg_dotinstalled_f,glibc)
	$(call __embtk_pkg_gen_dotkconfig_f,glibc)
endef

define embtk_install_glibc
	$(if $(call __embtk_pkg_installed-y,glibc),true,			\
					$(__embtk_install_glibc))
endef

#
# clean targets
#
define embtk_cleanup_glibc
	rm -rf $(GLIBC_BUILD_DIR)
endef

define embtk_cleanup_glibc_headers
	rm -rf $(GLIBC_HEADERS_BUILD_DIR)
endef
