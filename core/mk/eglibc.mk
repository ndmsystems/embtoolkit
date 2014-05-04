################################################################################
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

__embtk_eglibc_cflags	:= $(filter-out $(__clang_cflags),$(TARGET_CFLAGS))
__embtk_eglibc_cflags	+= $(EMBTK_TARGET_MCPU)
__embtk_eglibc_cflags	+= $(EMBTK_TARGET_ABI) $(EMBTK_TARGET_FLOAT_CFLAGS)
__embtk_eglibc_cflags	+= $(EMBTK_TARGET_MARCH) -pipe
# eglibc does not support -O0 optimization
embtk_eglibc_cflags	:= $(subst -O0,-O1,$(__embtk_eglibc_cflags))

# Hard or soft floating point in eglibc?
embtk_eglibc_floattype := $(if $(CONFIG_EMBTK_SOFTFLOAT),--with-fp=no,--with-fp=yes)

# Versioning in eglibc
embtk_eglibc_versioning-$(CONFIG_EMBTK_EGLIBC_DISABLE_VERSIONING) :=		\
							--disable-versioning
embtk_eglibc-sunrpc-$(CONFIG_KEMBTK_EGLIBC_OPTION_EGLIBC_SUNRPC) :=		\
						--enable-obsolete-rpc=yes

embtk_eglibc_optgroups_f	:= $(EMBTK_ROOT)/core/mk/eglibc/eglibc-$(EGLIBC_VERSION)-options.mk
eglibc_optgroups_f		:= $(EGLIBC_BUILD_DIR)/option-groups.config

ifeq ($(embtk_buildhost_os_type),bsd)
embtk_eglibc_buildcflags	:= -I/usr/local/include
embtk_eglibc_buildldflags	:= -L/usr/local/lib -lintl
endif

#
# eglibc install
#

define embtk_configure_eglibc
	cd $(EGLIBC_BUILD_DIR);							\
	BUILD_CC="$(hostcc_cached)"						\
	CFLAGS="$(embtk_eglibc_cflags)"						\
	CC=$(TARGETGCC_CACHED)							\
	CXX=$(TARGETGCXX_CACHED)						\
	AR=$(TARGETAR)								\
	RANLIB=$(TARGETRANLIB)							\
	READELF=$(TARGETREADELF)						\
	NM=$(TARGETNM)								\
	OBJCOPY=$(TARGETOBJCOPY)						\
	OBJDUMP=$(TARGETDUMP)							\
	$(CONFIG_EMBTK_SHELL) $(EGLIBC_SRC_DIR)/libc/configure			\
	--prefix=/usr --with-headers=$(embtk_sysroot)/usr/include		\
	--host=$(STRICT_GNU_TARGET)						\
	--target=$(STRICT_GNU_TARGET)						\
	--build=$(HOST_BUILD)							\
	$(embtk_eglibc_floattype) --disable-profile --without-gd --without-cvs	\
	--enable-add-ons --enable-kernel="2.6.32"				\
	$(embtk_eglibc_versioning-y)						\
	$(embtk_eglibc-sunrpc-y)						\
	--with-bugurl=$(EMBTK_BUGURL)						\
	--with-pkgversion="EGLIBC from embtoolkit-$(EMBTK_VERSION)"
	$(call __embtk_setconfigured_pkg,eglibc)
endef

define __embtk_install_eglibc
	$(call embtk_pinfo,"Installing eglibc...")
	$(call embtk_download_pkg,eglibc)
	touch `find $(EGLIBC_SRC_DIR) -name configure`
	$(embtk_parse_eglibc_optgroups)
	$(embtk_configure_eglibc)
	PATH=$(PATH):$(embtk_tools)/bin/ $(MAKE) -C $(EGLIBC_BUILD_DIR) $(J)	\
		BUILD_CFLAGS="$(embtk_eglibc_buildcflags)"			\
		BUILD_LDFLAGS="$(embtk_eglibc_buildldflags)"
	PATH=$(PATH):$(embtk_tools)/bin/ $(MAKE) -C $(EGLIBC_BUILD_DIR)		\
		BUILD_CFLAGS="$(embtk_eglibc_buildcflags)"			\
		BUILD_LDFLAGS="$(embtk_eglibc_buildldflags)"			\
		install_root=$(embtk_sysroot) install
	$(call __embtk_setinstalled_pkg,eglibc)
	$(call __embtk_pkg_gen_dotkconfig_f,eglibc)
	$(eval __embtk_eglibc_installed := y)
endef

define embtk_install_eglibc
	$(if $(call __embtk_pkg_runrecipe-y,eglibc),$(__embtk_install_eglibc))
endef

#
# clean targets
#
define embtk_cleanup_eglibc
	rm -rf $(EGLIBC_BUILD_DIR)
endef

#
# options groups parsing
#
__embtk_get_eglibc_optgroups = grep "CONFIG_KEMBTK_EGLIBC_" $(EMBTK_DOTCONFIG)	\
	| sed -e 's/CONFIG_KEMBTK_EGLIBC_*//g' | sed -e 's/"//g'
define embtk_parse_eglibc_optgroups
	mkdir -p $(EGLIBC_BUILD_DIR)
	cat $(embtk_eglibc_optgroups_f) > $(eglibc_optgroups_f)
	echo "###############################" >> $(eglibc_optgroups_f)
	echo "# From embtk-$(EMBTK_VERSION) #" >> $(eglibc_optgroups_f)
	echo "###############################" >> $(eglibc_optgroups_f)
	$(__embtk_get_eglibc_optgroups) >> $(eglibc_optgroups_f)
endef
