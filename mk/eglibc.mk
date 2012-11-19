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
# \file         eglibc.mk
# \brief	eglibc.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

EGLIBC_NAME			:= eglibc
EGLIBC_VERSION			:= $(call embtk_get_pkgversion,eglibc)
EGLIBC_SVN_SITE			:= http://www.eglibc.org/svn
EGLIBC_SRC_DIR			:= $(call __embtk_pkg_localsvn,eglibc)
EGLIBC_BUILD_DIR 		:= $(embtk_toolsb)/eglibc-build

EGLIBC_HEADERS_NAME		:= eglibc_headers
EGLIBC_HEADERS_VERSION		:= $(EGLIBC_VERSION)
EGLIBC_HEADERS_SVN_SITE		:= $(EGLIBC_SVN_SITE)
EGLIBC_HEADERS_SRC_DIR		:= $(EGLIBC_SRC_DIR)
EGLIBC_HEADERS_BUILD_DIR	:= $(embtk_toolsb)/eglibc-headers-build
EGLIBC_HEADERS_KCONFIGS_NAME	:= EGLIBC

embtk_eglibc_cflags := $(TARGET_CFLAGS) $(EMBTK_TARGET_MCPU)
embtk_eglibc_cflags += $(EMBTK_TARGET_ABI) $(EMBTK_TARGET_FLOAT_CFLAGS)
embtk_eglibc_cflags += $(EMBTK_TARGET_MARCH) -pipe

# Hard or soft floating point in eglibc?
embtk_eglibc_floattype := $(if $(CONFIG_EMBTK_SOFTFLOAT),			\
				--with-fp=no,--with-fp=yes)

# Versioning in eglibc
embtk_eglibc_versioning-$(CONFIG_EMBTK_EGLIBC_DISABLE_VERSIONING) :=		\
							--disable-versioning

embtk_eglibc_optgroups_f	:= $(EMBTK_ROOT)/mk/eglibc/eglibc-$(EGLIBC_VERSION)-options.mk
eglibc_optgroups_f		:= $(EGLIBC_BUILD_DIR)/option-groups.config
eglibc_headers_optgroups_f	:= $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config

#
# eglibc headers install
#

define embtk_configure_eglibc_headers
	cd $(EGLIBC_HEADERS_BUILD_DIR);						\
	BUILD_CC=$(HOSTCC_CACHED)						\
	CFLAGS="$(embtk_eglibc_cflags)"						\
	CC=$(TARGETCC)								\
	CXX=$(TARGETCXX)							\
	AR=$(TARGETAR)								\
	RANLIB=$(TARGETRANLIB)							\
	$(CONFIG_SHELL) $(EGLIBC_SRC_DIR)/libc/configure			\
	--prefix=/usr --with-headers=$(embtk_sysroot)/usr/include		\
	--host=$(STRICT_GNU_TARGET) --build=$(HOST_BUILD)			\
	$(embtk_eglibc_floattype) --disable-profile --without-gd --without-cvs	\
	--enable-add-ons --enable-kernel="2.6.27" $(embtk_eglibc_versioning-y)	\
	--with-bugurl=$(EMBTK_BUGURL)
	touch touch $(call __embtk_pkg_dotconfigured_f,eglibc_headers)
endef

define __embtk_install_eglibc_headers
	$(call embtk_pinfo,"Installing eglibc headers...")
	$(call embtk_download_pkg,eglibc)
	$(embtk_parse_eglibc_optgroups)
	$(embtk_configure_eglibc_headers)
	$(MAKE) -C $(EGLIBC_HEADERS_BUILD_DIR) install-headers			\
		install_root=$(embtk_sysroot) install-bootstrap-headers=yes &&	\
		$(MAKE) -C $(EGLIBC_HEADERS_BUILD_DIR) csu/subdir_lib
	cp $(EGLIBC_HEADERS_BUILD_DIR)/csu/crt1.o $(embtk_sysroot)/usr/$(LIBDIR)/
	cp $(EGLIBC_HEADERS_BUILD_DIR)/csu/crti.o $(embtk_sysroot)/usr/$(LIBDIR)/
	cp $(EGLIBC_HEADERS_BUILD_DIR)/csu/crtn.o $(embtk_sysroot)/usr/$(LIBDIR)/
	$(TARGETCC) -nostdlib -nostartfiles -shared -x c /dev/null		\
					-o $(embtk_sysroot)/usr/lib/libc.so
	touch $(call __embtk_pkg_dotinstalled_f,eglibc_headers)
endef

define embtk_install_eglibc_headers
	$(if $(call __embtk_pkg_installed-y,eglibc_headers),true,		\
					$(__embtk_install_eglibc_headers))
endef

#
# eglibc install
#

define embtk_configure_eglibc
	cd $(EGLIBC_BUILD_DIR);							\
	BUILD_CC=$(HOSTCC_CACHED)						\
	CFLAGS="$(embtk_eglibc_cflags)"						\
	CC=$(TARGETCC_CACHED)							\
	CXX=$(TARGETCXX_CACHED)							\
	AR=$(TARGETAR)								\
	RANLIB=$(TARGETRANLIB)							\
	$(CONFIG_SHELL) $(EGLIBC_SRC_DIR)/libc/configure			\
	--prefix=/usr --with-headers=$(embtk_sysroot)/usr/include		\
	--host=$(STRICT_GNU_TARGET) --build=$(HOST_BUILD)			\
	$(embtk_eglibc_floattype) --disable-profile --without-gd --without-cvs	\
	--enable-add-ons --enable-kernel="2.6.27" $(embtk_eglibc_versioning-y)	\
	--with-bugurl=$(EMBTK_BUGURL)						\
	--with-pkgversion="EGLIBC from embtoolkit-$(EMBTK_VERSION)"
	touch $(EGLIBC_BUILD_DIR)/.eglibc.embtk.conifgured
	touch $(call __embtk_pkg_dotconfigured_f,eglibc)
endef

define __embtk_install_eglibc
	$(call embtk_pinfo,"Installing eglibc...")
	$(embtk_configure_eglibc)
	PATH=$(PATH):$(embtk_tools)/bin/ $(MAKE) -C $(EGLIBC_BUILD_DIR) $(J)
	PATH=$(PATH):$(embtk_tools)/bin/ $(MAKE) -C $(EGLIBC_BUILD_DIR)		\
		install_root=$(embtk_sysroot) install
	touch $(call __embtk_pkg_dotinstalled_f,eglibc)
endef

define embtk_install_eglibc
	$(if $(call __embtk_pkg_installed-y,eglibc),true,			\
					$(__embtk_install_eglibc))
endef

#
# clean targets
#
define embtk_cleanup_eglibc
	rm -rf $(EGLIBC_BUILD_DIR)
endef

define embtk_cleanup_eglibc_headers
	rm -rf $(EGLIBC_HEADERS_BUILD_DIR)
endef

#
# options groups parsing
#
__embtk_get_eglibc_optgroups = grep "CONFIG_KEMBTK_EGLIBC_" $(EMBTK_DOTCONFIG)	\
	| sed -e 's/CONFIG_KEMBTK_EGLIBC_*//g' | sed -e 's/"//g'
define embtk_parse_eglibc_optgroups
	mkdir -p $(EGLIBC_BUILD_DIR)
	mkdir -p $(EGLIBC_HEADERS_BUILD_DIR)
	cat $(embtk_eglibc_optgroups_f) > $(eglibc_headers_optgroups_f)
	echo "###############################" >> $(eglibc_headers_optgroups_f)
	echo "# From embtk-$(EMBTK_VERSION) #" >> $(eglibc_headers_optgroups_f)
	echo "###############################" >> $(eglibc_headers_optgroups_f)
	$(__embtk_get_eglibc_optgroups) >> $(eglibc_headers_optgroups_f)
	cp $(eglibc_headers_optgroups_f) $(eglibc_optgroups_f)
endef
