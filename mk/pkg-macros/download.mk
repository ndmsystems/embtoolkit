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
# \file         download.mk
# \briefd	download.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         January 2014
################################################################################

#
# wget wrapper
# usage: $(call embtk_wget,$(OUTPUT_FILE),$(SITE),$(FOREIGN_FILE))
#
__wget_outfile		= $(patsubst %/,%,$(embtk_dldir))/$(strip $(1))
__wget_remotesite	= $(patsubst %/,%,$(strip $(2)))
__wget_foreignfiles	= $(strip $(3))
__wget_opts		:= --tries=5 --timeout=10 --waitretry=5
__wget_opts		+= --no-check-certificate

define embtk_wget
	wget $(__wget_opts) -O $(__wget_outfile)				\
	$(__wget_remotesite)/$(__wget_foreignfiles) ||				\
	wget $(__wget_opts) --no-passive-ftp -O $(__wget_outfile)		\
	$(__wget_remotesite)/$(__wget_foreignfiles)
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
	$(if $(__embtk_pkg_needpatch),						\
	test -e	$(__embtk_pkg_patch_f) ||					\
	$(call embtk_wget,							\
		$(__embtk_pkg_name)-$(__embtk_pkg_version).patch,		\
		$(__embtk_pkg_patch_site),					\
		$(__embtk_pkg_name)-$(__embtk_pkg_version)-*.patch),true)
endef

define __embtk_download_pkg_exitfailure
	($(call embtk_perror,"On $(notdir $(1)) download!");			\
		$(if $(notdir $(1)),rm -rf $(1);)				\
		exit 1)
endef

define __embtk_svncheckout_pkg
	svn co $(__embtk_pkg_svnsite)/$(__embtk_pkg_svnbranch)			\
			-r$(__embtk_pkg_svnrev)	$(__embtk_pkg_localsvn)
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
	$(call __embtk_svncheckout_pkg,$(1)) ||					\
	$(call __embtk_download_pkg_exitfailure,$(__embtk_pkg_package_f))
	$(call __embtk_download_pkg_patches,$(1)) ||				\
	$(call __embtk_download_pkg_exitfailure,$(__embtk_pkg_patch_f))
	$(call __embtk_applypatch_pkg,$(1))

endef

define __embtk_gitclone_pkg
	(git clone $(__embtk_pkg_gitsite) $(__embtk_pkg_localgit) &&		\
	$(if $(findstring master,$(__embtk_pkg_gitbranch)),,			\
		cd $(__embtk_pkg_localgit);					\
		git checkout -b $(__embtk_pkg_gitbranch)			\
					origin/$(__embtk_pkg_gitbranch) &&)	\
	$(if $(findstring HEAD,$(__embtk_pkg_gitrev)),,				\
		cd $(__embtk_pkg_localgit);					\
		git reset --hard $(__embtk_pkg_gitrev) &&)			\
	true)
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
			patch -p1 --silent < $(__embtk_pkg_patch_f);		\
			$(call __embtk_setpatched_pkg,$(1));			\
		fi,true;)

__embtk_decompress_pkg_exitfailure =						\
	$(call embtk_perror,"!Compression unknown for $(__embtk_pkg_name)!");	\
	exit 1

__embtk_decompress_pkg =							\
	case $(__embtk_pkg_package_f) in					\
		*.tar.bz2 | *.tbz2)						\
			tar -C $(dir $(__embtk_pkg_srcdir)) -xjf		\
						$(__embtk_pkg_package_f)	\
			;;							\
		*.tar.gz | *.tgz)						\
			tar -C $(dir $(__embtk_pkg_srcdir)) -xzf		\
						$(__embtk_pkg_package_f)	\
			;;							\
		*.tar.xz)							\
			tar -C $(dir $(__embtk_pkg_srcdir)) -xJf		\
						$(__embtk_pkg_package_f)	\
			;;							\
		*.tar)								\
			tar -C $(dir $(__embtk_pkg_srcdir)) -xf			\
						$(__embtk_pkg_package_f)	\
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
			$(call __embtk_setdecompressed_pkg,$(1)) &&		\
			$(call __embtk_applypatch_pkg,$(1))			\
		fi)
endef
