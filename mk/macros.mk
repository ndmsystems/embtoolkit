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
__embtk_color_red = "\E[1;31m"
__embtk_color_green = "\E[1;32m"
__embtk_color_yellow = "\E[1;33m"
__embtk_color_blue = "\E[1;34m"
__embtk_no_color = "\E[0m"

# echo colored text
#usage $(call embtk_echo_red,$(TEXT))
define embtk_echo_red
	@echo -e $(__embtk_color_red)$(1)$(__embtk_no_color)
endef
#usage $(call embtk_echo_green,$(TEXT))
define embtk_echo_green
	@echo -e $(__embtk_color_green)$(1)$(__embtk_no_color)
endef
#usage $(call echo_yellow,$(TEXT))
define echo_yellow
	@echo -e $(__embtk_color_yellow)$(1)$(__embtk_no_color)
endef
#usage $(call embtk_echo_blue,$(TEXT))
define embtk_echo_blue
	@echo -e $(__embtk_color_blue)$(1)$(__embtk_no_color)
endef

#
# __embtk_mk_strcmp:
# A macro for two strings comparison. It returns y if the strings are identical
# and nothing if not.
# Note: This macro strips passed parameters
# Usage:
# $(call __embtk_mk_strcmp,str1,str2)
#
__embtk_mk_strcmp=$(shell [ $(strip $(1)) = $(strip $(2)) ] && echo y)

#
# wget wrapper
# usage: $(call embtk_wget,$(OUTPUT_FILE),$(SITE),$(FOREIGN_FILE))
#
__wget_opts = --tries=5 --timeout=10 --waitretry=5
define embtk_wget
	wget $(__wget_opts) -O $(DOWNLOAD_DIR)/$(strip $(1))		\
	$(strip $(2))/$(strip $(3)) ||					\
	wget $(__WGET_OPTS) --no-passive-ftp -O 			\
	$(DOWNLOAD_DIR)/$(strip $(1))	$(strip $(2))/$(strip $(3))
endef

#Decompress message
#usage $(call EMBTK_DECOMPRESS_MSG,$(NAME_PACKAGE))
define EMBTK_DECOMPRESS_MSG
	$(call embtk_echo_blue,"################################################################################")
	$(call embtk_echo_blue,"# EmbToolkit # Decompressing $(1)")
	$(call embtk_echo_blue,"################################################################################")
endef

#Configure message
#usage $(call EMBTK_CONFIGURE_MSG,$(NAME_PACKAGE))
define EMBTK_CONFIGURE_MSG
	$(call embtk_echo_blue,"################################################################################")
	$(call embtk_echo_blue,"# EmbToolkit # Configuring $(1)")
	$(call embtk_echo_blue,"################################################################################")
endef

#Build message
#usage $(call EMBTK_BUILD_MSG,$(NAME_PACKAGE))
define EMBTK_BUILD_MSG
	$(call embtk_echo_blue,"################################################################################")
	$(call embtk_echo_blue,"# EmbToolkit # Building $(1)")
	$(call embtk_echo_blue,"################################################################################")
endef

#Install message
#usage $(call EMBTK_INSTALL_MSG,$(NAME_PACKAGE))
define EMBTK_INSTALL_MSG
	$(call embtk_echo_blue,"################################################################################")
	$(call embtk_echo_blue,"# EmbToolkit # Installing $(1)")
	$(call embtk_echo_blue,"################################################################################")
endef

#Install message
#usage $(call embtk_error_msg,$(MESSAGE))
define embtk_error_msg
	$(call embtk_echo_red,"################################################################################")
	$(call embtk_echo_red,"# EmbToolkit # ERROR: $(1)")
	$(call embtk_echo_red,"################################################################################")
endef

#Generic message
#usage $(call embtk_generic_message,$(GENERIC_MESSAGE))
define embtk_generic_message
	$(call embtk_echo_blue,"################################################################################")
	$(call embtk_echo_blue,"# EmbToolkit # $(1)")
	$(call embtk_echo_blue,"################################################################################")
endef
define embtk_generic_msg
	$(call embtk_generic_message,$(1))
endef

#Successful build of EmbToolkit message
successful_build:
	$(call embtk_echo_blue," --------------------- ")
	$(call embtk_echo_blue,"| Toolchain build log |")
	$(call embtk_echo_blue," --------------------- ")
	$(call embtk_echo_blue,"You successfully build your toolchain for $(GNU_TARGET)")
	$(call embtk_echo_blue,"Tools built (GCC compiler, Binutils, etc.) are located in:")
	$(call embtk_echo_blue,"    $(TOOLS)/bin")
	@echo
	$(call embtk_echo_blue," ---------------------------- ")
	$(call embtk_echo_blue,"| Root file system build log |")
	$(call embtk_echo_blue," ---------------------------- ")
ifeq ($(CONFIG_EMBTK_HAVE_ROOTFS),y)
	$(call embtk_echo_blue,"You also successfully build root filesystem(s) located in the")
	$(call embtk_echo_blue,"'generated' sub-directory of EmbToolkit.")
else
	$(call embtk_echo_green,"Build of root filesystem not selected.")
endif
	@echo
	$(call embtk_echo_blue," ---------------------------- ")
	$(call embtk_echo_blue,"| Embedded systems Toolkit   |")
	$(call embtk_echo_blue," ---------------------------- ")
	$(call embtk_echo_blue,"Hope that EmbToolkit will be useful for your project !!!")
	$(call embtk_echo_blue,"Please report any bugs/suggestion at:")
	$(call embtk_echo_blue,"   http://www.embtoolkit.org/issues/projects/show/embtoolkit")
	$(call embtk_echo_blue,"You can also visit the wiki at:")
	$(call embtk_echo_blue,"   http://www.embtoolkit.org")
	@echo
	$(call embtk_echo_blue,"################################################################################")

#Macro to adapt libtool files (*.la) for cross compiling
__ltlibdirold=libdir='\/usr\/$(LIBDIR)'
__ltlibdirnew=libdir='$(SYSROOT)\/usr\/$(LIBDIR)'
define __embtk_fix_libtool_files
	@LIBTOOLS_LA_FILES=`find $(SYSROOT)/usr/$(LIBDIR) -name *.la`;		\
	for i in $$LIBTOOLS_LA_FILES; do					\
	sed -i "s;$(__ltlibdirold);$(__ltlibdirnew);" $$i;			\
	done
endef
libtool_files_adapt:
	$(Q)$(call __embtk_fix_libtool_files)

#Macro to adapt pkg-config files for cross compiling
define __embtk_fix_pkgconfig_files
	@PKGCONFIG_FILES=`find $(SYSROOT)/usr/$(LIBDIR)/pkgconfig -name *.pc`;	\
	for i in $$PKGCONFIG_FILES; do						\
	sed -e 's;prefix=.*;prefix=$(SYSROOT)/usr;'				\
	-e 's;includedir=$${prefix}/include;includedir=$(SYSROOT)/usr/include;'	\
	-e 's;libdir=.*;libdir=$(SYSROOT)/usr/$(LIBDIR);' < $$i > $$i.new;	\
	mv $$i.new $$i;								\
	done
endef
pkgconfig_files_adapt:
	$(Q)$(call __embtk_fix_pkgconfig_files)

#A macro to remove rpath in packages that use libtool -rpath
define __embtk_kill_lt_rpath
	@cd $(strip $(1)); \
	LOCAL_LT_FILES=`find -type f -name libtool`; \
	for i in $$LOCAL_LT_FILES; \
	do \
	sed -i 's|^hardcode_libdir_flag_spec=.*|hardcode_libdir_flag_spec=""|g' $$i; \
	sed -i 's|^runpath_var=LD_RUN_PATH|runpath_var=DIE_RPATH_DIE|g' $$i; \
	done
endef

#
# Get passed package variables prefix
#
PKGV=$(strip $(shell echo $(1) | tr a-z A-Z))

#
# A macro to get packages version from .config file.
# usage: $(call embtk_get_pkgversion,PACKAGE)
#
embtk_get_pkgversion = $(subst ",,$(strip $(CONFIG_EMBTK_$(PKGV)_VERSION_STRING)))

#
# A macro which runs configure script (conpatible with autotools configure)
# for a package and sets environment variables correctly.
# Usage:
# $(call embtk_configure_pkg,PACKAGE)
#
define __embtk_configure_autoreconfpkg
@if [ "x$(CONFIG_EMBTK_$(PKGV)_NEED_AUTORECONF)" == "xy" ]; then		\
	test -e $($(PKGV)_SRC_DIR)/configure.ac ||				\
	test -e $($(PKGV)_SRC_DIR)/configure.in || exit 1;			\
	cd $($(PKGV)_SRC_DIR);							\
	$(AUTORECONF) --install -f;						\
fi
endef
define __embtk_print_configure_opts
	$(call embtk_echo_blue,"Configure options:")
	@for i in `echo $(1) | tr " " "\n"`; \
	do echo -e $(__embtk_color_blue)$$i$(__embtk_no_color); done
endef
define embtk_configure_pkg
	$(call embtk_generic_msg,"Configure $($(PKGV)_PACKAGE)...")
	$(call __embtk_configure_autoreconfpkg,$(1))
	@test -e $($(PKGV)_SRC_DIR)/configure || exit 1
	$(call __embtk_print_configure_opts,"$($(PKGV)_CONFIGURE_OPTS)")
	@cd $($(PKGV)_BUILD_DIR);						\
	CC=$(TARGETCC_CACHED)							\
	CXX=$(TARGETCXX_CACHED)							\
	AR=$(TARGETAR)								\
	RANLIB=$(TARGETRANLIB)							\
	AS=$(CROSS_COMPILE)as							\
	LD=$(TARGETLD)								\
	NM=$(TARGETNM)								\
	STRIP=$(TARGETSTRIP)							\
	OBJDUMP=$(TARGETOBJDUMP)						\
	OBJCOPY=$(TARGETOBJCOPY)						\
	CFLAGS="$(TARGET_CFLAGS)"						\
	CXXFLAGS="$(TARGET_CFLAGS)"						\
	LDFLAGS="-L$(SYSROOT)/$(LIBDIR) -L$(SYSROOT)/usr/$(LIBDIR)"		\
	CPPFLAGS="-I$(SYSROOT)/usr/include"					\
	PKG_CONFIG=$(PKGCONFIG_BIN)						\
	PKG_CONFIG_PATH=$(EMBTK_PKG_CONFIG_PATH)				\
	ac_cv_func_malloc_0_nonnull=yes						\
	ac_cv_func_realloc_0_nonnull=yes					\
	$($(PKGV)_CONFIGURE_ENV)						\
	$(CONFIG_SHELL) $($(PKGV)_SRC_DIR)/configure				\
	--build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET)			\
	--target=$(STRICT_GNU_TARGET) --libdir=/usr/$(LIBDIR)			\
	--prefix=/usr --sysconfdir=/etc --disable-rpath				\
	$($(PKGV)_CONFIGURE_OPTS)
	@touch $($(PKGV)_BUILD_DIR)/.configured
	$(call __embtk_kill_lt_rpath,$($(PKGV)_BUILD_DIR))
endef

#
# A macro which runs configure script (conpatible with autotools configure)
# for a package for host development machine and sets environment variables
# correctly.
# Usage:
# $(call embtk_configure_hostpkg,PACKAGE)
#
define embtk_configure_hostpkg
	$(call embtk_generic_msg,"Configure $($(PKGV)_PACKAGE) for host...")
	$(call __embtk_configure_autoreconfpkg,$(1))
	@test -e $($(PKGV)_SRC_DIR)/configure || exit 1
	$(call __embtk_print_configure_opts,"$($(PKGV)_CONFIGURE_OPTS)")
	@cd $($(PKGV)_BUILD_DIR);						\
	CPPFLAGS="-I$(HOSTTOOLS)/usr/include"					\
	LDFLAGS="-L$(HOSTTOOLS)/$(LIBDIR) -L$(HOSTTOOLS)/usr/$(LIBDIR)"		\
	$($(PKGV)_CONFIGURE_ENV)						\
	$(CONFIG_SHELL) $($(PKGV)_SRC_DIR)/configure				\
	--build=$(HOST_BUILD) --host=$(HOST_ARCH)				\
	--prefix=$(if $($(PKGV)_PREFIX),$($(PKGV)_PREFIX),$(HOSTTOOLS)/usr)	\
	$($(PKGV)_CONFIGURE_OPTS)
	@touch $($(PKGV)_BUILD_DIR)/.configured
endef

#
# A macro to install automatically a package intended to run on the target.
# Usage:
# $(call embtk_install_pkg,PACKAGE)
#
__embtk_multi_make = $(foreach builddir,$($(PKGV)_MAKE_DIRS),			\
				$(MAKE) -C $($(PKGV)_BUILD_DIR)/$(builddir)	\
				$($(PKGV)_MAKE_OPTS) $(J);)

__embtk_single_make = $(MAKE) -C $($(PKGV)_BUILD_DIR) $($(PKGV)_MAKE_OPTS) $(J)

__embtk_multi_make_install = $(foreach builddir,$($(PKGV)_MAKE_DIRS),		\
	$(MAKE) -C $($(PKGV)_BUILD_DIR)/$(builddir)				\
	DESTDIR=$(SYSROOT)/$($(PKGV)_SYSROOT_SUFFIX) $($(PKGV)_MAKE_OPTS) install;)

__embtk_single_make_install = $(MAKE) -C $($(PKGV)_BUILD_DIR)			\
	DESTDIR=$(SYSROOT)/$($(PKGV)_SYSROOT_SUFFIX) $($(PKGV)_MAKE_OPTS) install

__embtk_multi_make_hostinstall = $(foreach builddir,$($(PKGV)_MAKE_DIRS),	\
	$(MAKE) -C $($(PKGV)_BUILD_DIR)/$(builddir)				\
	$(if $($(PKGV)_DESTDIR),DESTDIR=$($(PKGV)_DESTDIR))			\
	$($(PKGV)_MAKE_OPTS) install;)

__embtk_single_make_hostinstall = $(MAKE) -C $($(PKGV)_BUILD_DIR)		\
	$(if $($(PKGV)_DESTDIR),DESTDIR=$($(PKGV)_DESTDIR)) $($(PKGV)_MAKE_OPTS) install

define __embtk_install_pkg_make
	$(call embtk_generic_msg,"Compiling and installing $($(PKGV)_NAME)-$($(PKGV)_VERSION) in your root filesystem...")
	$(Q)$(if $(strip $($(PKGV)_DEPS)),$(MAKE) $($(PKGV)_DEPS))
	$(Q)$(call embtk_download_pkg,$(1))
	$(Q)$(call embtk_decompress_pkg,$(1))
	$(Q)$(call embtk_configure_pkg,$(1))
	$(Q)$(if $($(PKGV)_MAKE_DIRS),						\
		$(__embtk_multi_make),						\
		$(__embtk_single_make))
	$(Q)$(if $($(PKGV)_MAKE_DIRS),						\
		$(__embtk_multi_make_install),					\
		$(__embtk_single_make_install))
	$(Q)$(call __embtk_fix_libtool_files)
	$(Q)$(call __embtk_fix_pkgconfig_files)
	@touch $($(PKGV)_BUILD_DIR)/.installed
endef
define embtk_install_pkg
	@$(if $(shell test -e $($(PKGV)_BUILD_DIR)/.installed && echo y),true,	\
		$(call __embtk_install_pkg_make,$(1)))
endef

#
# A macro to install automatically a package intended to run on the host
# development machine.
# Usage:
# $(call embtk_install_hostpkg,PACKAGE)
#
define __embtk_install_hostpkg_make
	$(call embtk_generic_msg,"Compiling and installing $($(PKGV)_NAME)-$($(PKGV)_VERSION) for host...")
	$(Q)$(if $(strip $($(PKGV)_DEPS)),$(MAKE) $($(PKGV)_DEPS))
	$(Q)$(call embtk_download_pkg,$(1))
	$(Q)$(call embtk_decompress_hostpkg,$(1))
	$(Q)$(call embtk_configure_hostpkg,$(1))
	$(Q)$(if $($(PKGV)_MAKE_DIRS),						\
		$(__embtk_multi_make),						\
		$(__embtk_single_make))
	$(Q)$(if $($(PKGV)_MAKE_DIRS),						\
		$(__embtk_multi_make_hostinstall),				\
		$(__embtk_single_make_hostinstall))
	@touch $($(PKGV)_BUILD_DIR)/.installed
endef
define embtk_install_hostpkg
	@$(if $(shell test -e $($(PKGV)_BUILD_DIR)/.installed && echo y),true,	\
		$(call __embtk_install_hostpkg_make,$(1)))
endef

#
# A macro which downloads a package.
# Usage:
# $(call embtk_download_pkg,PACKAGE)
#
define __embtk_download_pkg_patches
@if [ "x$(CONFIG_EMBTK_$(PKGV)_NEED_PATCH)" == "xy" ]; then			\
	test -e $(DOWNLOAD_DIR)/$($(PKGV)_NAME)-$($(PKGV)_VERSION).patch ||	\
	$(call embtk_wget,							\
		$($(PKGV)_NAME)-$($(PKGV)_VERSION).patch,			\
		$($(PKGV)_PATCH_SITE),						\
		$($(PKGV)_NAME)-$($(PKGV)_VERSION)-*.patch);			\
fi
endef
define __embtk_download_pkg_from_mirror
if [ "x$($(PKGV)_SITE_MIRROR$(2))" == "x" ]; then 				\
	false;									\
else										\
	$(call embtk_wget,							\
		$($(PKGV)_PACKAGE),						\
		$($(PKGV)_SITE_MIRROR$(2)),					\
		$($(PKGV)_PACKAGE)); 						\
fi
endef
define embtk_download_pkg
	$(call embtk_generic_msg,"Download $($(PKGV)_PACKAGE) if necessary...")
	@test -e $(DOWNLOAD_DIR)/$($(PKGV)_PACKAGE) ||				\
	$(call embtk_wget,							\
		$($(PKGV)_PACKAGE),						\
		$($(PKGV)_SITE),						\
		$($(PKGV)_PACKAGE))||						\
	$(call __embtk_download_pkg_from_mirror,$(1),1) ||			\
	$(call __embtk_download_pkg_from_mirror,$(1),2) ||			\
	$(call __embtk_download_pkg_from_mirror,$(1),3) || exit 1
	$(call __embtk_download_pkg_patches,$(1))
endef

#
# A macro to decompress packages tarball intended to run on target.
# Usage:
# $(call embtk_decompress_pkg,PACKAGE)
#
define embtk_decompress_pkg
	$(call embtk_generic_msg,"Decrompressing $($(PKGV)_PACKAGE) ...")
	@if [ "x$(CONFIG_EMBTK_$(PKGV)_PKG_IS_TARGZ)" == "xy" ] &&		\
	[ ! -e $($(PKGV)_SRC_DIR)/.decompressed ]; then				\
		tar -C $(PACKAGES_BUILD) -xzf					\
		$(DOWNLOAD_DIR)/$($(PKGV)_PACKAGE) &&				\
		mkdir -p $($(PKGV)_BUILD_DIR) &&				\
		touch $($(PKGV)_SRC_DIR)/.decompressed;				\
	elif [ "x$(CONFIG_EMBTK_$(PKGV)_PKG_IS_TARBZ2)" == "xy" ] &&		\
	[ ! -e $($(PKGV)_SRC_DIR)/.decompressed ]; then				\
		tar -C $(PACKAGES_BUILD) -xjf					\
		$(DOWNLOAD_DIR)/$($(PKGV)_PACKAGE) &&				\
		mkdir -p $($(PKGV)_BUILD_DIR) &&				\
		touch $($(PKGV)_SRC_DIR)/.decompressed;				\
	elif [ "x$(CONFIG_EMBTK_$(PKGV)_PKG_IS_TARBZ2)" == "x" ] &&		\
	[ "x$(CONFIG_EMBTK_$(PKGV)_PKG_IS_TARGZ)" == "x" ] &&			\
	[ ! -e $($(PKGV)_SRC_DIR)/.decompressed ]; then				\
		echo -e "\E[1;31m!Unknown package compression type!\E[0m";	\
		exit 1;								\
	fi
	@if [ "x$(CONFIG_EMBTK_$(PKGV)_NEED_PATCH)" == "xy" ] &&		\
	[ ! -e $($(PKGV)_SRC_DIR)/.patched ]; then				\
		cd $($(PKGV)_SRC_DIR);						\
		patch -p1 <							\
		$(DOWNLOAD_DIR)/$($(PKGV)_NAME)-$($(PKGV)_VERSION).patch &&	\
		touch $($(PKGV)_SRC_DIR)/.patched;				\
	fi
	@mkdir -p $($(PKGV)_BUILD_DIR)
endef

#
# A macro to decompress packages tarball intended to run on host development
# machine.
# Usage:
# $(call embtk_decompress_hostpkg,PACKAGE)
#
define embtk_decompress_hostpkg
	$(call embtk_generic_msg,"Decrompressing $($(PKGV)_PACKAGE) ...")
	@if [ "x$(CONFIG_EMBTK_$(PKGV)_PKG_IS_TARGZ)" == "xy" ] &&		\
	[ ! -e $($(PKGV)_SRC_DIR)/.decompressed ]; then				\
		tar -C $(TOOLS_BUILD) -xzf					\
		$(DOWNLOAD_DIR)/$($(PKGV)_PACKAGE) &&				\
		mkdir -p $($(PKGV)_BUILD_DIR) &&				\
		touch $($(PKGV)_SRC_DIR)/.decompressed;				\
	elif [ "x$(CONFIG_EMBTK_$(PKGV)_PKG_IS_TARBZ2)" == "xy" ] &&		\
	[ ! -e $($(PKGV)_SRC_DIR)/.decompressed ]; then				\
		tar -C $(TOOLS_BUILD) -xjf					\
		$(DOWNLOAD_DIR)/$($(PKGV)_PACKAGE) &&				\
		mkdir -p $($(PKGV)_BUILD_DIR) &&				\
		touch $($(PKGV)_SRC_DIR)/.decompressed;				\
	elif [ "x$(CONFIG_EMBTK_$(PKGV)_PKG_IS_TARBZ2)" == "x" ] &&		\
	[ "x$(CONFIG_EMBTK_$(PKGV)_PKG_IS_TARGZ)" == "x" ] &&			\
	[ ! -e $($(PKGV)_SRC_DIR)/.decompressed ]; then				\
		echo -e "\E[1;31m!Unknown package compression type!\E[0m";	\
		exit 1;								\
	fi
	@if [ "x$(CONFIG_EMBTK_$(PKGV)_NEED_PATCH)" == "xy" ] &&		\
	[ ! -e $($(PKGV)_SRC_DIR)/.patched ]; then				\
		cd $($(PKGV)_SRC_DIR);						\
		patch -p1 <							\
		$(DOWNLOAD_DIR)/$($(PKGV)_NAME)-$($(PKGV)_VERSION).patch &&	\
		touch $($(PKGV)_SRC_DIR)/.patched;				\
	fi
	@mkdir -p $($(PKGV)_BUILD_DIR)
endef

#
# A macro to clean installed packages from sysroot.
# Usage:
# $(call embtk_cleanup_pkg,PACKAGE)
#
define embtk_cleanup_pkg
	$(call embtk_generic_message,"Cleanup $($(PKGV)_NAME)...")
	@-if [ "x$($(PKGV)_ETC)" != "x" ] && [ -e $(SYSROOT)/etc ];		\
		then								\
		cd $(SYSROOT)/etc; rm -rf $($(PKGV)_ETC);			\
	fi
	@-if [ "x$($(PKGV)_BINS)" != "x" ] && [ -e $(SYSROOT)/usr/bin ];	\
		then								\
		cd $(SYSROOT)/usr/bin; rm -rf $($(PKGV)_BINS);			\
	fi
	@-if [ "x$($(PKGV)_SBINS)" != "x" ] && [ -e $(SYSROOT)/usr/sbin ];	\
		then								\
		cd $(SYSROOT)/usr/sbin; rm -rf $($(PKGV)_SBINS);		\
	fi
	@-if [ "x$($(PKGV)_INCLUDES)" != "x" ] && [ -e $(SYSROOT)/usr/include ];\
		then								\
		cd $(SYSROOT)/usr/include; rm -rf $($(PKGV)_INCLUDES);		\
	fi
	@-if [ "x$($(PKGV)_LIBS)" != "x" ] && [ -e $(SYSROOT)/usr/$(LIBDIR) ];	\
		then								\
		cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $($(PKGV)_LIBS);		\
	fi
	@-if [ "x$($(PKGV)_LIBEXECS)" != "x" ] &&				\
	[ -e $(SYSROOT)/usr/$(LIBDIR)/libexec ];				\
		then								\
		cd $(SYSROOT)/usr/$(LIBDIR)/libexec;				\
		rm -rf $($(PKGV)_LIBEXECS);					\
	fi
	@-if [ "x$($(PKGV)_PKGCONFIGS)" != "x" ] &&				\
	[ -e $(SYSROOT)/usr/$(LIBDIR)/pkgconfig ];				\
		then								\
		cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig;				\
		rm -rf $($(PKGV)_PKGCONFIGS);					\
	fi
	@-rm -rf $($(PKGV)_BUILD_DIR)*
endef
