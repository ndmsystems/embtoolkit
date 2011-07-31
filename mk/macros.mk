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
__wget_outfile		= $(patsubst %/,%,$(DOWNLOAD_DIR))/$(strip $(1))
__wget_remotesite	= $(patsubst %/,%,$(strip $(2)))
__wget_foreignfiles	= $(strip $(3))
__wget_opts		= --tries=5 --timeout=10 --waitretry=5
define embtk_wget
	wget $(__wget_opts) -O $(__wget_outfile)				\
	$(__wget_remotesite)/$(__wget_foreignfiles) ||				\
	wget $(__wget_opts) --no-passive-ftp -O $(__wget_outfile)		\
	$(__wget_remotesite)/$(__wget_foreignfiles)
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

#
# embtk_pkgconfig_getlibs:
# A macro to get pkg-config libs entry for a target package
# Usage: $(call embtk_pkgconfig_getlibs,pkgname)
#
define embtk_pkgconfig_getlibs
	$(shell									\
		PKG_CONFIG_PATH=$(EMBTK_PKG_CONFIG_PATH)			\
		PKG_CONFIG_LIBDIR="$(EMBTK_PKG_CONFIG_LIBDIR)"			\
		$(PKGCONFIG_BIN) $(strip $(1)) --libs)
endef

#
# embtk_pkgconfig_getcflags:
# A macro to get pkg-config cflags entry for a target package
# Usage: $(call embtk_pkgconfig_getcflags,pkgname)
#
define embtk_pkgconfig_getcflags
	$(shell									\
		PKG_CONFIG_PATH=$(EMBTK_PKG_CONFIG_PATH)			\
		PKG_CONFIG_LIBDIR="$(EMBTK_PKG_CONFIG_LIBDIR)"			\
		$(PKGCONFIG_BIN) $(strip $(1)) --cflags)
endef

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
	PKGCONFIG_FILES=`find $(SYSROOT)/usr/$(LIBDIR)/pkgconfig -name *.pc`;	\
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
	cd $(strip $(1)); \
	LOCAL_LT_FILES=`find -type f -name libtool`; \
	for i in $$LOCAL_LT_FILES; \
	do \
	sed -i 's|^hardcode_libdir_flag_spec=.*|hardcode_libdir_flag_spec=""|g' $$i; \
	sed -i 's|^runpath_var=LD_RUN_PATH|runpath_var=DIE_RPATH_DIE|g' $$i; \
	done
endef

#
# Get passed package variables prefix and set some helpers macros.
#
PKGV				= $(strip $(shell echo $(1) | tr a-z A-Z))
__embtk_pkg_name		= $(strip $($(PKGV)_NAME))
__embtk_pkg_version		= $(strip $($(PKGV)_VERSION))
__embtk_pkg_site		= $(strip $($(PKGV)_SITE))
__embtk_patch_site		= $(strip $($(PKGV)_PATCH_SITE))
__embtk_pkg_mirror1		= $(strip $($(PKGV)_MIRROR1))
__embtk_pkg_mirror2		= $(strip $($(PKGV)_MIRROR2))
__embtk_pkg_mirror3		= $(strip $($(PKGV)_MIRROR3))
__embtk_pkg_package		= $(strip $($(PKGV)_PACKAGE))
__embtk_pkg_srcdir		= $(strip $($(PKGV)_SRC_DIR))
__embtk_pkg_builddir		= $(strip $($(PKGV)_BUILD_DIR))

__embtk_pkg_etc			= $(strip $($(PKGV)_ETC))
__embtk_pkg_bins		= $(strip $($(PKGV)_BINS))
__embtk_pkg_sbins		= $(strip $($(PKGV)_SBINS))
__embtk_pkg_includes		= $(strip $($(PKGV)_INCLUDES))
__embtk_pkg_libs		= $(strip $($(PKGV)_LIBS))
__embtk_pkg_libexecs		= $(strip $($(PKGV)_LIBEXECS))
__embtk_pkg_pkgconfigs		= $(strip $($(PKGV)_PKGCONFIGS))

__embtk_pkg_configureenv 	= $(strip $($(PKGV)_CONFIGURE_ENV))
__embtk_pkg_setrpath		= $(strip $($(PKGV)_SET_RPATH))
__embtk_pkg_configureopts	= $(strip $($(PKGV)_CONFIGURE_OPTS))
__embtk_pkg_sysrootsuffix	= $(strip $($(PKGV)_SYSROOT_SUFFIX))
__embtk_pkg_prefix		= $(strip $($(PKGV)_PREFIX))
__embtk_pkg_destdir		= $(strip $($(PKGV)_DESTDIR))
__embtk_pkg_deps		= $(strip $($(PKGV)_DEPS))

__embtk_pkg_makedirs		= $(strip $($(PKGV)_MAKE_DIRS))
__embtk_pkg_makeenv		= $(strip $($(PKGV)_MAKE_ENV))
__embtk_pkg_makeopts		= $(strip $($(PKGV)_MAKE_OPTS))

#
# A macro to get packages version from .config file.
# usage: $(call embtk_get_pkgversion,PACKAGE)
#
embtk_get_pkgversion = $(subst ",,$(strip $(CONFIG_EMBTK_$(PKGV)_VERSION_STRING)))

#
# A macro to test if a package is already decompressed.
# It returns y if decompressed and nothing if not.
#
__embtk_pkg_decompressed-y = $(shell test -e $(__embtk_pkg_srcdir)/.decompressed && echo y)

#
# A macro to test if a package is already patched.
# It returns y if patched and nothing if not.
#
__embtk_pkg_patched-y = $(shell test -e $(__embtk_pkg_srcdir)/.patched && echo y)

#
# A macro to test if a package is already configured using autotools configure
# script. It returns y if configured and nothing if not.
#
__embtk_pkg_configured-y = $(shell test -e $(__embtk_pkg_builddir)/.configured && echo y)

#
# A macro to test if a package is already installed.
# It returns y if installed and nothing if not.
#
__installed_f=$(__embtk_pkg_builddir)/.installed
__pkgkconfig_f=$(__embtk_pkg_builddir)/.embtk.$(__embtk_pkg_name).kconfig
__pkgkconfig_f_old=$(__embtk_pkg_builddir)/.embtk.$(__embtk_pkg_name).kconfig.old
__embtk_pkg_installed-y = $(shell						\
	if [ -e $(__installed_f) ] && [ -e $(__pkgkconfig_f) ]; then		\
		cp $(__pkgkconfig_f) $(__pkgkconfig_f_old);			\
		grep 'CONFIG_EMBTK_.*$(PKGV)_.*' $(EMBTK_DOTCONFIG)		\
							> $(__pkgkconfig_f);	\
		cmp -s $(__pkgkconfig_f) $(__pkgkconfig_f_old);			\
		if [ "x$$?" = "x0" ]; then					\
			echo y;							\
		fi;								\
	else									\
		mkdir -p $(__embtk_pkg_builddir);				\
		grep 'CONFIG_EMBTK_.*$(PKGV)_.*' $(EMBTK_DOTCONFIG)		\
							> $(__pkgkconfig_f);	\
	fi;)

#
# A macro which runs configure script (conpatible with autotools configure)
# for a package and sets environment variables correctly.
# Usage:
# $(call embtk_configure_pkg,PACKAGE)
#
define __embtk_configure_autoreconfpkg
if [ "x$(CONFIG_EMBTK_$(PKGV)_NEED_AUTORECONF)" == "xy" ]; then			\
	test -e $(__embtk_pkg_srcdir)/configure.ac ||				\
	test -e $(__embtk_pkg_srcdir)/configure.in || exit 1;			\
	cd $(__embtk_pkg_srcdir);						\
	$(AUTORECONF) --install -f;						\
fi
endef
define __embtk_print_configure_opts
	$(call embtk_echo_blue,"Configure options:")
	for i in `echo $(1) | tr " " "\n"`; \
	do echo -e $(__embtk_color_blue)$$i$(__embtk_no_color); done
endef
define embtk_configure_pkg
	$(call embtk_generic_msg,"Configure $(__embtk_pkg_package)...")
	$(call __embtk_configure_autoreconfpkg,$(1))
	$(Q)test -e $(__embtk_pkg_srcdir)/configure || exit 1
	$(call __embtk_print_configure_opts,"$(__embtk_pkg_configureopts)")
	$(Q)cd $(__embtk_pkg_builddir);						\
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
	PKG_CONFIG="$(PKGCONFIG_BIN)"						\
	PKG_CONFIG_PATH="$(EMBTK_PKG_CONFIG_PATH)"				\
	PKG_CONFIG_LIBDIR="$(EMBTK_PKG_CONFIG_LIBDIR)"				\
	ac_cv_func_malloc_0_nonnull=yes						\
	ac_cv_func_realloc_0_nonnull=yes					\
	$(__embtk_pkg_configureenv)						\
	$(CONFIG_SHELL) $(__embtk_pkg_srcdir)/configure				\
	--build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET)			\
	--target=$(STRICT_GNU_TARGET) --libdir=/usr/$(LIBDIR)			\
	--prefix=/usr --sysconfdir=/etc --disable-rpath				\
	$(__embtk_pkg_configureopts)
	$(Q)touch $(__embtk_pkg_builddir)/.configured
	$(Q)$(call __embtk_kill_lt_rpath,$(__embtk_pkg_builddir))
endef

#
# A macro which runs configure script (conpatible with autotools configure)
# for a package for host development machine and sets environment variables
# correctly.
# Usage:
# $(call embtk_configure_hostpkg,PACKAGE)
#
__embtk_hostpkg_rpathldflags="-Wl,-rpath,$(HOSTTOOLS)/usr/lib"
__embtk_hostpkg_rpath=$(strip $(if $(__embtk_pkg_setrpath),			\
				$(__embtk_hostpkg_rpathldflags)))
define embtk_configure_hostpkg
	$(call embtk_generic_msg,"Configure $(__embtk_pkg_package) for host...")
	$(call __embtk_configure_autoreconfpkg,$(1))
	$(Q)test -e $(__embtk_pkg_srcdir)/configure || exit 1
	$(call __embtk_print_configure_opts,"$(__embtk_pkg_configureopts)")
	$(Q)cd $(__embtk_pkg_builddir);						\
	CPPFLAGS="-I$(HOSTTOOLS)/usr/include"					\
	LDFLAGS="-L$(HOSTTOOLS)/usr/lib $(__embtk_hostpkg_rpath)"		\
	PKG_CONFIG="$(PKGCONFIG_BIN)"						\
	PKG_CONFIG_PATH="$(EMBTK_HOST_PKG_CONFIG_PATH)"				\
	$(if $(call __embtk_mk_strcmp,$(PKGV),CCACHE),,CC=$(HOSTCC_CACHED))	\
	$(if $(call __embtk_mk_strcmp,$(PKGV),CCACHE),,CXX=$(HOSTCXX_CACHED))	\
	$(__embtk_pkg_configureenv)						\
	$(CONFIG_SHELL) $(__embtk_pkg_srcdir)/configure				\
	--build=$(HOST_BUILD) --host=$(HOST_ARCH)				\
	--prefix=$(if $(__embtk_pkg_prefix),$(__embtk_pkg_prefix),$(HOSTTOOLS)/usr)	\
	$(__embtk_pkg_configureopts)
	$(Q)touch $(__embtk_pkg_builddir)/.configured
endef

#
# Various helpers macros for different steps while installing packages.
#
__embtk_multi_make = $(foreach builddir,$(__embtk_pkg_makedirs),		\
				$(__embtk_pkg_makeenv)				\
				$(MAKE) -C $(__embtk_pkg_builddir)/$(builddir)	\
				$(__embtk_pkg_makeopts) $(J);)

__embtk_single_make = $(__embtk_pkg_makeenv) $(MAKE) -C $(__embtk_pkg_builddir)	\
			$(__embtk_pkg_makeopts) $(J)

__embtk_multi_make_install = $(foreach builddir,$(__embtk_pkg_makedirs),	\
	$(__embtk_pkg_makeenv) $(MAKE) -C $(__embtk_pkg_builddir)/$(builddir)	\
	DESTDIR=$(SYSROOT)$(if $(__embtk_pkg_sysrootsuffix),/$(__embtk_pkg_sysrootsuffix)) \
	$(__embtk_pkg_makeopts) install;)

__embtk_single_make_install = $(__embtk_pkg_makeenv)				\
	$(MAKE) -C $(__embtk_pkg_builddir)					\
	DESTDIR=$(SYSROOT)$(if $(__embtk_pkg_sysrootsuffix),/$(__embtk_pkg_sysrootsuffix)) \
	$(__embtk_pkg_makeopts) install

__embtk_multi_make_hostinstall = $(foreach builddir,$(__embtk_pkg_makedirs),	\
	$(__embtk_pkg_makeenv)							\
	$(MAKE) -C $(__embtk_pkg_builddir)/$(builddir)				\
	$(if $(__embtk_pkg_destdir),DESTDIR=$(__embtk_pkg_destdir))		\
	$(__embtk_pkg_makeopts) install;)

__embtk_single_make_hostinstall = $(__embtk_pkg_makeenv)			\
	$(MAKE) -C $(__embtk_pkg_builddir)					\
	$(if $(__embtk_pkg_destdir),DESTDIR=$(__embtk_pkg_destdir))		\
	$(__embtk_pkg_makeopts) install

__embtk_autotoolspkg-y=$(2)
define __embtk_install_pkg_make
	$(call embtk_generic_msg,"Compiling and installing $(__embtk_pkg_name)-$(__embtk_pkg_version) in your root filesystem...")
	$(Q)$(if $(strip $(__embtk_pkg_deps)),$(MAKE) $(__embtk_pkg_deps))
	$(Q)$(call embtk_download_pkg,$(1))
	$(Q)$(call embtk_decompress_pkg,$(1))
	$(Q)$(if $(__embtk_autotoolspkg-y),$(call embtk_configure_pkg,$(1)))
	$(Q)$(if $(__embtk_pkg_makedirs),					\
		$(__embtk_multi_make),						\
		$(__embtk_single_make))
	$(Q)$(if $(__embtk_pkg_makedirs),					\
		$(__embtk_multi_make_install),					\
		$(__embtk_single_make_install))
	$(Q)$(if $(__embtk_autotoolspkg-y),$(call __embtk_fix_libtool_files))
	$(Q)$(if $(__embtk_autotoolspkg-y),$(call __embtk_fix_pkgconfig_files))
	$(Q)touch $(__embtk_pkg_builddir)/.installed
endef
define __embtk_install_hostpkg_make
	$(call embtk_generic_msg,"Compiling and installing $(__embtk_pkg_name)-$(__embtk_pkg_version) for host...")
	$(Q)$(if $(strip $(__embtk_pkg_deps)),$(MAKE) $(__embtk_pkg_deps))
	$(Q)$(call embtk_download_pkg,$(1))
	$(Q)$(call embtk_decompress_hostpkg,$(1))
	$(Q)$(if $(__embtk_autotoolspkg-y),$(call embtk_configure_hostpkg,$(1)))
	$(Q)$(if $(__embtk_pkg_makedirs),					\
		$(__embtk_multi_make),						\
		$(__embtk_single_make))
	$(Q)$(if $(__embtk_pkg_makedirs),					\
		$(__embtk_multi_make_hostinstall),				\
		$(__embtk_single_make_hostinstall))
	$(Q)touch $(__embtk_pkg_builddir)/.installed
endef

#
# A macro to install automatically a package, using autotools scripts, intended
# to run on the target
# Usage:
# $(call embtk_install_pkg,package)
#
define embtk_install_pkg
	$(Q)$(if $(__embtk_pkg_installed-y),					\
		true,$(call __embtk_install_pkg_make,$(1),autotools))
endef

#
# A macro to install automatically a package, using simple Makefile and an
# install target, intented to run on the target.
# Usage:
# $(call embtk_makeinstall_pkg,package)
#
define embtk_makeinstall_pkg
	$(Q)$(if $(__embtk_pkg_installed-y),					\
		true,$(call __embtk_install_pkg_make,$(1)))
endef

#
# A macro to install automatically a package, using autotools scripts, intended
# to run on the host development machine.
# Usage:
# $(call embtk_install_hostpkg,package)
#
define embtk_install_hostpkg
	$(Q)$(if $(__embtk_pkg_installed-y),true,				\
		$(call __embtk_install_hostpkg_make,$(1),autotools))
endef

#
# A macro to install automatically a package, using simple Makefile and an
# install target, intended to run on the host development machine.
# Usage:
# $(call embtk_makeinstall_hostpkg,package)
#
define embtk_makeinstall_hostpkg
	$(Q)$(if $(__embtk_pkg_installed-y),true,				\
		$(call __embtk_install_hostpkg_make,$(1)))
endef

#
# A macro which downloads a package.
# Usage:
# $(call embtk_download_pkg,PACKAGE)
#
define __embtk_download_pkg_patches
if [ "x$(CONFIG_EMBTK_$(PKGV)_NEED_PATCH)" == "xy" ]; then			\
	test -e									\
	$(DOWNLOAD_DIR)/$(__embtk_pkg_name)-$(__embtk_pkg_version).patch ||	\
	$(call embtk_wget,							\
		$(__embtk_pkg_name)-$(__embtk_pkg_version).patch,		\
		$(__embtk_patch_site),						\
		$(__embtk_pkg_name)-$(__embtk_pkg_version)-*.patch);		\
fi
endef
define __embtk_download_pkg_from_mirror
if [ "x$($(PKGV)_SITE_MIRROR$(2))" == "x" ]; then 				\
	false;									\
else										\
	$(call embtk_wget,							\
		$(__embtk_pkg_package),						\
		$($(PKGV)_SITE_MIRROR$(2)),					\
		$(__embtk_pkg_package)); 					\
fi
endef
define embtk_download_pkg
	$(call embtk_generic_msg,"Download $(__embtk_pkg_package) if necessary...")
	$(Q)test -e $(strip $(DOWNLOAD_DIR))/$(__embtk_pkg_package) ||		\
	$(call embtk_wget,							\
		$(__embtk_pkg_package),						\
		$(__embtk_pkg_site),						\
		$(__embtk_pkg_package))||					\
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
	$(call embtk_generic_msg,"Decrompressing $(__embtk_pkg_package) ...")
	$(Q)if [ "x$(CONFIG_EMBTK_$(PKGV)_PKG_IS_TARGZ)" == "xy" ] &&		\
	[ ! -e $(__embtk_pkg_srcdir)/.decompressed ]; then			\
		tar -C $(PACKAGES_BUILD) -xzf					\
		$(DOWNLOAD_DIR)/$(__embtk_pkg_package) &&			\
		mkdir -p $(__embtk_pkg_builddir) &&				\
		touch $(__embtk_pkg_srcdir)/.decompressed;			\
	elif [ "x$(CONFIG_EMBTK_$(PKGV)_PKG_IS_TARBZ2)" == "xy" ] &&		\
	[ ! -e $(__embtk_pkg_srcdir)/.decompressed ]; then			\
		tar -C $(PACKAGES_BUILD) -xjf					\
		$(DOWNLOAD_DIR)/$(__embtk_pkg_package) &&			\
		mkdir -p $(__embtk_pkg_builddir) &&				\
		touch $(__embtk_pkg_srcdir)/.decompressed;			\
	elif [ "x$(CONFIG_EMBTK_$(PKGV)_PKG_IS_TARBZ2)" == "x" ] &&		\
	[ "x$(CONFIG_EMBTK_$(PKGV)_PKG_IS_TARGZ)" == "x" ] &&			\
	[ ! -e $(__embtk_pkg_srcdir)/.decompressed ]; then			\
		echo -e "\E[1;31m!Unknown package compression type!\E[0m";	\
		exit 1;								\
	fi
	$(Q)if [ "x$(CONFIG_EMBTK_$(PKGV)_NEED_PATCH)" == "xy" ] &&		\
	[ ! -e $(__embtk_pkg_srcdir)/.patched ]; then				\
		cd $(__embtk_pkg_srcdir);					\
		patch -p1 <							\
		$(DOWNLOAD_DIR)/$(__embtk_pkg_name)-$(__embtk_pkg_version).patch &&	\
		touch $(__embtk_pkg_srcdir)/.patched;				\
	fi
	$(Q)mkdir -p $(__embtk_pkg_builddir)
endef

#
# A macro to decompress packages tarball intended to run on host development
# machine.
# Usage:
# $(call embtk_decompress_hostpkg,PACKAGE)
#
define embtk_decompress_hostpkg
	$(call embtk_generic_msg,"Decrompressing $(__embtk_pkg_package) ...")
	$(Q)if [ "x$(CONFIG_EMBTK_$(PKGV)_PKG_IS_TARGZ)" == "xy" ] &&		\
	[ ! -e $(__embtk_pkg_srcdir)/.decompressed ]; then			\
		tar -C $(TOOLS_BUILD) -xzf					\
		$(DOWNLOAD_DIR)/$(__embtk_pkg_package) &&			\
		mkdir -p $(__embtk_pkg_builddir) &&				\
		touch $(__embtk_pkg_srcdir)/.decompressed;			\
	elif [ "x$(CONFIG_EMBTK_$(PKGV)_PKG_IS_TARBZ2)" == "xy" ] &&		\
	[ ! -e $(__embtk_pkg_srcdir)/.decompressed ]; then			\
		tar -C $(TOOLS_BUILD) -xjf					\
		$(DOWNLOAD_DIR)/$(__embtk_pkg_package) &&			\
		mkdir -p $(__embtk_pkg_builddir) &&				\
		touch $(__embtk_pkg_srcdir)/.decompressed;			\
	elif [ "x$(CONFIG_EMBTK_$(PKGV)_PKG_IS_TARBZ2)" == "x" ] &&		\
	[ "x$(CONFIG_EMBTK_$(PKGV)_PKG_IS_TARGZ)" == "x" ] &&			\
	[ ! -e $(__embtk_pkg_srcdir)/.decompressed ]; then			\
		echo -e "\E[1;31m!Unknown package compression type!\E[0m";	\
		exit 1;								\
	fi
	$(Q)if [ "x$(CONFIG_EMBTK_$(PKGV)_NEED_PATCH)" == "xy" ] &&		\
	[ ! -e $(__embtk_pkg_srcdir)/.patched ]; then				\
		cd $(__embtk_pkg_srcdir);					\
		patch -p1 <							\
		$(DOWNLOAD_DIR)/$(__embtk_pkg_name)-$(__embtk_pkg_version).patch &&	\
		touch $(__embtk_pkg_srcdir)/.patched;				\
	fi
	$(Q)mkdir -p $(__embtk_pkg_builddir)
endef

#
# A macro to clean installed packages from sysroot.
# Usage:
# $(call embtk_cleanup_pkg,PACKAGE)
#
define embtk_cleanup_pkg
	$(call embtk_generic_message,"Cleanup $(__embtk_pkg_name)...")
	$(Q)-if [ "x$(__embtk_pkg_etc)" != "x" ] && [ -e $(SYSROOT)/etc ];	\
		then								\
		cd $(SYSROOT)/etc; rm -rf $(__embtk_pkg_etc);			\
	fi
	$(Q)-if [ "x$(__embtk_pkg_bins)" != "x" ] && [ -e $(SYSROOT)/usr/bin ];	\
		then								\
		cd $(SYSROOT)/usr/bin; rm -rf $(__embtk_pkg_bins);		\
	fi
	$(Q)-if [ "x$(__embtk_pkg_sbins)" != "x" ] &&				\
	[ -e $(SYSROOT)/usr/sbin ];						\
		then								\
		cd $(SYSROOT)/usr/sbin; rm -rf $(__embtk_pkg_sbins);		\
	fi
	$(Q)-if [ "x$(__embtk_pkg_includes)" != "x" ] &&			\
	[ -e $(SYSROOT)/usr/include ];						\
		then								\
		cd $(SYSROOT)/usr/include; rm -rf $(__embtk_pkg_includes);	\
	fi
	$(Q)-if [ "x$(__embtk_pkg_libs)" != "x" ] &&				\
	[ -e $(SYSROOT)/usr/$(LIBDIR) ];					\
		then								\
		cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(__embtk_pkg_libs);	\
	fi
	$(Q)-if [ "x$(__embtk_pkg_libexecs)" != "x" ] &&			\
	[ -e $(SYSROOT)/usr/$(LIBDIR)/libexec ];				\
		then								\
		cd $(SYSROOT)/usr/$(LIBDIR)/libexec;				\
		rm -rf $(__embtk_pkg_libexecs);					\
	fi
	$(Q)-if [ "x$(__embtk_pkg_pkgconfigs)" != "x" ] &&			\
	[ -e $(SYSROOT)/usr/$(LIBDIR)/pkgconfig ];				\
		then								\
		cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig;				\
		rm -rf $(__embtk_pkg_pkgconfigs);				\
	fi
	$(Q)-rm -rf $(__embtk_pkg_builddir)*
endef
