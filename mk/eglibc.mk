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
EGLIBC_HEADERS_NAME		:= eglibc_headers
EGLIBC_VERSION			:= $(call embtk_get_pkgversion,eglibc)
EGLIBC_SVN_SITE			:= http://www.eglibc.org/svn
EGLIBC_BUILD_DIR 		:= $(TOOLS_BUILD)/eglibc
EGLIBC_SRC_DIR			:= $(call __embtk_pkg_localsvn,eglibc)
EGLIBC_HEADERS_BUILD_DIR	:= $(TOOLS_BUILD)/eglibc-headers
EGLIBC_HEADERS_SRC_DIR		:= $(call __embtk_pkg_localsvn,eglibc)

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
embtk_eglibc_h_kconfigs_f	:= $(EMBTK_ROOT)/.eglibc_headers.config

#
# eglibc headers install
#
define __embtk_eglibc_headers_install
	$(call embtk_pinfo,"Installing eglibc headers")
	$(MAKE) download_eglibc
	$(embtk_parse_eglibc_optgroups)
	$(embtk_configure_eglibc_headers)
	$(embtk_install_eglibc_headers)
endef

eglibc_headers_postinstall:
	$(__embtk_get_eglibc_h_kconfigs)

eglibc_headers_install: eglibc_headers_postinstall
	$(if $(call __embtk_pkg_installed-y,eglibc_headers,$(embtk_eglibc_h_kconfigs_f)),\
		true,$(__embtk_eglibc_headers_install))
	rm -rf $(embtk_eglibc_h_kconfigs_f)

#
# eglibc install
#
define __embtk_eglibc_install
	$(call embtk_pinfo,"Installing eglibc")
	$(MAKE) download_eglibc
	$(embtk_parse_eglibc_optgroups)
	$(embtk_configure_eglibc)
	$(embtk_install_eglibc)
endef
eglibc_install:
	$(Q)$(if $(call __embtk_pkg_installed-y,eglibc),			\
		true,$(__embtk_eglibc_install))

#
# download and macros
#
download_eglibc download_eglibc_headers:
	$(call embtk_download_pkg,eglibc)
	$(Q)$(call __embtk_download_pkg_patches,eglibc)
	$(Q)$(call  __embtk_applypatch_pkg,eglibc)
	$(Q)cd $(EGLIBC_SRC_DIR); touch `find . -name configure`
	$(Q)ln -sf $(EGLIBC_SRC_DIR)/ports $(EGLIBC_SRC_DIR)/libc/ports

define embtk_configure_eglibc
	cd $(EGLIBC_BUILD_DIR);							\
	BUILD_CC=$(HOSTCC_CACHED)						\
	CFLAGS="$(embtk_eglibc_cflags)"						\
	CC=$(TARGETCC)								\
	CXX=$(TARGETCXX)							\
	AR=$(TARGETAR)								\
	RANLIB=$(TARGETRANLIB)							\
	$(CONFIG_SHELL) $(EGLIBC_SRC_DIR)/libc/configure			\
	--prefix=/usr --with-headers=$(SYSROOT)/usr/include			\
	--host=$(STRICT_GNU_TARGET) --build=$(HOST_BUILD)			\
	$(embtk_eglibc_floattype) --disable-profile --without-gd --without-cvs	\
	--enable-add-ons --enable-kernel="2.6.0" $(embtk_eglibc_versioning-y)	\
	--with-bugurl=$(EMBTK_BUGURL)						\
	--with-pkgversion="EGLIBC from embtoolkit-$(EMBTK_VERSION)"
	touch $(EGLIBC_BUILD_DIR)/.conifgured
endef

define embtk_configure_eglibc_headers
	cd $(EGLIBC_HEADERS_BUILD_DIR);						\
	BUILD_CC=$(HOSTCC_CACHED)						\
	CFLAGS="$(embtk_eglibc_cflags)"						\
	CC=$(TARGETCC)								\
	CXX=$(TARGETCXX)							\
	AR=$(TARGETAR)								\
	RANLIB=$(TARGETRANLIB)							\
	$(CONFIG_SHELL) $(EGLIBC_SRC_DIR)/libc/configure			\
	--prefix=/usr --with-headers=$(SYSROOT)/usr/include			\
	--host=$(STRICT_GNU_TARGET) --build=$(HOST_BUILD)			\
	$(embtk_eglibc_floattype) --disable-profile --without-gd --without-cvs	\
	--enable-add-ons --enable-kernel="2.6.0" $(embtk_eglibc_versioning-y)	\
	--with-bugurl=$(EMBTK_BUGURL)
	touch $(EGLIBC_HEADERS_BUILD_DIR)/.configured
endef

define embtk_install_eglibc
	PATH=$(PATH):$(TOOLS)/bin/ $(MAKE) -C $(EGLIBC_BUILD_DIR) $(J)
	PATH=$(PATH):$(TOOLS)/bin/ $(MAKE) -C $(EGLIBC_BUILD_DIR) install	\
							install_root=$(SYSROOT)
	touch $(EGLIBC_BUILD_DIR)/.installed
endef

define embtk_install_eglibc_headers
	$(MAKE) -C $(EGLIBC_HEADERS_BUILD_DIR) install-headers			\
		install_root=$(SYSROOT) install-bootstrap-headers=yes &&	\
		$(MAKE) -C $(EGLIBC_HEADERS_BUILD_DIR) csu/subdir_lib
	cp $(EGLIBC_HEADERS_BUILD_DIR)/csu/crt1.o $(SYSROOT)/usr/lib/
	cp $(EGLIBC_HEADERS_BUILD_DIR)/csu/crti.o $(SYSROOT)/usr/lib/
	cp $(EGLIBC_HEADERS_BUILD_DIR)/csu/crtn.o $(SYSROOT)/usr/lib/
	$(TARGETCC) -nostdlib -nostartfiles -shared -x c /dev/null		\
						-o $(SYSROOT)/usr/lib/libc.so
	touch $(EGLIBC_HEADERS_BUILD_DIR)/.installed
endef

__embtk_get_eglibc_h_kconfigs = cat $(EMBTK_DOTCONFIG) | 			\
	sed -e 's/CONFIG_KEMBTK_EGLIBC_/CONFIG_KEMBTK_EGLIBC_HEADERS_/g'	\
		-e 's/CONFIG_EMBTK_EGLIBC_/CONFIG_EMBTK_EGLIBC_HEADERS_/g'	\
						> $(embtk_eglibc_h_kconfigs_f)
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
