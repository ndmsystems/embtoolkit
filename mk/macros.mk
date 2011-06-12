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
# \file         macros.mk
# \brief	macros.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

# Embtoolkit colors
EMBTK_COLOR_RED = "\E[1;31m"
EMBTK_COLOR_GREEN = "\E[1;32m"
EMBTK_COLOR_YELLOW = "\E[1;33m"
EMBTK_COLOR_BLUE = "\E[1;34m"
EMBTK_NO_COLOR = "\E[0m"

# echo colored text
#usage $(call ECHO_RED,$(TEXT))
define ECHO_RED
	@echo -e $(EMBTK_COLOR_RED)$(1)$(EMBTK_NO_COLOR)
endef
#usage $(call ECHO_GREEN,$(TEXT))
define ECHO_GREEN
	@echo -e $(EMBTK_COLOR_GREEN)$(1)$(EMBTK_NO_COLOR)
endef
#usage $(call ECHO_YELLOW,$(TEXT))
define ECHO_YELLOW
	@echo -e $(EMBTK_COLOR_YELLOW)$(1)$(EMBTK_NO_COLOR)
endef
#usage $(call ECHO_BLUE,$(TEXT))
define ECHO_BLUE
	@echo -e $(EMBTK_COLOR_BLUE)$(1)$(EMBTK_NO_COLOR)
endef

#
# wget wrapper
# usage: $(call EMBTK_WGET,$(OUTPUT_FILE),$(SITE),$(FOREIGN_FILE))
#
__WGET_OPTS = --tries=5 --timeout=10 --waitretry=5
define EMBTK_WGET
	wget $(__WGET_OPTS) -O $(DOWNLOAD_DIR)/$(strip $(1))		\
	$(strip $(2))/$(strip $(3)) ||					\
	wget $(__WGET_OPTS) --no-passive-ftp -O 			\
	$(DOWNLOAD_DIR)/$(strip $(1))	$(strip $(2))/$(strip $(3))
endef

#Decompress message
#usage $(call EMBTK_DECOMPRESS_MSG,$(NAME_PACKAGE))
define EMBTK_DECOMPRESS_MSG
	$(call ECHO_BLUE,"################################################################################")
	$(call ECHO_BLUE,"# EmbToolkit # Decompressing $(1)")
	$(call ECHO_BLUE,"################################################################################")
endef

#Configure message
#usage $(call EMBTK_CONFIGURE_MSG,$(NAME_PACKAGE))
define EMBTK_CONFIGURE_MSG
	$(call ECHO_BLUE,"################################################################################")
	$(call ECHO_BLUE,"# EmbToolkit # Configuring $(1)")
	$(call ECHO_BLUE,"################################################################################")
endef

#Build message
#usage $(call EMBTK_BUILD_MSG,$(NAME_PACKAGE))
define EMBTK_BUILD_MSG
	$(call ECHO_BLUE,"################################################################################")
	$(call ECHO_BLUE,"# EmbToolkit # Building $(1)")
	$(call ECHO_BLUE,"################################################################################")
endef

#Install message
#usage $(call EMBTK_INSTALL_MSG,$(NAME_PACKAGE))
define EMBTK_INSTALL_MSG
	$(call ECHO_BLUE,"################################################################################")
	$(call ECHO_BLUE,"# EmbToolkit # Installing $(1)")
	$(call ECHO_BLUE,"################################################################################")
endef

#Install message
#usage $(call EMBTK_ERROR_MSG,$(MESSAGE))
define EMBTK_ERROR_MSG
	$(call ECHO_RED,"################################################################################")
	$(call ECHO_RED,"# EmbToolkit # ERROR: $(1)")
	$(call ECHO_RED,"################################################################################")
endef

#Generic message
#usage $(call EMBTK_GENERIC_MESSAGE,$(GENERIC_MESSAGE))
define EMBTK_GENERIC_MESSAGE
	$(call ECHO_BLUE,"################################################################################")
	$(call ECHO_BLUE,"# EmbToolkit # $(1)")
	$(call ECHO_BLUE,"################################################################################")
endef
define EMBTK_GENERIC_MSG
	$(call EMBTK_GENERIC_MESSAGE,$(1))
endef

#Successful build of EmbToolkit message
successful_build:
	$(call ECHO_BLUE,"################################## EmbToolkit ##################################")
	$(call ECHO_BLUE," --------------------- ")
	$(call ECHO_BLUE,"| Toolchain build log |")
	$(call ECHO_BLUE," --------------------- ")
	$(call ECHO_BLUE,"You successfully build your toolchain for $(GNU_TARGET)")
	$(call ECHO_BLUE,"Tools built (GCC compiler, Binutils, etc.) are located in:")
	$(call ECHO_BLUE,"    $(TOOLS)/bin")
	@echo
	$(call ECHO_BLUE," ---------------------------- ")
	$(call ECHO_BLUE,"| Root file system build log |")
	$(call ECHO_BLUE," ---------------------------- ")
ifeq ($(CONFIG_EMBTK_HAVE_ROOTFS),y)
	$(call ECHO_BLUE,"You also successfully build a root filesystem located in the root directory")
	$(call ECHO_BLUE,"of EmbToolkit.")
else
	$(call ECHO_GREEN,"Build of root filesystem not selected.")
endif
	@echo
	$(call ECHO_BLUE," ---------------------------- ")
	$(call ECHO_BLUE,"| Embedded systems Toolkit   |")
	$(call ECHO_BLUE," ---------------------------- ")
	$(call ECHO_BLUE,"Hope that EmbToolkit will be useful for your project !!!")
	$(call ECHO_BLUE,"Please report any bugs/suggestion at:")
	$(call ECHO_BLUE,"   http://www.embtoolkit.org/issues/projects/show/embtoolkit")
	$(call ECHO_BLUE,"You can also visit the wiki at:")
	$(call ECHO_BLUE,"   http://www.embtoolkit.org")
	@echo
	$(call ECHO_BLUE,"################################################################################")

#Macro to adapt libtool files (*.la) for cross compiling
define __EMBTK_FIX_LIBTOOL_FILES
	@LIBTOOLS_LA_FILES=`find $(SYSROOT)/usr/$(LIBDIR) -name *.la`;			\
	for i in $$LIBTOOLS_LA_FILES; do						\
	sed -e "s;libdir='\/usr\/$(LIBDIR)';libdir='$(SYSROOT)\/usr\/$(LIBDIR)';" $$i	\
	> $$i.new;									\
	mv $$i.new $$i;									\
	done
endef
libtool_files_adapt:
	$(Q)$(call __EMBTK_FIX_LIBTOOL_FILES)

#Macro to restore libtool files (*.la)
libtool_files_restore:
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	@LIBTOOLS_LA_FILES=`find $(SYSROOT)/usr/lib32 -name *.la`; \
	for i in $$LIBTOOLS_LA_FILES; \
	do \
	sed -e "s;libdir='$(SYSROOT)\/usr\/lib32';libdir='\/usr\/lib32';" $$i \
	> $$i.new; \
	mv $$i.new $$i; \
	done
else
	@LIBTOOLS_LA_FILES=`find $(SYSROOT)/usr/lib -name *.la`; \
	for i in $$LIBTOOLS_LA_FILES; \
	do \
	sed -e "s;libdir='$(SYSROOT)\/usr\/lib';libdir='\/usr\/lib';" < $$i \
	> $$i.new; \
	mv $$i.new $$i; \
	done
endif

#Macro to adapt pkg-config files for cross compiling
define __EMBTK_FIX_PKGCONFIG_FILES
	@PKGCONFIG_FILES=`find $(SYSROOT)/usr/$(LIBDIR)/pkgconfig -name *.pc`;	\
	for i in $$PKGCONFIG_FILES; do						\
	sed -e 's;prefix=.*;prefix=$(SYSROOT)/usr;'				\
	-e 's;includedir=$${prefix}/include;includedir=$(SYSROOT)/usr/include;'	\
	-e 's;libdir=.*;libdir=$(SYSROOT)/usr/$(LIBDIR);' < $$i > $$i.new;	\
	mv $$i.new $$i;								\
	done
endef
pkgconfig_files_adapt:
	$(Q)$(call __EMBTK_FIX_PKGCONFIG_FILES)

#A macro to remove rpath in packages that use libtool -rpath
define EMBTK_KILL_LT_RPATH
	@cd $(strip $(1)); \
	LOCAL_LT_FILES=`find -type f -name libtool`; \
	for i in $$LOCAL_LT_FILES; \
	do \
	sed -i 's|^hardcode_libdir_flag_spec=.*|hardcode_libdir_flag_spec=""|g' $$i; \
	sed -i 's|^runpath_var=LD_RUN_PATH|runpath_var=DIE_RPATH_DIE|g' $$i; \
	done
endef

#
# A macro to get packages version from .config file.
# usage: $(call EMBTK_GET_PKG_VERSION,PACKAGE)
#
EMBTK_GET_PKG_VERSION = $(subst ",,$(strip $(CONFIG_EMBTK_$(1)_VERSION_STRING)))

#
# A macro which runs configure script (conpatible with autotools configure)
# for a package and sets environment variables correctly.
# Usage:
# $(call EMBTK_CONFIGURE_PKG,PACKAGE)
#
define EMBTK_CONFIGURE_AUTORECONF_PKG
@if [ "x$(CONFIG_EMBTK_$(1)_NEED_AUTORECONF)" == "xy" ]; then		\
	test -e $($(1)_SRC_DIR)/configure.ac ||				\
	test -e $($(1)_SRC_DIR)/configure.in || exit 1;			\
	cd $($(1)_SRC_DIR);						\
	$(AUTORECONF) --install -f;					\
fi
endef
define EMBTK_PRINT_CONFIGURE_OPTS
	$(call ECHO_BLUE,"Configure options:")
	@for i in `echo $(1) | tr " " "\n"`; \
	do echo -e $(EMBTK_COLOR_BLUE)$$i$(EMBTK_NO_COLOR); done
endef
define EMBTK_CONFIGURE_PKG
	$(call EMBTK_GENERIC_MSG,"Configure $($(1)_PACKAGE)...")
	$(call EMBTK_CONFIGURE_AUTORECONF_PKG,$(1))
	@test -e $($(1)_SRC_DIR)/configure || exit 1
	$(call EMBTK_PRINT_CONFIGURE_OPTS,"$($(1)_CONFIGURE_OPTS)")
	@cd $($(1)_BUILD_DIR);						\
	CC=$(TARGETCC_CACHED)						\
	CXX=$(TARGETCXX_CACHED)						\
	AR=$(TARGETAR)							\
	RANLIB=$(TARGETRANLIB)						\
	AS=$(CROSS_COMPILE)as						\
	LD=$(TARGETLD)							\
	NM=$(TARGETNM)							\
	STRIP=$(TARGETSTRIP)						\
	OBJDUMP=$(TARGETOBJDUMP)					\
	OBJCOPY=$(TARGETOBJCOPY)					\
	CFLAGS="$(TARGET_CFLAGS)"					\
	CXXFLAGS="$(TARGET_CFLAGS)"					\
	LDFLAGS="-L$(SYSROOT)/$(LIBDIR) -L$(SYSROOT)/usr/$(LIBDIR)"	\
	CPPFLAGS="-I$(SYSROOT)/usr/include"				\
	PKG_CONFIG=$(PKGCONFIG_BIN)					\
	PKG_CONFIG_PATH=$(PKG_CONFIG_PATH)				\
	ac_cv_func_malloc_0_nonnull=yes					\
	ac_cv_func_realloc_0_nonnull=yes				\
	$($(1)_CONFIGURE_ENV)						\
	$(CONFIG_SHELL) $($(1)_SRC_DIR)/configure			\
	--build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET)		\
	--target=$(STRICT_GNU_TARGET) --libdir=/usr/$(LIBDIR)		\
	--prefix=/usr --sysconfdir=/etc --disable-rpath			\
	$($(1)_CONFIGURE_OPTS)
	@touch $($(1)_BUILD_DIR)/.configured
	$(call EMBTK_KILL_LT_RPATH,$($(1)_BUILD_DIR))
endef

#
# A macro which runs configure script (conpatible with autotools configure)
# for a package for host development machine and sets environment variables
# correctly.
# Usage:
# $(call EMBTK_CONFIGURE_HOSTPKG,PACKAGE)
#
define EMBTK_CONFIGURE_HOSTPKG
	$(call EMBTK_GENERIC_MSG,"Configure $($(1)_PACKAGE) for host...")
	$(call EMBTK_CONFIGURE_AUTORECONF_PKG,$(1))
	@test -e $($(1)_SRC_DIR)/configure || exit 1
	$(call EMBTK_PRINT_CONFIGURE_OPTS,"$($(1)_CONFIGURE_OPTS)")
	@cd $($(1)_BUILD_DIR);						\
	CPPFLAGS="-I$(HOSTTOOLS)/usr/include"				\
	LDFLAGS="-L$(HOSTTOOLS)/$(LIBDIR) -L$(HOSTTOOLS)/usr/$(LIBDIR)"	\
	$($(1)_CONFIGURE_ENV)						\
	$(CONFIG_SHELL) $($(1)_SRC_DIR)/configure			\
	--build=$(HOST_BUILD) --host=$(HOST_ARCH)			\
	--prefix=$(if $($(1)_PREFIX),$($(1)_PREFIX),$(HOSTTOOLS)/usr)	\
	$($(1)_CONFIGURE_OPTS)
	@touch $($(1)_BUILD_DIR)/.configured
endef

#
# A macro to install automatically a package intended to run on the target.
# Usage:
# $(call EMBTK_INSTALL_PKG,PACKAGE)
#
__EMBTK_MULTI_MAKE = $(foreach builddir,$($(1)_MAKE_DIRS),			\
				$(MAKE) -C $($(1)_BUILD_DIR)/$(builddir)	\
				$($(1)_MAKE_OPTS) $(J);)

__EMBTK_SINGLE_MAKE = $(MAKE) -C $($(1)_BUILD_DIR) $($(1)_MAKE_OPTS) $(J)

__EMBTK_MULTI_MAKE_INSTALL = $(foreach builddir,$($(1)_MAKE_DIRS),		\
	$(MAKE) -C $($(1)_BUILD_DIR)/$(builddir)				\
	DESTDIR=$(SYSROOT)/$($(1)_SYSROOT_SUFFIX) $($(1)_MAKE_OPTS) install;)

__EMBTK_SINGLE_MAKE_INSTALL = $(MAKE) -C $($(1)_BUILD_DIR)			\
	DESTDIR=$(SYSROOT)/$($(1)_SYSROOT_SUFFIX) $($(1)_MAKE_OPTS) install

define __EMBTK_INSTALL_PKG_MAKE
	$(call EMBTK_GENERIC_MSG,"Compiling and installing $($(1)_NAME)-$($(1)_VERSION) in your root filesystem...")
	$(Q)$(if $(strip $($(1)_DEPS)),$(MAKE) $($(1)_DEPS))
	$(Q)$(call EMBTK_DOWNLOAD_PKG,$(1))
	$(Q)$(call EMBTK_DECOMPRESS_PKG,$(1))
	$(Q)$(call EMBTK_CONFIGURE_PKG,$(1))
	$(Q)$(if $($(1)_MAKE_DIRS),						\
		$(__EMBTK_MULTI_MAKE),						\
		$(__EMBTK_SINGLE_MAKE))
	$(Q)$(if $($(1)_MAKE_DIRS),						\
		$(__EMBTK_MULTI_MAKE_INSTALL),					\
		$(__EMBTK_SINGLE_MAKE_INSTALL))
	$(Q)$(call __EMBTK_FIX_LIBTOOL_FILES)
	$(Q)$(call __EMBTK_FIX_PKGCONFIG_FILES)
	@touch $($(1)_BUILD_DIR)/.installed
endef
define EMBTK_INSTALL_PKG
	@$(if $(shell test -e $($(1)_BUILD_DIR)/.installed && echo y),true,	\
		$(call __EMBTK_INSTALL_PKG_MAKE,$(1)))
endef

#
# A macro to install automatically a package intended to run on the host
# development machine.
# Usage:
# $(call EMBTK_INSTALL_HOSTPKG,PACKAGE)
#
define __EMBTK_INSTALL_HOSTPKG_MAKE
	$(call EMBTK_GENERIC_MSG,"Compiling and installing $($(1)_NAME)-$($(1)_VERSION) for host...")
	$(Q)$(if $(strip $($(1)_DEPS)),$(MAKE) $($(1)_DEPS))
	$(Q)$(call EMBTK_DOWNLOAD_PKG,$(1))
	$(Q)$(call EMBTK_DECOMPRESS_HOSTPKG,$(1))
	$(Q)$(call EMBTK_CONFIGURE_HOSTPKG,$(1))
	$(Q)$(MAKE) -C $($(1)_BUILD_DIR) $($(1)_MAKE_OPTS) $(J)
	$(Q)$(MAKE) -C $($(1)_BUILD_DIR) $($(1)_MAKE_OPTS) install
	@touch $($(1)_BUILD_DIR)/.installed
endef
define EMBTK_INSTALL_HOSTPKG
	@$(if $(shell test -e $($(1)_BUILD_DIR)/.installed && echo y),true,	\
		$(call __EMBTK_INSTALL_HOSTPKG_MAKE,$(1)))
endef

#
# A macro which downloads a package.
# Usage:
# $(call EMBTK_DOWNLOAD_PKG,PACKAGE)
#
define EMBTK_DOWNLOAD_PKG_PATCHES
@if [ "x$(CONFIG_EMBTK_$(1)_NEED_PATCH)" == "xy" ]; then		\
	test -e $(DOWNLOAD_DIR)/$($(1)_NAME)-$($(1)_VERSION).patch ||	\
	$(call EMBTK_WGET,						\
		$($(1)_NAME)-$($(1)_VERSION).patch,			\
		$($(1)_PATCH_SITE),					\
		$($(1)_NAME)-$($(1)_VERSION)-*.patch);			\
fi
endef
define EMBTK_DOWNLOAD_PKG_FROM_MIRROR
if [ "x$($(1)_SITE_MIRROR$(2))" == "x" ]; then 				\
	false;								\
else									\
	$(call EMBTK_WGET,						\
		$($(1)_PACKAGE),					\
		$($(1)_SITE_MIRROR$(2)),				\
		$($(1)_PACKAGE)); 					\
fi
endef
define EMBTK_DOWNLOAD_PKG
	$(call EMBTK_GENERIC_MSG,"Download $($(1)_PACKAGE) if necessary...")
	@test -e $(DOWNLOAD_DIR)/$($(1)_PACKAGE) ||			\
	$(call EMBTK_WGET,						\
		$($(1)_PACKAGE),					\
		$($(1)_SITE),						\
		$($(1)_PACKAGE))||					\
	$(call EMBTK_DOWNLOAD_PKG_FROM_MIRROR,$(1),1) ||		\
	$(call EMBTK_DOWNLOAD_PKG_FROM_MIRROR,$(1),2) ||		\
	$(call EMBTK_DOWNLOAD_PKG_FROM_MIRROR,$(1),3) || exit 1
	$(call EMBTK_DOWNLOAD_PKG_PATCHES,$(1))
endef

#
# A macro to decompress packages tarball intended to run on target.
# Usage:
# $(call EMBTK_DECOMPRESS_PKG,PACKAGE)
#
define EMBTK_DECOMPRESS_PKG
	$(call EMBTK_GENERIC_MSG,"Decrompressing $($(1)_PACKAGE) ...")
	@if [ "x$(CONFIG_EMBTK_$(1)_PKG_IS_TARGZ)" == "xy" ] &&			\
	[ ! -e $($(1)_SRC_DIR)/.decompressed ]; then				\
		tar -C $(PACKAGES_BUILD) -xzf					\
		$(DOWNLOAD_DIR)/$($(1)_PACKAGE) &&				\
		mkdir -p $($(1)_BUILD_DIR) &&					\
		touch $($(1)_SRC_DIR)/.decompressed;				\
	elif [ "x$(CONFIG_EMBTK_$(1)_PKG_IS_TARBZ2)" == "xy" ] &&		\
	[ ! -e $($(1)_SRC_DIR)/.decompressed ]; then				\
		tar -C $(PACKAGES_BUILD) -xjf					\
		$(DOWNLOAD_DIR)/$($(1)_PACKAGE) &&				\
		mkdir -p $($(1)_BUILD_DIR) &&					\
		touch $($(1)_SRC_DIR)/.decompressed;				\
	elif [ "x$(CONFIG_EMBTK_$(1)_PKG_IS_TARBZ2)" == "x" ] &&		\
	[ "x$(CONFIG_EMBTK_$(1)_PKG_IS_TARGZ)" == "x" ] &&			\
	[ ! -e $($(1)_SRC_DIR)/.decompressed ]; then				\
		echo -e "\E[1;31m!Unknown package compression type!\E[0m";	\
		exit 1;								\
	fi
	@if [ "x$(CONFIG_EMBTK_$(1)_NEED_PATCH)" == "xy" ] &&			\
	[ ! -e $($(1)_SRC_DIR)/.patched ]; then					\
		cd $($(1)_SRC_DIR);						\
		patch -p1 <							\
		$(DOWNLOAD_DIR)/$($(1)_NAME)-$($(1)_VERSION).patch &&		\
		touch $($(1)_SRC_DIR)/.patched;					\
	fi
	@mkdir -p $($(1)_BUILD_DIR)
endef

#
# A macro to decompress packages tarball intended to run on host development
# machine.
# Usage:
# $(call EMBTK_DECOMPRESS_HOSTPKG,PACKAGE)
#
define EMBTK_DECOMPRESS_HOSTPKG
	$(call EMBTK_GENERIC_MSG,"Decrompressing $($(1)_PACKAGE) ...")
	@if [ "x$(CONFIG_EMBTK_$(1)_PKG_IS_TARGZ)" == "xy" ] &&			\
	[ ! -e $($(1)_SRC_DIR)/.decompressed ]; then				\
		tar -C $(TOOLS_BUILD) -xzf					\
		$(DOWNLOAD_DIR)/$($(1)_PACKAGE) &&				\
		mkdir -p $($(1)_BUILD_DIR) &&					\
		touch $($(1)_SRC_DIR)/.decompressed;				\
	elif [ "x$(CONFIG_EMBTK_$(1)_PKG_IS_TARBZ2)" == "xy" ] &&		\
	[ ! -e $($(1)_SRC_DIR)/.decompressed ]; then				\
		tar -C $(TOOLS_BUILD) -xjf					\
		$(DOWNLOAD_DIR)/$($(1)_PACKAGE) &&				\
		mkdir -p $($(1)_BUILD_DIR) &&					\
		touch $($(1)_SRC_DIR)/.decompressed;				\
	elif [ "x$(CONFIG_EMBTK_$(1)_PKG_IS_TARBZ2)" == "x" ] &&		\
	[ "x$(CONFIG_EMBTK_$(1)_PKG_IS_TARGZ)" == "x" ] &&			\
	[ ! -e $($(1)_SRC_DIR)/.decompressed ]; then				\
		echo -e "\E[1;31m!Unknown package compression type!\E[0m";	\
		exit 1;								\
	fi
	@if [ "x$(CONFIG_EMBTK_$(1)_NEED_PATCH)" == "xy" ] &&			\
	[ ! -e $($(1)_SRC_DIR)/.patched ]; then					\
		cd $($(1)_SRC_DIR);						\
		patch -p1 <							\
		$(DOWNLOAD_DIR)/$($(1)_NAME)-$($(1)_VERSION).patch &&		\
		touch $($(1)_SRC_DIR)/.patched;					\
	fi
	@mkdir -p $($(1)_BUILD_DIR)
endef

#
# A macro to clean installed packages from sysroot.
# Usage:
# $(call EMBTK_CLEANUP_PKG,PACKAGE)
#
define EMBTK_CLEANUP_PKG
	$(call EMBTK_GENERIC_MESSAGE,"Cleanup $($(1)_NAME)...")
	@-if [ "x$($(1)_ETC)" != "x" ] && [ -e $(SYSROOT)/etc ];		\
		then								\
		cd $(SYSROOT)/etc; rm -rf $($(1)_ETC);				\
	fi
	@-if [ "x$($(1)_BINS)" != "x" ] && [ -e $(SYSROOT)/usr/bin ];		\
		then								\
		cd $(SYSROOT)/usr/bin; rm -rf $($(1)_BINS);			\
	fi
	@-if [ "x$($(1)_SBINS)" != "x" ] && [ -e $(SYSROOT)/usr/sbin ];		\
		then								\
		cd $(SYSROOT)/usr/sbin; rm -rf $($(1)_SBINS);			\
	fi
	@-if [ "x$($(1)_INCLUDES)" != "x" ] && [ -e $(SYSROOT)/usr/include ];	\
		then								\
		cd $(SYSROOT)/usr/include; rm -rf $($(1)_INCLUDES);		\
	fi
	@-if [ "x$($(1)_LIBS)" != "x" ] && [ -e $(SYSROOT)/usr/$(LIBDIR) ];	\
		then								\
		cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $($(1)_LIBS);		\
	fi
	@-if [ "x$($(1)_LIBEXECS)" != "x" ] &&					\
	[ -e $(SYSROOT)/usr/$(LIBDIR)/libexec ];				\
		then								\
		cd $(SYSROOT)/usr/$(LIBDIR)/libexec;				\
		rm -rf $($(1)_LIBEXECS);					\
	fi
	@-if [ "x$($(1)_PKGCONFIGS)" != "x" ] &&				\
	[ -e $(SYSROOT)/usr/$(LIBDIR)/pkgconfig ];				\
		then								\
		cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig;				\
		rm -rf $($(1)_PKGCONFIGS);					\
	fi
	@-rm -rf $($(1)_BUILD_DIR)*
endef
