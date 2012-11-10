################################################################################
# Embtoolkit
# Copyright(C) 2011-2012 Abdoulaye Walsimou GAYE.
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
# \date         September 2011
################################################################################

#
# wget wrapper
# usage: $(call embtk_wget,$(OUTPUT_FILE),$(SITE),$(FOREIGN_FILE))
#
__wget_outfile		= $(patsubst %/,%,$(embtk_dldir))/$(strip $(1))
__wget_remotesite	= $(patsubst %/,%,$(strip $(2)))
__wget_foreignfiles	= $(strip $(3))
__wget_opts		= --tries=5 --timeout=10 --waitretry=5
define embtk_wget
	wget $(__wget_opts) -O $(__wget_outfile)				\
	$(__wget_remotesite)/$(__wget_foreignfiles) ||				\
	wget $(__wget_opts) --no-passive-ftp -O $(__wget_outfile)		\
	$(__wget_remotesite)/$(__wget_foreignfiles)
endef

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

#
# Define here which make program to use in MAKE.
# FIXME: On some systems, gnu make is named gmake (ie FreeBSD)
#
__embtk_make_cmd	:= make
__embtk_make_env	:=  $(if $(V),MAKEFLAGS="",MAKEFLAGS="--no-print-directory --silent")
MAKE			:= $(__embtk_make_env) $(__embtk_make_cmd)

#Macro to adapt libtool files (*.la) for cross compiling
__ltlibdirold		= libdir='\/usr\/$(LIBDIR)\(.*\)'
__ltlibdirnew		= libdir='$(embtk_sysroot)\/usr\/$(LIBDIR)\1'
__lt_usr/lib		= $(embtk_space)\/usr\/$(LIBDIR)\/
__lt_sysroot/usr/lib	= $(embtk_space)$(embtk_sysroot)\/usr\/$(LIBDIR)\/
__lt_path		= $(addprefix $(embtk_sysroot)/usr/,$(or $(1),$(LIBDIR)))
define __embtk_fix_libtool_files
	__lt_las=`find $(__lt_path) -name *.la`;				\
	for la in $$__lt_las; do						\
		sed -i "s;$(__ltlibdirold);$(__ltlibdirnew);" $$la;		\
		sed -i "s;$(__lt_usr/lib);$(__lt_sysroot/usr/lib);g" $$la;	\
	done
endef
libtool_files_adapt:
	$(Q)$(call __embtk_fix_libtool_files)

# Macro to adapt pkg-config files for cross compiling
__pkgconfig_includedir	= includedir=$(embtk_sysroot)/usr/include
__pkgconfig_prefix	= prefix=$(embtk_sysroot)/usr
__pkgconfig_libdir	= libdir=$(embtk_sysroot)/usr/$(LIBDIR)
define __embtk_fix_pkgconfig_files
	__conf_files0=$$(find $(embtk_sysroot)/usr/$(LIBDIR)/pkgconfig -name *.pc);	\
	__conf_files1=$$(find $(embtk_sysroot)/usr/share/pkgconfig -name *.pc);	\
	for i in $$__conf_files0 $$__conf_files1; do				\
		sed -e 's;prefix=.*;$(__pkgconfig_prefix);'			\
		-e 's;includedir=$${prefix}/include;$(__pkgconfig_includedir);'	\
		-e 's;libdir=.*;$(__pkgconfig_libdir);' < $$i > $$i.new;	\
		mv $$i.new $$i;							\
	done
endef

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
pkgv				= $(strip $(shell echo $(1) | tr A-Z a-z))
__embtk_pkg_name		= $(strip $($(PKGV)_NAME))
__embtk_pkg_needpatch		= $(CONFIG_EMBTK_$(PKGV)_NEED_PATCH)
__embtk_pkg_site		= $(strip $($(PKGV)_SITE))
__embtk_patch_site		= ftp://ftp.embtoolkit.org/embtoolkit.org
__embtk_patch_url		= $(__embtk_patch_site)/$(__embtk_pkg_name)/$(__embtk_pkg_version)
__embtk_pkg_patch_site		= $(strip $(or $($(PKGV)_PATCH_SITE),$(__embtk_patch_url)))
__embtk_pkg_patch_f		= $(strip $(embtk_dldir))/$(__embtk_pkg_name)-$(__embtk_pkg_version).patch
__embtk_pkg_mirror		= $(__embtk_patch_site)/packages-mirror
__embtk_pkg_mirror1		= $(strip $($(PKGV)_MIRROR1))
__embtk_pkg_mirror2		= $(strip $($(PKGV)_MIRROR2))
__embtk_pkg_mirror3		= $(strip $($(PKGV)_MIRROR3))
__embtk_pkg_package		= $(strip $($(PKGV)_PACKAGE))

__embtk_pkg_refspec		= $(call __embtk_mk_uquote,$(CONFIG_EMBTK_$(PKGV)_REFSPEC))

__embtk_pkg_usesvn		= $(if $(CONFIG_EMBTK_$(PKGV)_VERSION_SVN),svn)
__embtk_pkg_svnsite		= $(or $(call __embtk_mk_uquote,$(CONFIG_EMBTK_$(PKGV)_SVN_SITE)),$(strip $($(PKGV)_SVN_SITE)))
__embtk_pkg_svnbranch		= $(call __embtk_mk_uquote,$(CONFIG_EMBTK_$(PKGV)_SVN_BRANCH))
__embtk_pkg_svnrev		= $(call __embtk_mk_uquote,$(CONFIG_EMBTK_$(PKGV)_SVN_REVISION))
__embtk_pkg_localsvn		= $(strip $(if $(__embtk_pkg_usesvn),		\
	$(EMBTK_ROOT)/src/$(__embtk_pkg_refspec)/$(__embtk_pkg_name)-$(notdir $(__embtk_pkg_svnbranch)).svn))

__embtk_pkg_usegit		= $(if $(CONFIG_EMBTK_$(PKGV)_VERSION_GIT),git)
__embtk_pkg_gitsite		= $(or $(call __embtk_mk_uquote,$(CONFIG_EMBTK_$(PKGV)_GIT_SITE)),$(strip $($(PKGV)_GIT_SITE)))
__embtk_pkg_gitbranch		= $(or $(call __embtk_mk_uquote,$(CONFIG_EMBTK_$(PKGV)_GIT_BRANCH)),master)
__embtk_pkg_gitrev		= $(or $(call __embtk_mk_uquote,$(CONFIG_EMBTK_$(PKGV)_GIT_REVISION)),HEAD)
__embtk_pkg_localgit		= $(strip $(if $(__embtk_pkg_usegit),		\
	$(EMBTK_ROOT)/src/$(__embtk_pkg_refspec)/$(__embtk_pkg_name).git))

__embtk_pkg_version		= $(or $(strip $($(PKGV)_VERSION)),$(__embtk_pkg_usegit),$(__embtk_pkg_usesvn))

__embtk_pkg_package_f		= $(strip $(embtk_dldir))/$(__embtk_pkg_package)
__embtk_pkg_srcdir		= $(or $(__embtk_pkg_localgit),$(__embtk_pkg_localsvn),$(patsubst %/,%,$(strip $($(PKGV)_SRC_DIR))))
__embtk_pkg_builddir		= $(patsubst %/,%,$(strip $($(PKGV)_BUILD_DIR)))

__embtk_pkg_etc			= $(strip $($(PKGV)_ETC))
__embtk_pkg_bins		= $(strip $($(PKGV)_BINS))
__embtk_pkg_sbins		= $(strip $($(PKGV)_SBINS))
__embtk_pkg_includes		= $(strip $($(PKGV)_INCLUDES))
__embtk_pkg_libs		= $(strip $($(PKGV)_LIBS))
__embtk_pkg_libexecs		= $(strip $($(PKGV)_LIBEXECS))
__embtk_pkg_pkgconfigs		= $(strip $($(PKGV)_PKGCONFIGS))
__embtk_pkg_shares		= $(strip $($(PKGV)_SHARES))

__embtk_pkg_configureenv 	= $(strip $($(PKGV)_CONFIGURE_ENV))
__embtk_pkg_setrpath		= $(strip $($(PKGV)_SET_RPATH))
__embtk_pkg_configureopts	= $(strip $($(PKGV)_CONFIGURE_OPTS))
__embtk_pkg_sysrootsuffix	= $(strip $($(PKGV)_SYSROOT_SUFFIX))
__embtk_pkg_prefix		= $(strip $($(PKGV)_PREFIX))
__embtk_pkg_destdir		= $(strip $($(PKGV)_DESTDIR))
__embtk_pkg_nodestdir		= $(strip $($(PKGV)_NODESTDIR))
__embtk_pkg_deps		= $(strip $($(PKGV)_DEPS))
__embtk_pkg_depspkgv		= $(sort $(patsubst %_install,%,$(__embtk_pkg_deps)))
___embtk_pkg_kconfigsname	= $(strip $(or $($(PKGV)_KCONFIGS_NAME),$(PKGV)))
__embtk_pkg_kconfigsname	= $(patsubst %_HOST,%,$(___embtk_pkg_kconfigsname))

__embtk_pkg_makedirs		= $(strip $($(PKGV)_MAKE_DIRS))
__embtk_pkg_makeenv		= $(strip $($(PKGV)_MAKE_ENV))
__embtk_pkg_makeopts		= $(strip $($(PKGV)_MAKE_OPTS))

# Some embtoolkit internal files for packages
__embtk_pkg_dotdecompressed_f	= $(__embtk_pkg_srcdir)/.$(__embtk_pkg_name).embtk.decompressed
__embtk_pkg_dotpatched_f	= $(__embtk_pkg_srcdir)/.$(__embtk_pkg_name).embtk.patched
__embtk_pkg_dotconfigured_f	= $(__embtk_pkg_builddir)/.$(__embtk_pkg_name).embtk.configured
__embtk_pkg_dotinstalled_f	= $(__embtk_pkg_builddir)/.$(__embtk_pkg_name).embtk.installed
__embtk_pkg_dotpkgkconfig_f	= $(__embtk_pkg_builddir)/.$(__embtk_pkg_name).embtk.kconfig

# Some useful macros about packages
__embtk_rootfs_pkgs-y		= $(patsubst %_install,%,$(ROOTFS_COMPONENTS-y))
__embtk_rootfs_nrpkgs-y		= $(words $(__embtk_rootfs_pkgs-y))

__embtk_hosttools_pkgs-y	= $(patsubst %_install,%,$(HOSTTOOLS_COMPONENTS-y))
__embtk_hosttools_nrpkgs-y	= $(words $(__embtk_hosttools_pkgs-y))

__embtk_rootfs_pkgs-n		= $(patsubst %_install,%,$(ROOTFS_COMPONENTS-))
__embtk_rootfs_nrpkgs-n		= $(words $(__embtk_rootfs_pkgs-n))

__embtk_hosttools_pkgs-n	= $(patsubst %_install,%,$(HOSTTOOLS_COMPONENTS-))
__embtk_hosttools_nrpkgs-n	= $(words $(__embtk_hosttools_pkgs-n))

__embtk_pkgs_all-y		= $(__embtk_rootfs_pkgs-y) $(__embtk_hosttools_pkgs-y)
__embtk_pkgs_nrall-y		= $(words $(__embtk_pkgs_all-y))

#
# A macro to get packages version from .config file.
# usage: $(call embtk_get_pkgversion,PACKAGE)
#
embtk_get_pkgversion = $(call __embtk_mk_uquote,$(CONFIG_EMBTK_$(PKGV)_VERSION_STRING))


#
# A macro to test if a package is already decompressed.
#
__embtk_pkg_decompressed-y	= $(call __embtk_mk_pathexist,$(__embtk_pkg_dotdecompressed_f))
__embtk_pkg_notdecompressed-y	= $(call __embtk_mk_pathnotexist,$(__embtk_pkg_dotdecompressed_f))

#
# A macro to test if a package is already patched.
#
__embtk_pkg_patched-y		= $(call __embtk_mk_pathexist,$(__embtk_pkg_dotpatched_f))
__embtk_pkg_notpatched-y	= $(call __embtk_mk_pathnotexist,$(__embtk_pkg_dotpatched_f))

#
# A macro to test if a package is already configured using autotools configure
# script.
#
__embtk_pkg_configured-y	= $(call __embtk_mk_pathexist,$(__embtk_pkg_dotconfigured_f))
__embtk_pkg_notconfigured-y	= $(call __embtk_mk_pathnotexist,$(__embtk_pkg_dotconfigured_f))

#
# A macro to print kconfig entries of a package
#
__embtk_pkg_printkconfigs	=						\
	grep 'CONFIG_K*EMBTK_.*$(__embtk_pkg_kconfigsname)_.*'			\
	$(EMBTK_DOTCONFIG)

#
# A macro to test if a package is already installed.
# It returns y if installed and nothing if not.
#
__installed_f		= $(__embtk_pkg_dotinstalled_f)
__pkgkconfig_f		= $(__embtk_pkg_dotpkgkconfig_f)
__pkgkconfig_f_old	= $(__embtk_pkg_dotpkgkconfig_f).old
__installed-y-makecmd	= $(MAKE) -i __embtk_$(1)_printmetakconfigs
__embtk_pkg_installed-y = $(shell						\
	if [ -e $(__installed_f) ] && [ -e $(__pkgkconfig_f) ]; then		\
		cp $(__pkgkconfig_f) $(__pkgkconfig_f_old);			\
		$(__installed-y-makecmd) > $(__pkgkconfig_f);			\
		cmp -s $(__pkgkconfig_f) $(__pkgkconfig_f_old);			\
		if [ "x$$?" = "x0" ]; then					\
			echo y;							\
		fi;								\
	else									\
		mkdir -p $(__embtk_pkg_builddir);				\
		$(__installed-y-makecmd) > $(__pkgkconfig_f);			\
	fi;)

#
# A macro which runs configure script (conpatible with autotools configure)
# for a package and sets environment variables correctly.
# Usage:
# $(call embtk_configure_pkg,PACKAGE)
#
define __embtk_configure_autoreconfpkg
if [ "x$(CONFIG_EMBTK_$(PKGV)_NEED_AUTORECONF)" = "xy" ]; then			\
	test -e $(__embtk_pkg_srcdir)/configure.ac ||				\
	test -e $(__embtk_pkg_srcdir)/configure.in || exit 1;			\
	cd $(__embtk_pkg_srcdir);						\
	$(AUTORECONF) --install -f;						\
fi
endef
define __embtk_print_configure_opts
	$(if $(strip $(1)),
	$(call embtk_echo_blue,"Configure options:$(strip $(1))") | sed "s/\(--\)/\n\t\1/g")
	echo
endef
define embtk_configure_pkg
	$(if $(EMBTK_BUILDSYS_DEBUG),
		$(call embtk_pinfo,"Configure $(__embtk_pkg_package)..."))
	$(call __embtk_configure_autoreconfpkg,$(1))
	$(Q)test -e $(__embtk_pkg_srcdir)/configure || exit 1
	$(call __embtk_print_configure_opts,$(__embtk_pkg_configureopts))
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
	LDFLAGS="-L$(embtk_sysroot)/$(LIBDIR) -L$(embtk_sysroot)/usr/$(LIBDIR)"		\
	CPPFLAGS="-I$(embtk_sysroot)/usr/include"					\
	PKG_CONFIG="$(PKGCONFIG_BIN)"						\
	PKG_CONFIG_PATH="$(EMBTK_PKG_CONFIG_PATH)"				\
	PKG_CONFIG_LIBDIR="$(EMBTK_PKG_CONFIG_LIBDIR)"				\
	ac_cv_func_malloc_0_nonnull=yes						\
	ac_cv_func_realloc_0_nonnull=yes					\
	$(__embtk_pkg_configureenv)						\
	$(CONFIG_SHELL) $(__embtk_pkg_srcdir)/configure				\
	--build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET)			\
	--target=$(STRICT_GNU_TARGET) --libdir=/usr/$(LIBDIR)			\
	--prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-rpath	\
	$(__embtk_pkg_configureopts)
	$(Q)touch $(__embtk_pkg_dotconfigured_f)
	$(Q)$(call __embtk_kill_lt_rpath,$(__embtk_pkg_builddir))
endef

#
# A macro which runs configure script (conpatible with autotools configure)
# for a package for host development machine and sets environment variables
# correctly.
# Usage:
# $(call embtk_configure_hostpkg,PACKAGE)
#
__embtk_hostpkg_rpathldflags	= "-Wl,-rpath,$(embtk_htools)/usr/lib"
__embtk_hostpkg_rpath		= $(strip $(if $(__embtk_pkg_setrpath),		\
					$(__embtk_hostpkg_rpathldflags)))

__embtk_hostpkg_ldflags		= -L$(embtk_htools)/usr/lib $(__embtk_hostpkg_rpath)
__embtk_hostpkg_cppflags	= -I$(embtk_htools)/usr/include
define embtk_configure_hostpkg
	$(if $(EMBTK_BUILDSYS_DEBUG),
	$(call embtk_pinfo,"Configure $(__embtk_pkg_package) for host..."))
	$(call __embtk_configure_autoreconfpkg,$(1))
	$(Q)test -e $(__embtk_pkg_srcdir)/configure || exit 1
	$(call __embtk_print_configure_opts,$(__embtk_pkg_configureopts))
	$(Q)cd $(__embtk_pkg_builddir);						\
	CPPFLAGS="$(__embtk_hostpkg_cppflags)"					\
	LDFLAGS="$(__embtk_hostpkg_ldflags)"					\
	PKG_CONFIG="$(PKGCONFIG_BIN)"						\
	PKG_CONFIG_PATH="$(EMBTK_HOST_PKG_CONFIG_PATH)"				\
	$(if $(call __embtk_mk_strcmp,$(PKGV),CCACHE),,CC=$(HOSTCC_CACHED))	\
	$(if $(call __embtk_mk_strcmp,$(PKGV),CCACHE),,CXX=$(HOSTCXX_CACHED))	\
	$(__embtk_pkg_configureenv)						\
	$(CONFIG_SHELL) $(__embtk_pkg_srcdir)/configure				\
	--build=$(HOST_BUILD) --host=$(HOST_ARCH)				\
	--prefix=$(strip $(if $(__embtk_pkg_prefix),				\
				$(__embtk_pkg_prefix),$(embtk_htools)/usr))	\
	$(__embtk_pkg_configureopts)
	$(Q)touch $(__embtk_pkg_dotconfigured_f)
endef

#
# Various helpers macros for different steps while installing packages.
#
__embtk_multi_make = $(foreach builddir,$(__embtk_pkg_makedirs),		\
				$(__embtk_pkg_makeenv)				\
				$(MAKE) -C $(__embtk_pkg_builddir)/$(builddir)	\
				$(J) $(__embtk_pkg_makeopts);)

__embtk_single_make = $(__embtk_pkg_makeenv) $(MAKE) -C $(__embtk_pkg_builddir)	\
			$(J) $(__embtk_pkg_makeopts)

__embtk_multi_make_install = $(foreach builddir,$(__embtk_pkg_makedirs),	\
	$(__embtk_pkg_makeenv) $(MAKE) -C $(__embtk_pkg_builddir)/$(builddir)	\
	$(if $(__embtk_pkg_nodestdir),,						\
		DESTDIR=$(embtk_sysroot)$(if $(__embtk_pkg_sysrootsuffix),/$(__embtk_pkg_sysrootsuffix))) \
	$(__embtk_pkg_makeopts) install;)

__embtk_single_make_install = $(__embtk_pkg_makeenv)				\
	$(MAKE) -C $(__embtk_pkg_builddir)					\
	$(if $(__embtk_pkg_nodestdir),,						\
		DESTDIR=$(embtk_sysroot)$(if $(__embtk_pkg_sysrootsuffix),/$(__embtk_pkg_sysrootsuffix))) \
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
	$(Q)$(if $(__embtk_pkg_deps),$(MAKE) $(__embtk_pkg_deps))
	$(call embtk_pinfo,"Compile/Install $(__embtk_pkg_name)-$(__embtk_pkg_version) in your root filesystem...")
	$(Q)$(call embtk_download_pkg,$(1))
	$(Q)$(call embtk_decompress_pkg,$(1))
	$(Q)$(if $(embtk_beforeinstall_$(pkgv)),$(embtk_beforeinstall_$(pkgv)))
	$(Q)$(if $(__embtk_autotoolspkg-y),$(call embtk_configure_pkg,$(1)))
	$(Q)$(if $(__embtk_pkg_makedirs),					\
		$(__embtk_multi_make),						\
		$(__embtk_single_make))
	$(Q)$(if $(__embtk_pkg_makedirs),					\
		$(__embtk_multi_make_install),					\
		$(__embtk_single_make_install))
	$(Q)$(if $(__embtk_autotoolspkg-y)$(__embtk_pkg_pkgconfigs),
		$(call __embtk_fix_libtool_files)
		$(call __embtk_fix_pkgconfig_files))
	$(Q)touch $(__embtk_pkg_dotinstalled_f)
endef
define __embtk_install_hostpkg_make
	$(Q)$(if $(__embtk_pkg_deps),$(MAKE) $(__embtk_pkg_deps))
	$(call embtk_pinfo,"Compile/Install $(__embtk_pkg_name)-$(__embtk_pkg_version) for host...")
	$(Q)$(call embtk_download_pkg,$(1))
	$(Q)$(call embtk_decompress_pkg,$(1))
	$(if $(embtk_beforeinstall_$(pkgv)),$(embtk_beforeinstall_$(pkgv)))
	$(Q)$(if $(__embtk_autotoolspkg-y),$(call embtk_configure_hostpkg,$(1)))
	$(Q)$(if $(__embtk_pkg_makedirs),					\
		$(__embtk_multi_make),						\
		$(__embtk_single_make))
	$(Q)$(if $(__embtk_pkg_makedirs),					\
		$(__embtk_multi_make_hostinstall),				\
		$(__embtk_single_make_hostinstall))
	$(Q)touch $(__embtk_pkg_dotinstalled_f)
endef

#
# A macro to exit with error when needed package variables not define.
# Usage:
# $(call __embtk_install_paramsfailure,pkgname)
#
define __embtk_install_paramsfailure
	$(call embtk_perror,"!Not all needed variables defined for $(1)!")
	exit 1
endef

__embtk_xinstall_xgitpkg_allvarset-y	= 					\
		$(strip $(if $(__embtk_pkg_usegit),$(__embtk_pkg_gitsite)))

__embtk_xinstall_xsvnpkg_allvarset-y	= $(strip 				\
	$(if $(__embtk_pkg_usesvn),						\
		$(and $(__embtk_pkg_svnsite),$(__embtk_pkg_svnbranch),		\
			$(__embtk_pkg_svnrev))))

__embtk_xinstall_xtarbpkg_allvarset-y	= $(strip				\
	$(if $(__embtk_pkg_usegit)$(__embtk_pkg_usesvn),,			\
		$(and $(__embtk_pkg_site),$(__embtk_pkg_version),		\
			$(__embtk_pkg_package))))

__embtk_xinstall_xpkg_allvarset-y = $(and $(__embtk_pkg_name),			\
	$(__embtk_pkg_srcdir),$(__embtk_pkg_builddir),				\
	$(or $(__embtk_xinstall_xgitpkg_allvarset-y),				\
		$(__embtk_xinstall_xtarbpkg_allvarset-y),			\
		$(__embtk_xinstall_xsvnpkg_allvarset-y)))

#
# A macro to install automatically a package, using autotools scripts, intended
# to run on the target
# Usage:
# $(call embtk_install_pkg,package)
#
define __embtk_install_pkg
	$(if $(__embtk_pkg_installed-y),true,
		$(call __embtk_install_pkg_make,$(1),autotools))
	$(if $(embtk_postinstall_$(pkgv)),$(embtk_postinstall_$(pkgv)))
endef

define embtk_install_pkg
	$(if $(__embtk_xinstall_xpkg_allvarset-y),
		$(or $(embtk_install_$(pkgv)),$(call __embtk_install_pkg,$(1))),
		$(call __embtk_install_paramsfailure,$(1)))
endef

#
# A macro to install automatically a package, using simple Makefile and an
# install target, intented to run on the target.
# Usage:
# $(call embtk_makeinstall_pkg,package)
#
define embtk_makeinstall_pkg
	$(if $(__embtk_xinstall_xpkg_allvarset-y),
		$(if $(__embtk_pkg_installed-y),true,
			$(call __embtk_install_pkg_make,$(1)))
		$(if $(embtk_postinstall_$(pkgv)),$(embtk_postinstall_$(pkgv))),
		$(call __embtk_install_paramsfailure,$(1)))
endef

#
# A macro to install automatically a package, using autotools scripts, intended
# to run on the host development machine.
# Usage:
# $(call embtk_install_hostpkg,package)
#

define __embtk_install_hostpkg
	$(if $(__embtk_pkg_installed-y),true,
		$(call __embtk_install_hostpkg_make,$(1),autotools))
	$(if $(embtk_postinstall_$(pkgv)),$(embtk_postinstall_$(pkgv)))
endef
define embtk_install_hostpkg
	$(if $(__embtk_xinstall_xpkg_allvarset-y),
		$(or $(embtk_install_$(pkgv)),$(call __embtk_install_hostpkg,$(1))),
		$(call __embtk_install_paramsfailure,$(1)))
endef

#
# A macro to install automatically a package, using simple Makefile and an
# install target, intended to run on the host development machine.
# Usage:
# $(call embtk_makeinstall_hostpkg,package)
#
define embtk_makeinstall_hostpkg
	$(if $(__embtk_xinstall_xpkg_allvarset-y),
		$(if $(__embtk_pkg_installed-y),true,
			$(call __embtk_install_hostpkg_make,$(1)))
		$(or $(embtk_postinstall_$(pkgv)),true),
		$(call __embtk_install_paramsfailure,$(1)))
endef

#
# A wrapper macro for embtk_install_hostpkg and embtk_install_pkg, based on
# package name (xxxx or xxxx_host).
#
define embtk_install_xpkg
	$(call embtk_install_$(findstring host,$(1))pkg,$(1))
endef

#
# A macro which downloads a package.
# Usage:
# $(call embtk_download_pkg,PACKAGE)
#

__embtk_pkg_depof = $(strip $(foreach p,$(__embtk_pkgs_all-y) toolchain toolchain_addons,\
		$(if $(findstring $(pkgv),$($(call PKGV,$(p)_deps))),$(p))))

__embtk_pkg_needpatch_yesno = $(if $(__embtk_pkg_needpatch),Yes,No)

define __embtk_download_pkg_patches
if [ "x$(__embtk_pkg_needpatch)" = "xy" ]; then					\
	test -e	$(__embtk_pkg_patch_f) ||					\
	$(call embtk_wget,							\
		$(__embtk_pkg_name)-$(__embtk_pkg_version).patch,		\
		$(__embtk_pkg_patch_site),					\
		$(__embtk_pkg_name)-$(__embtk_pkg_version)-*.patch);		\
fi
endef

define __embtk_download_pkg_exitfailure
	(echo -e "\E[1;31m!Error on $(notdir $(1)) download!\E[0m";rm -rf $(1);	\
	exit 1)
endef

define __embtk_download_pkg_from_svn
	$(call embtk_echo_blue,"$(__embtk_pkg_name) using SVN")
	$(call embtk_echo_blue,"\tBranch        : $(notdir $(__embtk_pkg_svnbranch))")
	$(call embtk_echo_blue,"\tRevision      : $(__embtk_pkg_svnrev)")
	$(call embtk_echo_blue,"\tIn            : $(or $(__embtk_pkg_refspec),src)")
	$(call embtk_echo_blue,"\tCheckout URL  : $(__embtk_pkg_svnsite)")
	$(call embtk_echo_blue,"\tPatched       : $(__embtk_pkg_needpatch_yesno)")
	$(call embtk_echo_blue,"\tDependency of : $(or $(__embtk_pkg_depof),N/A)")
	test -e $(__embtk_pkg_localsvn) ||					\
	svn co $(__embtk_pkg_svnsite)/$(__embtk_pkg_svnbranch)			\
				-r$(__embtk_pkg_svnrev)	$(__embtk_pkg_localsvn)
endef

define __embtk_gitclone_pkg
	git clone $(__embtk_pkg_gitsite) $(__embtk_pkg_localgit)
	$(if $(findstring master,$(__embtk_pkg_gitbranch)),,
		cd $(__embtk_pkg_localgit);					\
		git checkout -b $(__embtk_pkg_gitbranch)			\
					origin/$(__embtk_pkg_gitbranch))
	$(if $(findstring HEAD,$(__embtk_pkg_gitrev)),,
		cd $(__embtk_pkg_localgit);					\
		git reset --hard $(__embtk_pkg_gitrev))
endef

define __embtk_download_pkg_from_git
	$(call embtk_echo_blue,"$(__embtk_pkg_name) using GIT")
	$(call embtk_echo_blue,"\tBranch        : $(__embtk_pkg_gitbranch)")
	$(call embtk_echo_blue,"\tRevision      : $(__embtk_pkg_gitrev)")
	$(call embtk_echo_blue,"\tIn            : $(or $(__embtk_pkg_refspec),src)")
	$(call embtk_echo_blue,"\tClone URL     : $(__embtk_pkg_gitsite)")
	$(call embtk_echo_blue,"\tPatched       : $(__embtk_pkg_needpatch_yesno)")
	$(call embtk_echo_blue,"\tDependency of : $(or $(__embtk_pkg_depof),N/A)")
	test -e $(__embtk_pkg_localgit) || $(call __embtk_gitclone_pkg,$(1))
endef

define __embtk_download_pkg_from_tarball
	$(call embtk_echo_blue,"$(__embtk_pkg_name) using tarball")
	$(call embtk_echo_blue,"\tVersion       : $(__embtk_pkg_version)")
	$(call embtk_echo_blue,"\tFrom          : $(__embtk_pkg_site)")
	$(call embtk_echo_blue,"\tIn            : $(__embtk_pkg_package_f)")
	$(call embtk_echo_blue,"\tPatched       : $(__embtk_pkg_needpatch_yesno)")
	$(call embtk_echo_blue,"\tDependency of : $(or $(__embtk_pkg_depof),N/A)")
	test -e $(__embtk_pkg_package_f) ||					\
	$(call embtk_wget,							\
		$(__embtk_pkg_package),						\
		$(__embtk_pkg_site),						\
		$(__embtk_pkg_package)) ||					\
	$(if $(__embtk_pkg_mirror1),						\
		$(call embtk_wget,						\
			$(__embtk_pkg_package),					\
			$(__embtk_pkg_mirror1),					\
			$(__embtk_pkg_package)),false) ||			\
	$(if $(__embtk_pkg_mirror2),						\
		$(call embtk_wget,						\
			$(__embtk_pkg_package),					\
			$(__embtk_pkg_mirror2),					\
			$(__embtk_pkg_package)),false) ||			\
	$(if $(__embtk_pkg_mirror3),						\
		$(call embtk_wget,						\
			$(__embtk_pkg_package),					\
			$(__embtk_pkg_mirror3),					\
			$(__embtk_pkg_package)),false) ||			\
	$(if $(__embtk_pkg_mirror),						\
		$(call embtk_wget,						\
			$(__embtk_pkg_package),					\
			$(__embtk_pkg_mirror),					\
			$(__embtk_pkg_package)),false) ||			\
	$(call __embtk_download_pkg_exitfailure,$(__embtk_pkg_package_f))
	$(call __embtk_download_pkg_patches,$(1)) ||				\
	$(call __embtk_download_pkg_exitfailure,$(__embtk_pkg_patch_f))
endef

__embtk_pkgdl_src = $(or $(__embtk_pkg_usegit),$(__embtk_pkg_usesvn),tarball)
define embtk_download_pkg
	$(if $(EMBTK_BUILDSYS_DEBUG),
		$(call embtk_pinfo,"Download $(__embtk_pkg_name) if needed..."))
	$(call __embtk_download_pkg_from_$(call __embtk_pkgdl_src,$(1)),$(1))
endef

#
# A macro to decompress packages tarball intended to run on target.
# Usage:
# $(call embtk_decompress_pkg,pkgname)
#

__embtk_applypatch_pkg =							\
	$(if $(__embtk_pkg_needpatch),						\
		if [ ! -e $(__embtk_pkg_dotpatched_f) ]; then			\
			cd $(__embtk_pkg_srcdir);				\
			patch -p1 < $(__embtk_pkg_patch_f);			\
			touch $(__embtk_pkg_dotpatched_f);			\
		fi,true;)

__embtk_decompress_pkg_exitfailure =						\
	$(call embtk_perror,"!Compression unknown for $(__embtk_pkg_name)!");	\
	exit 1

__embtk_decompress_pkg =							\
	case $(__embtk_pkg_package_f) in					\
		*.tar.bz2 | *.tbz2)						\
			tar -C $(dir $(__embtk_pkg_srcdir)) -xjf		\
						$(__embtk_pkg_package_f) &&	\
			mkdir -p $(__embtk_pkg_builddir) &&			\
			touch $(__embtk_pkg_dotdecompressed_f)			\
			;;							\
		*.tar.gz | *.tgz)						\
			tar -C $(dir $(__embtk_pkg_srcdir)) -xzf		\
						$(__embtk_pkg_package_f) &&	\
			mkdir -p $(__embtk_pkg_builddir) &&			\
			touch $(__embtk_pkg_dotdecompressed_f)			\
			;;							\
		*.tar.xz)							\
			tar -C $(dir $(__embtk_pkg_srcdir)) -xJf		\
						$(__embtk_pkg_package_f) &&	\
			mkdir -p $(__embtk_pkg_builddir) &&			\
			touch $(__embtk_pkg_dotdecompressed_f)			\
			;;							\
		*.tar)								\
			tar -C $(dir $(__embtk_pkg_srcdir)) -xf			\
						$(__embtk_pkg_package_f) &&	\
			mkdir -p $(__embtk_pkg_builddir) &&			\
			touch $(__embtk_pkg_dotdecompressed_f)			\
			;;							\
		*)								\
			$(call __embtk_decompress_pkg_exitfailure,$(1))		\
			;;							\
	esac

__embtk_decompress_pkg_msg = $(call embtk_pinfo,"Decrompressing $(__embtk_pkg_package) ...")
define embtk_decompress_pkg
	$(if $(__embtk_pkg_usegit)$(__embtk_pkg_usesvn),true,
		$(if $(EMBTK_BUILDSYS_DEBUG),$(__embtk_decompress_pkg_msg))
		if [ ! -e $(__embtk_pkg_dotdecompressed_f) ]; then		\
			$(call __embtk_decompress_pkg,$(1)) &&			\
			$(call __embtk_applypatch_pkg,$(1))			\
		fi)
	$(Q)mkdir -p $(__embtk_pkg_builddir)
endef

#
# A macro to clean installed packages from sysroot.
# Usage:
# $(call embtk_cleanup_pkg,pkgname)
#
define __embtk_cleanup_pkg
	$(if $(embtk_cleanup_$(pkgv)),$(embtk_cleanup_$(pkgv)))
	$(if $(__embtk_pkg_etc),
		rm -rf $(addprefix $(embtk_sysroot)/etc/,$(__embtk_pkg_etc)))
	$(if $(__embtk_pkg_bins),
		rm -rf $(addprefix $(embtk_sysroot)/usr/bin/,$(__embtk_pkg_bins)))
	$(if $(__embtk_pkg_sbins),
		rm -rf $(addprefix $(embtk_sysroot)/usr/sbin/,$(__embtk_pkg_sbins)))
	$(if $(__embtk_pkg_includes),
		rm -rf $(addprefix $(embtk_sysroot)/usr/include/,$(__embtk_pkg_includes)))
	$(if $(__embtk_pkg_libs),
		rm -rf $(addprefix $(embtk_sysroot)/usr/$(LIBDIR)/,$(__embtk_pkg_libs)))
	$(if $(__embtk_pkg_libexecs),
		rm -rf $(addprefix $(embtk_sysroot)/usr/libexec/,$(__embtk_pkg_libexecs)))
	$(if $(__embtk_pkg_pkgconfigs),
		rm -rf $(addprefix $(embtk_sysroot)/usr/$(LIBDIR)/pkgconfig/,$(__embtk_pkg_pkgconfigs))
		rm -rf $(addprefix $(embtk_sysroot)/usr/share/pkgconfig/,$(__embtk_pkg_pkgconfigs)))
	$(if $(__embtk_pkg_shares),
		rm -rf $(addprefix $(embtk_sysroot)/usr/share/,$(__embtk_pkg_shares)))
	$(if $(__embtk_pkg_usegit)$(__embtk_pkg_usesvn),
		rm -rf $(__embtk_pkg_dotconfigured_f)
		rm -rf $(__embtk_pkg_dotinstalled_f),
		$(if $(__embtk_pkg_builddir),rm -rf $(__embtk_pkg_builddir)*))
endef

define embtk_cleanup_pkg
	$(if $(EMBTK_BUILDSYS_DEBUG),
		$(call embtk_pinfo,"Cleanup $(__embtk_pkg_name)..."))
	$(Q)$(call __embtk_cleanup_pkg,$(1))
endef

#
# Implicit rule to print a package and its dependencies kconfig entries.
#
__embtk_%_printmetakconfigs:
	$(call __embtk_pkg_printkconfigs,$*)
	$(foreach dep,$(call __embtk_pkg_depspkgv,$*),				\
		$(call __embtk_pkg_printkconfigs,$(dep));)
