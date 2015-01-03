################################################################################
# Embtoolkit
# Copyright(C) 2014 Abdoulaye Walsimou GAYE.
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
# \file         install.mk
# \brief	install.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         January 2014
################################################################################

#
# Define here which make program to use in MAKE.
# FIXME: On some systems, gnu make is named gmake (ie FreeBSD)
#
__embtk_make_cmd	:= make
ifeq ($(findstring bsd,$(HOST_ARCH)),bsd)
__embtk_make_cmd	:= gmake
endif

__embtk_make_env	:= $(if $(V),MAKEFLAGS="",MAKEFLAGS="--no-print-directory --silent")
MAKE			= $(__embtk_make_env) $(__embtk_pkg_scanbuild) $(__embtk_make_cmd)


# Some embtoolkit internal files for packages
__embtk_pkg_dotdecompressed_f	= $(__embtk_pkg_srcdir)/.embtk.decompressed
__embtk_pkg_dotpatched_f	= $(__embtk_pkg_srcdir)/.embtk.patched
__embtk_pkg_dotconfigured_f	= $(__embtk_pkg_statedir)/.embtk.configured
__embtk_pkg_dotinstalled_f	= $(__embtk_pkg_statedir)/.embtk.installed
__embtk_pkg_dotkconfig_f	= $(__embtk_pkg_statedir)/.embtk.kconfig

__embtk_setdecompressed_pkg	= touch $(__embtk_pkg_dotdecompressed_f)
__embtk_unsetdecompressed_pkg	= rm -rf $(__embtk_pkg_dotdecompressed_f)
__embtk_setpatched_pkg		= touch $(__embtk_pkg_dotpatched_f)
__embtk_unsetpatched_pkg	= rm -rf $(__embtk_pkg_dotpatched_f)
__embtk_setconfigured_pkg	= mkdir -p $(__embtk_pkg_statedir) && touch $(__embtk_pkg_dotconfigured_f)
__embtk_unsetconfigured_pkg	= rm -rf $(__embtk_pkg_dotconfigured_f)
__embtk_setinstalled_pkg	= mkdir -p $(__embtk_pkg_statedir) && touch $(__embtk_pkg_dotinstalled_f)
__embtk_unsetinstalled_pkg	= rm -rf $(__embtk_pkg_dotinstalled_f)
__embtk_setkconfigured_pkg	= mkdir -p $(__embtk_pkg_statedir) && touch $(__embtk_pkg_dotkconfig_f)
__embtk_unsetkconfigured_pkg	= rm -rf $(__embtk_pkg_dotkconfig_f)

ifeq ($(CONFIG_EMBTK_WIPEOUTWORKSPACES),y)
define __embtk_wipeoutworkspace_pkg
	$(if $(__embtk_pkg_usegit)$(__embtk_pkg_usesvn)$(__embtk_pkg_nowipeworkspace),,
		$(if $(__embtk_pkg_builddir),rm -rf $(__embtk_pkg_builddir))
		$(if $(__embtk_pkg_srcdir),rm -rf $(__embtk_pkg_srcdir)))
endef
endif

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

__embtk_pkg_depof = $(strip $(sort $(___embtk_pkg_depof)))
define ___embtk_pkg_depof
	$(foreach p,$(__embtk_pkgs_all-y) $(__embtk_toolchain_deps-y) $(__embtk_toolchain_predeps-y) $(__embtk_toolchain_addons-y),
		$(if $(findstring $(pkgv)_install,$($(call PKGV,$(p)_deps))),$(p)))
endef

#
# A macro to get packages version from .config file.
# usage: $(call embtk_get_pkgversion,PACKAGE)
#
embtk_pkg_version    = $(call __embtk_mk_uquote,$(CONFIG_EMBTK_$(PKGV)_VERSION_STRING))
embtk_get_pkgversion = $(embtk_pkg_version)


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
# A macro to generate a package __embtk_pkg_dotkconfig_f file.
#
define __embtk_pkg_gen_dotkconfig_f
	printf '__embtk_$(pkgv)_okconfigs      := %s\n'				\
		'$(call embtk_shell_quote,$(__embtk_pkg_kconfigs_all_v))'	\
		> $(__embtk_pkg_dotkconfig_f)
	printf '__embtk_$(pkgv)_oconfigureopts := %s\n'				\
		'$(call embtk_shell_quote,$(__embtk_pkg_configureopts))'	\
		>> $(__embtk_pkg_dotkconfig_f)
endef

#
# A macro to test if a package build recipe needs to be run or not.
#
__embtk_pkg_runrecipe-y		= $(or $(__embtk_pkg_ninstalled-y),$(__embtk_pkg_confchanged-y),$(__embtk_pkg_configurechanged-y))
__embtk_pkg_installed-y		= $(or $(__embtk_$(pkgv)_installed),$(wildcard $(__embtk_pkg_dotinstalled_f)))
__embtk_pkg_ninstalled-y	= $(if $(__embtk_pkg_installed-y),,y)
__embtk_pkg_confchanged-y	= $(call __embtk_strneq,$(__embtk_pkg_kconfigs_all_v),$(__embtk_$(pkgv)_okconfigs))
__embtk_pkg_configurechanged-y	= $(call __embtk_strneq,$(__embtk_pkg_configureopts),$(__embtk_$(pkgv)_oconfigureopts))

#
# Various helpers macros for different steps while installing packages.
#
__embtk_multi_make = $(foreach builddir,$(__embtk_pkg_makedirs),		\
			$(__embtk_pkg_makeenv)					\
			$(MAKE) -C $(__embtk_pkg_builddir)/$(builddir)		\
			$(J) $(__embtk_pkg_makeopts);)

__embtk_single_make = $(__embtk_pkg_makeenv)					\
			$(MAKE) -C $(__embtk_pkg_builddir)			\
			$(J) $(__embtk_pkg_makeopts)


__embtk_multi_make_install = $(foreach builddir,$(__embtk_pkg_makedirs),	\
	$(__embtk_pkg_makeenv) $(filter-out $(__embtk_pkg_scanbuild),$(MAKE))	\
		 -C $(__embtk_pkg_builddir)/$(builddir)				\
	$(if $(__embtk_pkg_nodestdir),,						\
		DESTDIR=$(embtk_sysroot)$(if $(__embtk_pkg_sysrootsuffix),/$(__embtk_pkg_sysrootsuffix))) \
	$(__embtk_pkg_makeopts) install;)

__embtk_single_make_install = $(__embtk_pkg_makeenv)				\
	$(filter-out $(__embtk_pkg_scanbuild),$(MAKE))				\
		-C $(__embtk_pkg_builddir)					\
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

define __embtk_install_pkgdeps
	$(if $(__embtk_pkg_deps),$(MAKE) $(__embtk_pkg_deps))
endef

define __embtk_preinstall_pkg
	$(call __embtk_install_pkgdeps,$(1))
	$(call embtk_pinfo,"Compile/Install $(__embtk_pkg_name)-$(__embtk_pkg_version) in target system...")
	mkdir -p $(__embtk_pkg_builddir)
	$(call embtk_download_pkg,$(1))
	$(call embtk_decompress_pkg,$(1))
	$(embtk_beforeinstall_$(pkgv))
endef
define __embtk_preinstall_hostpkg
	$(call __embtk_install_pkgdeps,$(1))
	$(call embtk_pinfo,"Compile/Install $(__embtk_pkg_name)-$(__embtk_pkg_version) for host...")
	mkdir -p $(__embtk_pkg_builddir)
	$(call embtk_download_pkg,$(1))
	$(call embtk_decompress_pkg,$(1))
	$(embtk_beforeinstall_$(pkgv))
endef
define __embtk_postinstall_pkg
	$(call __embtk_setinstalled_pkg,$(1))
	$(call __embtk_pkg_gen_dotkconfig_f,$(1))
	$(eval __embtk_$(pkgv)_installed = y)
	$(embtk_postinstallonce_$(pkgv))
	$(call __embtk_wipeoutworkspace_pkg,$(1))
endef

__embtk_autotoolspkg-y=$(2)
define __embtk_install_pkg_make
	$(if $(__embtk_autotoolspkg-y),$(call embtk_configure_pkg,$(1)))
	$(if $(__embtk_pkg_makedirs),						\
		$(__embtk_multi_make),						\
		$(__embtk_single_make))
	$(if $(__embtk_pkg_makedirs),						\
		$(__embtk_multi_make_install),					\
		$(__embtk_single_make_install))
	$(if $(__embtk_autotoolspkg-y)$(__embtk_pkg_pkgconfigs),
		$(call __embtk_fix_libtool_files)
		$(call __embtk_fix_pkgconfig_files))
endef
define __embtk_install_hostpkg_make
	$(if $(__embtk_autotoolspkg-y),$(call embtk_configure_hostpkg,$(1)))
	$(if $(__embtk_pkg_makedirs),						\
		$(__embtk_multi_make),						\
		$(__embtk_single_make))
	$(if $(__embtk_pkg_makedirs),						\
		$(__embtk_multi_make_hostinstall),				\
		$(__embtk_single_make_hostinstall))
endef

__embtk_waf_build	= cd $(__embtk_pkg_srcdir); ./waf build $(J) --progress

__embtk_waf_install	= cd $(__embtk_pkg_srcdir); ./waf install --progress	\
	$(if $(__embtk_pkg_nodestdir),,						\
		--destdir=$(embtk_sysroot)$(if $(__embtk_pkg_sysrootsuffix),/$(__embtk_pkg_sysrootsuffix)))

__embtk_waf_hostinstall	= cd $(__embtk_pkg_srcdir); ./waf install --progress	\
	$(if $(__embtk_pkg_destdir),--destdir=$(__embtk_pkg_destdir))

define __embtk_install_pkg_waf
	$(call embtk_wafconfigure_pkg,$(1))
	$(call __embtk_waf_build,$(1))
	$(call __embtk_waf_install,$(1))
	$(if $(__embtk_pkg_pkgconfigs),
		$(call __embtk_fix_libtool_files)
		$(call __embtk_fix_pkgconfig_files))
endef

define __embtk_install_hostpkg_waf
	$(call embtk_wafconfigure_hostpkg,$(1))
	$(call __embtk_waf_build,$(1))
	$(call __embtk_waf_hostinstall,$(1))
endef

#
# A macro to exit with error when needed package variables not define.
# Usage:
# $(call __embtk_install_paramsfailure,pkgname)
#
define __embtk_install_paramsfailure
	$(call embtk_perror,"!Not all needed variables defined for $(1)!")
	$(call embtk_echo_red,"Summary of variables and their current values")
	$(call embtk_echo_red,"$(PKGV)_NAME                             (needed) = $(or $(__embtk_pkg_name),not set)")
	$(call embtk_echo_red,"$(PKGV)_SITE                  (needed if tarball) = $(or $(__embtk_pkg_site),not set)")
	$(call embtk_echo_red,"$(PKGV)_VERSION               (needed if tarball) = $(or $(__embtk_pkg_version),not set)")
	$(call embtk_echo_red,"$(PKGV)_PACKAGE               (needed if tarball) = $(or $(__embtk_pkg_package),not set)")
	$(call embtk_echo_red,"$(PKGV)_GIT_SITE                  (needed if git) = $(or $(__embtk_pkg_gitsite),not set)")
	$(call embtk_echo_red,"CONFIG_EMBTK_$(PKGV)_VERSION_GIT  (needed if git) = $(or $(__embtk_pkg_usegit),not set)")
	$(call embtk_echo_red,"CONFIG_EMBTK_$(PKGV)_GIT_REVISION (needed if git) = $(or $(__embtk_pkg_gitrev),not set)")
	$(call embtk_echo_red,"CONFIG_EMBTK_$(PKGV)_GIT_BRANCH   (needed if git) = $(or $(__embtk_pkg_gitbranch),not set)")
	$(call embtk_echo_red,"$(PKGV)_SVN_SITE                  (needed if svn) = $(or $(__embtk_pkg_svnsite),not set)")
	$(call embtk_echo_red,"CONFIG_EMBTK_$(PKGV)_VERSION_SVN (needed if svn)  = $(or $(__embtk_pkg_usesvn),not set)")
	$(call embtk_echo_red,"CONFIG_EMBTK_$(PKGV)_SVN_REVISION (needed if svn) = $(or $(__embtk_pkg_svnrev),not set)")
	$(call embtk_echo_red,"CONFIG_EMBTK_$(PKGV)_SVN_BRANCH   (needed if svn) = $(or $(__embtk_pkg_svnbranch),not set)")
	$(call embtk_echo_red,"$(PKGV)_SRC_DIR               (needed if tarball) = $(or $(__embtk_pkg_srcdir),not set)")
	$(call embtk_echo_red,"$(PKGV)_BUILD_DIR                      (optional) = $(or $(__embtk_pkg_builddir),not set)")

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
# A macro to automatically install a package intended to run on the target,
# using autotools script.
# Usage:
# $(call embtk_install_pkg,package)
#
define embtk_install_pkg
	$(if $(__embtk_xinstall_xpkg_allvarset-y),
		$(Q)$(call __embtk_install_pkg,$(1)),
		$(call __embtk_install_paramsfailure,$(1)))
endef
define __embtk_install_pkg
	$(if $(__embtk_pkg_runrecipe-y),
		$(call __embtk_preinstall_pkg,$(1))
		$(or $(embtk_install_$(pkgv)),$(call ___embtk_install_pkg,$(1)))
		$(call __embtk_postinstall_pkg,$(1)))
	$(embtk_postinstall_$(pkgv))
endef
define ___embtk_install_pkg
	$(if $(__embtk_pkg_usewaf-y),
		$(call __embtk_install_pkg_waf,$(1)),
		$(call __embtk_install_pkg_make,$(1),autotools))
endef
#
# A macro to automatically install a package intended to run on the target,
# using simple Makefile and an nstall target.
# Usage:
# # autotooled: add this optional string to install an autotooled package
# $(call embtk_makeinstall_pkg,package[,autotooled])
#
define embtk_makeinstall_pkg
	$(Q)$(call __embtk_install_pkg_make,$(1),$(2))
endef

#
# A macro to automatically install a package intended to run on the host
# development machine, using autotools scripts.
# Usage:
# $(call embtk_install_hostpkg,package)
#
define embtk_install_hostpkg
	$(if $(__embtk_xinstall_xpkg_allvarset-y),
		$(Q)$(call __embtk_install_hostpkg,$(1)),
		$(call __embtk_install_paramsfailure,$(1)))
endef
define __embtk_install_hostpkg
	$(if $(__embtk_pkg_runrecipe-y),
		$(call __embtk_preinstall_hostpkg,$(1))
		$(or $(embtk_install_$(pkgv)),$(call ___embtk_install_hostpkg,$(1)))
		$(call __embtk_postinstall_pkg,$(1)))
	$(embtk_postinstall_$(pkgv))
endef
define ___embtk_install_hostpkg
	$(if $(__embtk_pkg_usewaf-y),
		$(call __embtk_install_hostpkg_waf,$(1)),
		$(call __embtk_install_hostpkg_make,$(1),autotools))
endef

#
# A macro to automatically install a package intended to run on the host
# development machine, using simple Makefile and an install target.
# Usage:
# autotooled: add this optional string to install an autotooled package
# $(call embtk_makeinstall_hostpkg,package[,autotooled])
#
define embtk_makeinstall_hostpkg
	$(Q)$(call __embtk_install_hostpkg_make,$(1),$(2))
endef

#
# A wrapper macro for embtk_install_hostpkg and embtk_install_pkg, based on
# package name (xxxx or xxxx_host).
# Usage:
# $(call embtk_install_xpkg,xxxx)
#
define embtk_install_xpkg
	$(call embtk_install_$(findstring host,$(1))pkg,$(1))
endef
